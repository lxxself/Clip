---
id: ef618b6a-f39d-42ee-98a2-41f2cb7d9e5e
---

# Android修炼系列（二），Class类加载过程与类加载器 - 掘金
#Omnivore

[Read on Omnivore](https://omnivore.app/me/android-class-18dee7ad407)
[Read Original](https://juejin.cn/post/6935358323139018766)

在说类加载器和双亲委派模型之前，我们先来梳理下Class类文件的加载过程，JAVA虚拟机为了保证 实现语言的无关性，是将虚拟机只与“Class 文件”字节码 **这种特定形式的二进制文件格式** 相关联，而不是与实现语言绑定。

### 类加载过程

Class类从被加载到虚拟机内存开始，到卸载出内存为止，其生命周期包括：加载（Loading）、验证（Verification）、准备（Preparation）、解析（Resolution）、初始化（Initialization）、使用（Using）、卸载（Unloading）7个阶段。其中加载过程见下：

![在这里插入图片描述](https://proxy-prod.omnivore-image-cache.app/0x0,sG96dhnxuImJ9nA2QIKc6H40NDgUNWpejUvf0KLjHfp4/https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/6625bae8b72e4211b56261c50f955dc4~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp)

### 加载阶段

加载阶段做了什么？过程见下图。其中类的全限定名是Class文件（JAVA由编译器自动生成）内的代表常量池内的16进制值所代表的特定符号引用。因为Class文件格式有其自己的一套规范，如第1-4字节代表魔数，第5-6字节代表次版本，第7-8字节代表主版本号等等。

![](https://proxy-prod.omnivore-image-cache.app/0x0,sA_siAOB4h7429P8PENzT4wvSuP10wRk71htYOh_PXQ0/https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/faffc247d179459cbcc9da50f831368e~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp)

说白了就是，==虚拟机不关心我们的这种“特定二进制流”从哪里来的，从本地加载也好，从网上下载的也罢，都没关系。虚拟机要做的就是将该二进制流写在自己的内存中并生成相应的Class对象（并不是在堆中）==。在这个阶段，我们能够通过我们自定义类加载器来控制二进制流的获取方式。

### 验证阶段

验证阶段，正因为加载阶段虚拟机不介意二进制的来源，所以就可能存在着影响虚拟机正常运行的安全隐患。所以虚拟机对于该二进制流的校验工作非常重要。校验方式包括但不限于：

![](https://proxy-prod.omnivore-image-cache.app/0x0,stdHnGpSHPKuezhdzH2EZu_-g-phfvcNhrOW-YxKSdWI/https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/ac738aa085cb46a4b25b733af2bd4f2a~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp)

### 准备阶段

准备阶段在此阶段将正式为类变量分配内存并设置变量的初始化值。注意的是，类变量是指 static 的静态变量，是分配在方法区之中的，而不像对象变量，分配在堆中。还有一点需要注意，final 常量在此阶段就已经被赋值了。如下：

```gradle
    public static int SIZE = 10; // 初始化值 == 0
    public static final int SIZE = 10; // 初始化值 == 10

```

### 解析阶段

解析阶段是将常量池内的符号引用替换为直接引用的过程。符号引用就是上文说的Class文件格式标准所规定的特定字面量，而直接引用就是我们说的指针，内存引用等概念

### 初始化阶段

到了初始化阶段，就开始真正执行我们的字节码程序了。也可以理解成：类初始化阶段就是虚拟机内部执行类构造 < clinit >() 方法的过程。注意，这个类构造方法可不是虚拟机内部生成的，而是我们的编译器自动生成的，是编译器自动收集类中的所有类变量的 **赋值动作** 和静态语句块（static{}块）中的语句合并产生的，具体分析见下。

注意，这里说的是类变量赋值动作，即static 并且具有赋值操作，如果无赋值操作，那么在准备阶段进行的方法区初始化就算完成了。为何还要加上static{} 呢？==我们可以把static{} 理解成：是由多个静态初始化动作组织成的一个特殊的“静态子句”，与其他的静态初始化动作一样。这也是为何 static {} 只会执行一遍并在对象构造方法之前执行的原因。==如下代码：

```angelscript
public class Tested {
    public static int T;
    // public static int V; // 无赋值，不在类构造中再次初始化
    public int c = 1; // 不会在类构造中

    static {
        T = 10;
    }
}

```

还有一点，编辑器收集类变量的顺序，也就是虚拟机在此初始化阶段的执行顺序，这个顺序就是变量在类中语句定义的先后顺序，如上面的：语句 2 : T 在 6 : T 之前，这是两个独立的语句。类构造< clinit >的其他特点如下：

![](https://proxy-prod.omnivore-image-cache.app/0x0,s82X0DKVmC6itf-Z5cUGO_QutxnG-KhaFrB2W1KLLQes/https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/b854de186fe449228e515422010d6226~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp)

#### 编译期的< clinit >

我们将流程回溯到编译期阶段，以刚刚的Tested 类代码为例。通过 javap -c /Tested.class (注意：/../Tested 绝对路径)，获取Class文件：

```properties
public class com.tencent.lo.Tested {
  public static int T;

  public int c;

  public com.tencent.lo.Tested();
    Code:
       0: aload_0
       1: invokespecial #1                  // Method java/lang/Object."<init>":()V
       4: aload_0
       5: iconst_1
       6: putfield      #2                  // Field c:I
       9: return

  static {};
    Code:
       0: bipush        10
       2: putstatic     #3                  // Field T:I
       5: return
}

```

在Class 文件中我们能很明显的看到 invokespecial 对应的对象构造 "< init >" : () V ，那为什么没有看到< clinit > 类构造方法呢？其实上面的 static {} 就是。我们来看下[OpenJDK源码](https://link.juejin.cn/?target=http%3A%2F%2Fwww.docjar.com%2Fdocs%2Fapi%2Fsun%2Ftools%2Fjava%2Fpackage-index.html "http://www.docjar.com/docs/api/sun/tools/java/package-index.html")的 [Constants接口](https://link.juejin.cn/?target=http%3A%2F%2Fwww.docjar.com%2Fhtml%2Fapi%2Fsun%2Ftools%2Fjava%2FConstants.java.html "http://www.docjar.com/html/api/sun/tools/java/Constants.java.html")，此接口定义了在编译器中所用到的常量，这是一个自动生成的类。

```routeros
public interface Constants extends RuntimeConstants {
    public static final boolean tracing = true;

    Identifier idClassInit = Identifier.lookup("<clinit>");
    Identifier idInit = Identifier.lookup("<init>");
}

```

在[MemberDefinition类](https://link.juejin.cn/?target=http%3A%2F%2Fwww.docjar.com%2Fhtml%2Fapi%2Fsun%2Ftools%2Fjava%2FMemberDefinition.java.html "http://www.docjar.com/html/api/sun/tools/java/MemberDefinition.java.html") 中，判断是否为类构造器字符：

```aspectj
    public final boolean isInitializer() {
        return getName().equals(idClassInit); // 类构造
    }
    public final boolean isConstructor() {
        return getName().equals(idInit); // 对象构造
    }

```

而在MemberDefinition 的 toString() 方法中，我们能够看到，当类构造时，会输出特定字符，而不会像对象构造那样输出规范的字符串。

```reasonml
    public String toString() {
        Identifier name = getClassDefinition().getName();
        if (isInitializer()) { // 类构造
            return isStatic() ? "static {}" : "instance {}";
        } else if (isConstructor()) { // 对象构造
            StringBuffer buf = new StringBuffer();
            buf.append(name);
            buf.append('(');
            Type argTypes[] = getType().getArgumentTypes();
            for (int i = 0 ; i < argTypes.length ; i++) {
                if (i > 0) {
                    buf.append(',');
                    }
                buf.append(argTypes[i].toString());
                }
            buf.append(')');
            return buf.toString();
        } else if (isInnerClass()) {
            return getInnerClass().toString();
        }
        return type.typeString(getName().toString());
    }

```

### 类加载器

“虚拟机将类加载阶段中的“通过一个全限定名来获取描述此类的二进制字节流”这个动作放到了外部来实现，以便开发者可以自己决定如何获取所需的类文件，而实现这个动作的代码模块就被称为类加载器。==对于任意一个类来说，只有在类加载器相同的情况下比较两者是否相同才有意义，否则即使是同个文件，在不同加载器下，在虚拟机看来其仍然是不同的，是两个独立的类。==我们可以将类加载器分为三类”：

![](https://proxy-prod.omnivore-image-cache.app/0x0,skgNfWOY_JDbtoRiYg3lw3g4M-VATbifgCj8dKLyepWA/https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/dd274e797a404c4f976afd14daad614d~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp)

### 双亲委派

==而所谓的双亲委派模型就是：“如果一个类加载器收到类加载的请求，它首先不会自己去尝试加载这个类，而是把加载的操作委托给父类加载器去完成，每一层次加载器都是如此，因此所有的加载请求都会传送到顶层的启动类加载器中，只有当父加载器反馈自己无法完成这个加载请求时（它的搜索范围没有找到所需的类，因为上面所说的启动类加载器和扩展类加载器，只能加载特定目录之下的，或被-x参数所指定的类库），子类才会尝试自己加载”。==注意这里说的父类只是形容层次结构，其并不是直接继承关系，而是通过组合方式来复用父类的加载器的。

![在这里插入图片描述](https://proxy-prod.omnivore-image-cache.app/0x0,scwynqevp7ek2bk_Q6dFUdvIbKGy0_jILtI_m62rV954/https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/a59b4b4de4ce408e954ca18b28a63182~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp#pic_center=400x230)

“双亲委派的好处就是，使加载器也具备了优先级的层次结构。例如，java.lang.Object存放在< JAVA\_HOME>\\lib 下的rt.jar包内，无论哪个类加载器要加载这个类，最终都会委派给最顶层的启动类加载器，所以保证了Object类在各类加载器环境中都是同一个类。相反，如果没有双亲委派模型，如果用户编写了一个java.lang.Object类，并放在程序的ClassPath下，那么系统将会出现多个不同的Object类”。

为何？因为每个加载器各自为政，不会委托给父构造器，如上面所说，只要加载器不同，即使类Class文件相同，其也是独立的。

试想如果自己在项目中编写了一个java.lang.Object 类（当然不能放入rt.jar类库中替换掉同名Object文件，这样做没有意义，如果虚拟机加载校验能通过的话，只是相当于改了源码嘛），我们通过自定义的构造器来加载这个类可以吗？理论上来说，虽然这两个类都是java.lang.Object，但由于构造器不同，对于虚拟机来说这是不同的Class文件，当然可以。但是实际上呢？来段代码见下：

```aspectj
    public void loadPathName(String classPath) throws ClassNotFoundException {
        new ClassLoader() {
            @Override
            public Class<?> loadClass(String name) throws ClassNotFoundException {
                InputStream is = getClass().getResourceAsStream(name);
                if (is == null)
                    return super.loadClass(name);
                byte[] b;
                try {
                    b = new byte[is.available()];
                    is.read(b);
                } catch (Exception e) {
                    return super.loadClass(name);
                }
                return defineClass(name, b, 0, b.length);
            }
        }.loadClass(classPath);
    }

```

实际的执行逻辑是 defineClass 方法。可以发现，自定义加载器是无法加载以 java. 开头的系统类的。

```processing
    protected final Class<?> defineClass(String name, byte[] b, int off, int len,
                                         ProtectionDomain protectionDomain)
            throws ClassFormatError {
        
        protectionDomain = preDefineClass(name, protectionDomain);
        ... // 略

        return c;
    }

    private ProtectionDomain preDefineClass(String name, ProtectionDomain pd) {
        if (!checkName(name))
            throw new NoClassDefFoundError("IllegalName: " + name);
        // 在这里能看到系统类，自定义的加载器是不能加载的
        if ((name != null) && name.startsWith("java.")) {
            throw new SecurityException
                    ("Prohibited package name: " +
                            name.substring(0, name.lastIndexOf('.')));
        }
        ... // 略
        
        return pd;
    }

```

如果你用AS直接查看，你会发现，defineClass 内部是没有具体实现的，源码见下。可这并不代表android 的 defineClass 方法实现与 java 不同，因为都是引用的 java.lang 包下的ClassLoader 类，逻辑肯定都是一样的。==之所以看到的源码不一样，这是由于SDK和JAVA源码包的区别导致的。SDK内的源码是谷歌提供给我们方便开发查看的，并不完全等同于源码。==

```reasonml
    protected final Class<?> defineClass(String name, byte[] b, int off, int len)
        throws ClassFormatError
    {
        throw new UnsupportedOperationException("can't load this type of class file");
    }

```

好了，本文到这里就结束了，关于类加载过程的讲解也应该够用了。

本文完。

**参考**1、周志明，深入理解JAVA虚拟机：机械工业出版社

---

## Highlights

> 虚拟机不关心我们的这种“特定二进制流”从哪里来的，从本地加载也好，从网上下载的也罢，都没关系。虚拟机要做的就是将该二进制流写在自己的内存中并生成相应的Class对象（并不是在堆中） [⤴️](https://omnivore.app/me/android-class-18dee7ad407#6aab491e-67dc-438b-8d7b-d2c17fe41a7a) 

> 我们可以把static{} 理解成：是由多个静态初始化动作组织成的一个特殊的“静态子句”，与其他的静态初始化动作一样。这也是为何 static {} 只会执行一遍并在对象构造方法之前执行的原因。 [⤴️](https://omnivore.app/me/android-class-18dee7ad407#15969c87-f908-4fb9-8ff3-8009a91a286c) 

> 对于任意一个类来说，只有在类加载器相同的情况下比较两者是否相同才有意义，否则即使是同个文件，在不同加载器下，在虚拟机看来其仍然是不同的，是两个独立的类。 [⤴️](https://omnivore.app/me/android-class-18dee7ad407#ace80c8e-296a-4ed0-8d7d-f6a0d0786cf9) 

> 而所谓的双亲委派模型就是：“如果一个类加载器收到类加载的请求，它首先不会自己去尝试加载这个类，而是把加载的操作委托给父类加载器去完成，每一层次加载器都是如此，因此所有的加载请求都会传送到顶层的启动类加载器中，只有当父加载器反馈自己无法完成这个加载请求时（它的搜索范围没有找到所需的类，因为上面所说的启动类加载器和扩展类加载器，只能加载特定目录之下的，或被-x参数所指定的类库），子类才会尝试自己加载”。 [⤴️](https://omnivore.app/me/android-class-18dee7ad407#0989846e-f12e-46e4-ac5a-899edcc1c3d6) 

> 之所以看到的源码不一样，这是由于SDK和JAVA源码包的区别导致的。SDK内的源码是谷歌提供给我们方便开发查看的，并不完全等同于源码。 [⤴️](https://omnivore.app/me/android-class-18dee7ad407#989f835d-463d-4cee-ae28-c5823e5e70f3) 

