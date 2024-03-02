---
id: 14f0fc08-af1d-44bb-a213-a2c818b163ab
---

# ART上的动态Java方法hook框架 - 残页的小博客
#Omnivore

[Read on Omnivore](https://omnivore.app/me/art-java-hook-18ca400be10)
[Read Original](https://blog.canyie.top/2020/04/27/dynamic-hooking-framework-on-art/)

大家应该还记得我上次介绍的[Dreamland](https://blog.canyie.top/2020/02/03/a-new-xposed-style-framework/)吧，忘记了也没事，简单介绍一下：这是一个类似Xposed的框架，可以注入应用进程并进行方法hook。进程注入上次已经说过了，另一个重点hook当时是使用了[SandHook框架](https://github.com/ganyao114/SandHook)，这是一款非常优秀的hook框架，但是有点问题，不太适合Dreamland；在比较了其他hook框架之后，发现似乎都存在一些问题，最终决定自己动手写一个。已经开源，代码在这：[Pine](https://github.com/canyie/pine)，接下来我会介绍它的具体实现。

## [](#其他框架的一些问题 "其他框架的一些问题")其他框架的一些问题

**注：这里并没有贬低其他框架的意思，只是单纯的比较**  
现在是2020年，ART Hook框架已经非常多，但是肯定不是随便拿一个就能用的；我们需要一个能提供Xposed-style hook接口的框架，Xposed的hook接口只要求提供一个callback，是完全动态的，而像[YAHFA](https://github.com/PAGalaxyLab/YAHFA)这样的框架则要求提供一个与目标方法参数与返回值都相同的方法，如果需要调用原方法还需要提供一个backup方法，无法直接做到像Xposed那样的风格的hook。  
这样一过滤，剩下的框架就不多了，挑出了几个框架：

* [Whale](https://github.com/asLody/whale)，原理是设置目标方法为native，然后用libffi动态生成一个处理函数，设置entry\_point\_from\_jni为这个处理函数。这个框架可以直接像Xposed那样hook，不过实测不太稳定，比如在bridge里随便抛个异常（即使被try-catch住）就会导致Runtime直接abort。[Frida](https://github.com/frida/frida)/[AndHook](https://github.com/asLody/AndHook)似乎也是一样的套路，应该也会有这个问题。
* [SandHook](https://github.com/ganyao114/SandHook)，这个框架对Xposed兼容自带有两种方案：一是用DexMaker动态生成bridge函数，没有什么兼容性问题，但是第一次加载的时候会很慢；二是用动态代理生成bridge方法，这个bridge方法用像whale一样的方案：设置native，libffi动态生成native处理函数，设置entry\_point\_from\_jni。这个方案用起来很快，但是存在挺多坑，稳定性存疑。
* [FastHook](https://github.com/turing-technician/FastHook)，根据调用约定在栈里捞参数，作者宣称它“高效稳定、简洁易用”，然而试了下，并不稳定，而且提供的hook接口很难用（一个通用接口有7个参数），而且作者现在似乎不维护了，emmm
* [Epic](https://github.com/tiann/epic)，根据调用约定从寄存器和栈里解析参数，[VirtualXposed](https://github.com/android-hacker/VirtualXposed)和[太极](https://www.taichi-app.com/)都在用，经过大量验证非常稳定，不过现在闭源了，开源版有一些bug

经过对比，发现大多数hook框架都不太符合要求，Epic现在闭源，最终决定自己动手写一个。  
注：这里只是根据我的需求评估的，如果你可以提供与原方法参数和返回值都相同的hook方法与backup方法，或者对稳定性有较高要求而速度是其次的话，那么更建议使用成熟的[SandHook框架](https://github.com/ganyao114/SandHook)。

## [](#基础知识 "基础知识")基础知识

在介绍Pine之前，先介绍一下基础知识。  
一个方法/构造器在art中表示为一个`ArtMethod`对象，`ArtMethod`保存着该方法的信息等。  
以[Android 9.0的源码](http://aospxref.com/android-9.0.0%5Fr45/xref/art/runtime/art%5Fmethod.h)为例，一个`ArtMethod`是这样的：

class ArtMethod FINAL {  
      
    GcRoot<mirror::Class> declaring_class_;  
  
      
    std::atomic<std::uint32_t> access_flags_;  
      
  
    struct PtrSizedFields {  
          
        void* data_;  
  
          
        void* entry_point_from_quick_compiled_code_;  
    }  
}  

略去一些细节，ART的函数调用过程其实很简单：

1. caller想办法拿到callee的ArtMethod对象
2. 将参数按照约定存到寄存器和栈里
3. 跳转到callee的方法入口

## [](#基本实现 "基本实现")基本实现

Pine支持两种方案，一种是替换入口，即修改`ArtMethod`的entrypoint；另一种类似于native的inline hook，即覆盖掉目标方法的代码开始处的一段代码，用于弥补Android 8.0以下版本入口替换很有可能不生效的问题。

### [](#入口替换 "入口替换")入口替换

我们看看上面的`ArtMethod`，发现了一个很重要的成员：`entry_point_from_quick_compiled_code_`，这个变量保存至该方法的代码入口，如果我们直接修改这个变量，不就可以达到hook的目的了吗？  
然而事情并没有这么简单。用入口替换方案去hook自己的方法，大部分情况下是没有问题的；但如果你需要hook系统的方法，并且这个方法不是virtual方法（比如`TextView.setText(CharSequence)`），那么很有可能不生效。这是因为，Android 8.0以下，art有一个Sharpening优化，如果art能够确定callee的代码入口，那么有可能直接把入口硬编码在机器码内，根本不会去`ArtMethod`里取入口。

还有没有其他方法呢？当然有，那就是inline hook。

### [](#inline-hook "inline hook")inline hook

从上面的分析可以看出，目标方法的代码是一定会用到的；那么我们可以直接修改目标方法的代码，把前几条代码修改为一段跳转指令，这样当这个方法执行时，就会直接跳到我们指定的另一段代码处执行，我们就达到了hook目的。  
以下情况不能被inline hook：

* jni方法和代理方法。jni方法和代理方法都没有对应的已编译代码，其`entry_point_from_quick_compiled_code_`固定指向一段trampoline，这个trampoline会跳转到真正的代码处执行。
* 方法未被编译且尝试编译失败。
* 方法已被编译，但代码太短以至于一个简单的跳转指令都放不下。跳转指令arm32需要8字节，arm64需要16字节；实际上我们可以考虑其他方式跳转，比如如果我们可以偷到目标代码附近的内存，就能直接使用b指令跳转（此方法来自于[Dobby框架](https://jmpews.github.io/2017/08/01/pwn/HookZz%E6%A1%86%E6%9E%B6/)）；或者我们可以放一个非法指令，程序执行到这条指令时会产生一个SIGILL信号，我们捕获到这个信号，对寄存器和栈进行操作就能直接控制执行流程（注：此方法来自于卓桐大佬的[Android elf hook的方式](https://bbs.pediy.com/thread-257021.htm#%E5%BC%82%E5%B8%B8hook)）。之所以不做这个处理，是因为这样的方法很少，而且很可能被直接内联到caller里，个人认为没必要。
* 方法的前几条代码里有pc寄存器相关指令，hook时没问题，但执行原方法时会有问题（具体见后面的 [一些问题-执行原方法](#执行原方法) 部分）

当出现以上情况时，自动转用入口替换模式。

### [](#四个跳板 "四个跳板")四个跳板

我们需要写四段模板代码，注意要用纯汇编写以避免破坏栈和寄存器，暂时命名为trampoline：

1. DirectJumpTrampoline：inline hook使用，功能是跳转至一个绝对地址，需要插入目标方法的代码开始处。
2. BridgeJumpTrampoline：两个方案都需要使用，处理一些东西并跳转至Bridge方法，这个bridge是我们预先写好的一个java方法，跳转到这个方法之后我们就回到了java世界，然后就可以开始处理真实的AOP逻辑。
3. CallOriginTrampoline：入口替换使用，功能是设置r0寄存器为原方法并跳转至原方法入口。将成为backup方法的入口。（暂未使用，目前发现设置r0寄存器为原方法后有几率造成卡死）
4. BackupTrampoline：inline hook使用，设置r0寄存器为原方法、存放被覆盖的代码并跳转至(原方法入口+备份代码大小)处继续执行。将成为backup方法的入口。（其实这段代码叫trampoline是不太合适的）

## [](#一些问题 "一些问题")一些问题

基本原理比较简单，但是实现的过程中会遇到很多的问题，这里简单说一下。

### [](#参数解析 "参数解析")参数解析

大概想了一下，参数解析有以下方案：

* 动态生成出一个有和原方法相同的参数列表的方法，这个方法只是一个bridge，作用就是传递参数和返回值；需要注意的是，这个方法必须要有对应的代码，和一些必要的成员，为此可以有两种方法：  
   * 通过如[DexMaker](https://github.com/linkedin/dexmaker)等动态字节码生成技术动态生成出这个方法（[EdXposed](https://github.com/ElderDrivers/EdXposed)用的方案）；这种方案的主要问题是比较慢，动态生成dex并加载是耗时操作。  
   * 利用java的动态代理动态生成，难点在于如何控制这个新生成的代理方法做你想要做的事；[SandHook的xposedcompat\_new](https://github.com/ganyao114/SandHook/tree/master/xposedcompat%5Fnew)里实现了一个：把这个代理方法设置为native方法，然后通过libffi动态生成对应的native函数，然后修改其`entry_point_from_jni`（其实就是Whale那个方案，不过whale是对目标方法，SandHook的xposedcompat\_new是对处理方法），这个方案有点问题，凭空把一个非native方法变为native有很多未知的坑等着你去踩。
* 统一bridge方法，在这个bridge方法里自己解析参数。
* art为了实现java的动态代理，自己就有一个`art_quick_proxy_invoke_handler`，如果能利用好这个内置函数，那么就可以达到目的。不过看了下代码，这个函数利用起来很难，暂时先放弃。

最终我选择自己解析参数，hook时较快；为此我们需要了解ART的函数调用约定，根据这个约定去解析。  
以arm32/thumb2为例，在ART中，r0寄存器固定保存callee的ArtMethod\*，r1\~r3寄存器保存前三个参数（注：非静态方法实际上第一个参数就是this）；同时，sp\~sp+12上也传递着r0\~r3上的值；多余的参数通过栈传递，比如第四个参数就存在sp+16上；如果一个参数一个寄存器放不下（long/double），那么会占用两个寄存器。不过这只是基本情况，其他情况还需特别处理（如在6.0或以上，如果第一个参数是long/double类型的，那么会跳过r1寄存器等等）。  
ok，我们发现了一个简单的办法：我们可以修改r1\~r3传递其他东西，必须需要的只有sp，因为sp\~sp+12上也存放着r0\~r3上的值，剩下的参数也通过sp传递，那么我们直接通过sp就能获取到所有参数？  
兴冲冲的写好代码测试发现，此路不通，通过sp拿到的前几个参数是乱的。为什么？weishu的文章[论ART上运行时 Method AOP实现](http://weishu.me/2017/11/23/dexposed-on-art/)里揭露了答案：

> 虚拟机本身也是知道 sp + 12 这段空间相当于是浪费的，因此他直接把这段空间当做类似寄存器使用了。

那怎么办呢？在栈上分配内存来放？同样行不通，这样一旦发生栈回溯，sp被修改的那一帧会因为回溯不到对应的函数引发致命错误，导致runtime abort。  
现在我采用和epic类似的方法实现：在hook时分配一段内存，这段内存用来放r0\~r3，先保存了再跳转到bridge方法，bridge方法就可以取出对应的值。  
另外对象类型要特别处理，art传递对象时其实传的是这个对象的地址，我们接收到的只是一串数字，转换的方法有两个：

* 直接通过java层的Unsafe，直接put进地址，拿出来的就是对象
* 通过jni，用一个art内部函数把地址转换成jobject，返回到java的时候会自动进行转换

这里我选择第二种方法，因为第一种需要用反射调用Unsafe，而反射效率不是很高，有较多参数时效率会比较低。

### [](#多线程并发 "多线程并发")多线程并发

上面提到由于没有其他地方放前几个参数，所以在hook时就会提前分配一块地址专门来放，大概这样：

| 1234 | ldr ip, extra\_addrstr r1, \[ip, #0\]str r2, \[ip, #4\]str r3, \[ip, #8\] |
| ---- | ------------------------------------------------------------------------- |

然后会在bridge里拿到r1\~r3。  
这段代码在单线程下执行并没有问题，但在多线程环境下，如果存值之后还没来得及取值就被其他线程修改，就会读到错误的值，导致错误。  
修复这个问题的一种方法是禁止多线程并发执行，比如给目标方法加上synchronized的flag，但是这样显然太重了，我们只需要在存值——取值这段时间里禁止并发即可。为此，我通过CAS机制写了一个自旋锁：

| 123456789 | acquire\_lock:ldrex r0, \[ip\]cmp r0, #0wfene // other thread holding the lock, wait it release lockmov r0, #1strexeq r0, r0, \[ip\]cmpeq r0, #0 // store succeeded?bne acquire\_lock // acquire lock failed, try againdmb |
| --------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |

extras的第一个变量即为锁标志，为0代表无锁，为1代表已有线程持有该锁，获取时通过CAS去抢锁，bridge里将锁标志置0释放锁。注意需要添加内存屏障以阻止部分关键指令被乱序执行引发错误。  
这里还有一个问题：arm32/thumb2下，ldrex/strex需要一个寄存器来接收结果，而ip寄存器已存放着extras的地址；arm64下stlxr要求source和status不能相同等等，都需要占用一个额外寄存器，这里我选择r0寄存器，原因很简单：r0寄存器固定保存callee的ArtMethod指针，这个值在hook的时候就已确定；跳转到bridge方法时也会更改为bridge的ArtMethod等。  
（注：发现arm64有一个xzr/wzr寄存器固定为0，如果把lock\_flag改成0为有锁1为无锁就可以直接用wzr寄存器了，可以少用一个寄存器，列入TODO列表里了）  
（注2：仔细思考了一下，发现如果两个线程抢锁，持有锁的线程获取到锁以后还没来得及释放就因为gc等进入checkpoint被挂起，而另一个线程在等锁无法进入checkpoint，导致类似死锁的情况，最终导致挂起所有线程超时runtime abort，没想到怎么解决，暂时先挂着吧）

### [](#执行原方法 "执行原方法")执行原方法

要执行原方法，我们需要一个原方法代码入口。入口替换模式下，直接使用原来那个入口就行；但在inline hook模式下，由于我们修改了方法入口处的代码，需要对原方法代码进行备份，调用原方法的时候直接执行这段备份的代码，然后继续跳转到剩余代码部分执行即可。  
我们特别写了一段叫做BackupTrampoline的代码实现，以arm32为例：

| 12345678910 | FUNCTION(pine\_backup\_trampoline)ldr r0, pine\_backup\_trampoline\_origin\_method // 将r0寄存器设置为原方法VAR(pine\_backup\_trampoline\_override\_space).long 0 // 会被替换为真实代码.long 0 // 会被替换为真实代码ldr pc, pine\_backup\_trampoline\_remaining\_code\_entry // 跳转到剩余部分继续执行VAR(pine\_backup\_trampoline\_origin\_method).long 0VAR(pine\_backup\_trampoline\_remaining\_code\_entry).long 0 |
| ----------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |

而thumb2需要特别注意，由于在thumb2下一条指令可能是4字节也可能是2字节，如果我们固定为只备份8字节则有可能导致指令被截断（比如4-2-4），所以备份的时候一定要注意指令完整性。

| 123 | static inline bool IsThumb32(uint16\_t inst) {    return ((inst & 0xF000) == 0xF000) \|| ((inst & 0xF800) == 0xE800);} |
| --- | ---------------------------------------------------------------------------------------------------------------------- |

FUNCTION(pine_thumb_backup_trampoline)  
ldr r0, pine_thumb_backup_trampoline_origin_method  
VAR(pine_thumb_backup_trampoline_override_space)  
.long 0 // 会被替换为真实代码  
.long 0 // 会被替换为真实代码  
nop // 可能会被替换为真实代码，否则只是一条nop  
ldr pc, pine_thumb_backup_trampoline_remaining_code_entry // 跳转到剩余部分继续执行  
VAR(pine_thumb_backup_trampoline_origin_method)  
.long 0  
VAR(pine_thumb_backup_trampoline_remaining_code_entry)  
.long 0  

另一个问题是，在inline hook模式下，我们需要把部分原始指令备份到另一个地方，如果这部分指令里有pc相关指令，由于此时指令地址不同，会发生错误。传统native inline hook框架的做法是做指令修复，而因为art上这种情况很少，所以Pine目前并没有指令修复，只是简单的做判断，如果发现这种情况直接转用入口替换模式。  
（注：其实还可以有另一种方案，就是不用原来的指令，设置r0寄存器为原方法后直接跳转到`art_quick_to_interpreter_bridge`走解释执行就行，注意需要清掉对应`ProfilingInfo`的`saved_entry_point_`，否则可能会直接跳转到原方法入口执行，就死循环了）

好的，现在我们有了原代码入口，我们可以动态创建出一个backup方法，设置backup方法入口为原代码入口，然后直接反射调用这个方法就行了！不过有一点要注意，由于这个方法是动态创建出来的，而ArtMethod的`declaring_class`是GcRoot，可能被gc移动，art会自动更新原版ArtMethod里的地址，但是不会更新我们自己创建的ArtMethod里的地址，所以需要我们自己主动更新。

| 123456789 | void Pine\_updateDeclaringClass(JNIEnv \*env, jclass, jobject javaOrigin, jobject javaBackup) {    auto origin = art::ArtMethod::FromReflectedMethod(env, javaOrigin);    auto backup = art::ArtMethod::FromReflectedMethod(env, javaBackup);    uint32\_t declaring\_class = origin->GetDeclaringClass();    if (declaring\_class != backup->GetDeclaringClass()) {        LOGI("The declaring\_class of method has moved by gc, update its reference in backup method now!");        backup->SetDeclaringClass(declaring\_class);    }} |
| --------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |

~~不过还有一个问题，假如在我们检查完`declaring_class`之后调用backup之前发生gc，这个class对象被移动了，怎么办呢？难道要在这段时间里直接关闭Moving GC？太重了，我们只希望`declaring_class`不会被移动就行。实际上，确实有让一个对象暂时不会被移动的方法：**对于在栈上有引用的对象，不会被gc移动**。那就简单了，保证对应的Class对象在栈上有引用即可，需要注意必须显式使用一下，否则会被优化：~~  
（此方法来源于SandHook，未验证，在Android 10上测试并不能阻止对象被移动，哎）  
（注：这里之前是考虑过用FastHook的那种方案的，即动态代理创建出forward方法，只修改forward的entry而非全部备份，不过试下来发现有点问题）  
ok，调用原方法完成。

### [](#jit "jit")jit

这是[官方文档](https://source.android.google.cn/devices/tech/dalvik/jit-compiler)上的JIT工作流程图。  
Pine对jit的处理和其他框架差不多：

* 如果目标方法没被编译，先尝试调用`jit_compile_method`进行编译，编译的结果直接影响到走inline hook还是入口替换；
* jit编译会改变线程状态，有可能会造成crash，所以编译完后需要恢复线程状态；
* 给原方法和backup方法添加`kAccCompileDontBother`防止其被jit编译从而引发错误；
* 另外还照着SandHook写了一个禁用jit inline。

不过这似乎还远远不够。FastHook作者在[这篇文章](https://bbs.pediy.com/thread-250292.htm)中提到了这两点：

* 如果该方法正在jit编译，那么我们手动编译是不安全的。
* `jit gc`会修改方法入口为解释器入口，当方法进入解释器时会重新设置为原来的入口并跳转到原来的入口执行。

另外我简单看了下jit源码，发现包括`ProfilingInfo`和`被编译的代码`在内的大部分内容**都有可能被回收**。  
暂时还没想好这个怎么处理emmm

### [](#ELF符号解析 "ELF符号解析")ELF符号解析

受限于实现原理，我们需要获得来自系统私有库内的大量私有符号，最简单的办法就是用`dlsym`，不过在Android N上，Google禁止了这种行为，而且我们还需要获取一些在`.symtab`表里的符号（比如`art_quick_to_interpreter_bridge`），这些用`dlsym`是搜索不到的。因为我对elf格式不熟，所以直接用的SandHook作者的[AndroidELF](https://github.com/ganyao114/AndroidELF)，在这特别表示感谢\~

### [](#各设备兼容 "各设备兼容")各设备兼容

处理安卓各版本的变化这些都是老生常谈了，这条要讲的问题是指当厂商修改了一些成员偏移的情况。  
比如`ArtMethod`，我们做hook至少需要获得`art_entry_point_from_quick_compiled_code_`和`access_flags_`，我们可以根据AOSP写死偏移，但是这样的话一旦厂商做了什么手脚改了偏移，那就完蛋了。而我知道的框架只有SandHook和Whale是动态查找偏移，其他都是根据AOSP写死偏移。  
实际上我们可以在运行时动态获得这些offset，拿`access_flags_`来说吧，我们可以定义一个方法，然后根据该方法的属性预测access\_flag，然后可以用这个预测的flag在ArtMethod里动态搜索到值（这个方法最好是native的，否则很有可能会被加上一个`kAccSkipAccessChecks`导致搜索不到）；而对于`entry_point_from_quick_compiled_code_`，并没有办法预测值，但是我们可以预测在`art_entry_point_from_quick_compiled_code_`旁边的`data_`成员的值：对于native方法，这个值是对应的jni函数地址，我们可以搜索到，然后直接加上成员大小就行（需要注意内存对齐）  
而对于无法动态获得偏移的情况，比如`CompilerOptions`，它在内存中是这样的：

| 12345678910 | class CompilerOptions final {    CompilerFilter::Filter compiler\_filter\_;    size\_t huge\_method\_threshold\_;    size\_t large\_method\_threshold\_;    size\_t small\_method\_threshold\_;    size\_t tiny\_method\_threshold\_;    size\_t num\_dex\_methods\_threshold\_;    size\_t inline\_max\_code\_units\_;    } |
| ----------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |

假如我们要修改它的`inline_max_code_units_`，没什么能很好获取偏移的办法，那么我们只能根据版本写死偏移，运行时就只能判断对应的值是否在范围内，超过范围不修改（比如获取出一个114514，那肯定不是正常的值，就可以判断出偏移不对）。

## [](#使用 "使用")使用

上面说了这么久实现原理，下面让我们来看看这东西怎么用吧\~

### [](#基础使用 "基础使用")基础使用

在`bridge.gradle`里加入如下依赖：

| 123 | dependencies {    implementation 'top.canyie.pine:core:0.0.1'} |
| --- | -------------------------------------------------------------- |

配置一些基本信息：

| 12 | PineConfig.debug = true; PineConfig.debuggable = BuildConfig.DEBUG; |
| -- | ------------------------------------------------------------------- |

然后就可以开始使用了。

例子1：监控Activity onCreate（注：仅做测试使用，如果你真的有这个需求更建议使用`registerActivityLifecycleCallbacks()`等接口）

| 123456789 | Pine.hook(Activity.class.getDeclaredMethod("onCreate", Bundle.class), new MethodHook() {    @Override public void beforeHookedMethod(Pine.CallFrame callFrame) {        Log.i(TAG, "Before " \+ callFrame.thisObject + " onCreate()");    }    @Override public void afterHookedMethod(Pine.CallFrame callFrame) {        Log.i(TAG, "After " \+ callFrame.thisObject + " onCreate()");    }}); |
| --------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |

Pine.CallFrame就相当于xposed的MethodHookParams。

例子2：拦截所有java线程的创建与销毁：

final MethodHook runHook = new MethodHook() {  
    @Override public void beforeHookedMethod(Pine.CallFrame callFrame) throws Throwable {  
        Log.i(TAG, "Thread " + callFrame.thisObject + " started...");  
    }  
  
    @Override public void afterHookedMethod(Pine.CallFrame callFrame) throws Throwable {  
        Log.i(TAG, "Thread " + callFrame.thisObject + " exit...");  
    }  
};  
  
Pine.hook(Thread.class.getDeclaredMethod("start"), new MethodHook() {  
    @Override public void beforeHookedMethod(Pine.CallFrame callFrame) {  
        Pine.hook(ReflectionHelper.getMethod(callFrame.thisObject.getClass(), "run"), runHook);  
    }  
});  

注意如果我们只hook `Thread.run()`，Thread子类可能会重写`Thread.run()`方法不调用`super.run()`那么就无法hook到，所以我们可以hook一定会被调用的`Thread.start()`方法感知到新线程建立，此时可以获得具体的类，然后直接hook这些运行时才被发现的类就行。

我们还可以玩点丧心病狂的，比如：

| 12 | Method checkThread = Class.forName("android.view.ViewRootImpl").getDeclaredMethod("checkThread");Pine.hook(checkThread, MethodReplacement.DO\_NOTHING); |
| -- | ------------------------------------------------------------------------------------------------------------------------------------------------------- |

这段代码会干什么呢？没错，现在你可以在任何线程随意操作ui了，不用怕`ViewRootImpl.CalledFromWrongThreadException`了 ^\_^  
当然，Pine的用途远不止这些，这一切都取决于您的想象力\~

### [](#其他一些API "其他一些API")其他一些API

这里介绍一些其他的API：

* `Pine.ensureInitialized()`：默认情况下Pine是懒初始化的，即第一次调用需要初始化的API时才会进行初始化，你可以调用此方法来主动进行初始化
* `Pine.invokeOriginalMethod(Member method, Object thisObject, Object... args)`：调用原方法，不过不建议使用这个接口，更建议使用效率更高的`CallFrame.invokeOriginalMethod()`。
* `Pine.setHookMode(int hookMode)`：设置Pine的hook方案，取值：`Pine.HookMode.AUTO`：由Pine自行决定；`Pine.HookMode.INLINE`：inline hook优先；`Pine.HookMode.REPLACEMENT`：入口替换优先。注：设置hook方案并不代表Pine一定会以该方案进行hook，如hook jni函数就只能进行入口替换。
* `Pine.disableJitInline()`：尝试关闭JIT的内联优化。
* `Pine.compile(Member method)`：主动调用JIT尝试编译一个方法。
* `Pine.decompile(Member method, boolean disableJit)`：使某个方法转换为解释执行。参数`disableJit`表示是否需要阻止该方法再次被JIT编译。

还有其他一些不太常用的就不再介绍了，感兴趣的可以去看看源码。

### [](#使用须知 "使用须知")使用须知

1. Pine的开源协议是[反996协议](https://github.com/kattgu7/Anti-996-License/blob/master/LICENSE%5FCN)。
2. Pine支持Android 4.4（只支持ART）\~10.0，aarch32（未测试，几乎见不到，以后可能会移除）/thumb2/arm64架构；6.0 32bit下参数解析可能会有问题，没有对应测试机无法测试（其实是看epic源码有对M进行特殊处理，不过这段没看懂emm）；另外，Pine没有自带绕过隐藏API限制策略的方法，如果你需要在9.0及以上使用，那么请自行处理（比如使用[FreeReflection](https://github.com/tiann/FreeReflection)）；R上简单看了下，jmethodID有可能不是真实的ArtMethod\*了，不过java层Executable的artMethod变量似乎还是，处理了这点应该就行
3. Pine只在少数的几台设备上做过测试，稳定性暂无法保证，不建议在生产环境中使用。
4. 大部分java方法都可被Pine hook，但是这些方法除外：
* 类的静态初始化块
* 部分关键系统方法
* 被Pine内部使用了的方法（hook会导致死循环）
* 有无法被inline hook的情况
* 被完全内联的方法（如果能知道caller，那么可以decompile caller）

## [](#总结 "总结")总结

嗯，大概就是这样啦\~  
再放一下开源地址：[Pine](https://github.com/canyie/pine)  
几个对我帮助比较大的项目：

* [SandHook](https://github.com/ganyao114/SandHook)
* [Epic](https://github.com/tiann/epic)
* [AndroidELF](https://github.com/ganyao114/AndroidELF)：本项目使用了的ELF符号搜索库
* [YAHFA](https://github.com/PAGalaxyLab/YAHFA)
* [FastHook](https://github.com/turing-technician/FastHook)

在这再次表示感谢\~

如果你对本项目感兴趣的话，可以拿出你的手机帮我测试一下，欢迎提issue和PR，也可以加一下[QQ群：949888394](https://shang.qq.com/wpa/qunwpa?idkey=25549719b948d2aaeb9e579955e39d71768111844b370fcb824d43b9b20e1c04)一起讨论，^\_^

  

---

