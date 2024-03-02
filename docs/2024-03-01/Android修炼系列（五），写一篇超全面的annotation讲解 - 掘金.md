---
id: 9ff0c7a8-1c0f-41fa-b077-2c18dedab44e
---

# Android修炼系列（五），写一篇超全面的annotation讲解 - 掘金
#Omnivore

[Read on Omnivore](https://omnivore.app/me/android-annotation-18df8f7387e)
[Read Original](https://juejin.cn/post/6936609673416015908)

<DIV id="readability-content"><DIV data-omnivore-anchor-idx="1" class="page" id="readability-page-1"><div data-omnivore-anchor-idx="2" data-v-5762947c="" data-v-2c6459d4=""><article data-omnivore-anchor-idx="3" itemscope="itemscope" itemtype="http://schema.org/Article" data-entry-id="6936609673416015908" data-draft-id="6936611947588616223" data-original-type="0" data-v-2c6459d4="" data-v-5762947c=""><!----> <meta data-omnivore-anchor-idx="4" itemprop="headline" content="Android修炼系列（五），写一篇超全面的annotation讲解"> <meta data-omnivore-anchor-idx="5" itemprop="keywords" content="Android"> <meta data-omnivore-anchor-idx="6" itemprop="datePublished" content="2021-03-06T18:54:12.000Z"> <meta data-omnivore-anchor-idx="7" itemprop="image" content="https://p1-jj.byteimg.com/tos-cn-i-t2oaga2asx/gold-assets/icon/icon-128.png~tplv-t2oaga2asx-image.image">     <!----> <!----> <!----> <div data-omnivore-anchor-idx="8" id="article-root" itemprop="articleBody" data-v-2c6459d4=""><p data-omnivore-anchor-idx="9">不学注解，也许是因为平时根本不需要没事自定义个这玩意玩，可随着Android形势越来越内卷，不学点东西是真不行了。而通过本文的学习，可以让你对于注解有个全面的认识，你会发现，小小的注解，大有可为，编不下去了..</p>
<p data-omnivore-anchor-idx="10"><img data-omnivore-anchor-idx="11" data-omnivore-original-src="https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/d9c4ae0ec8e6484981ddf90c1c4504cf~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp" src="https://proxy-prod.omnivore-image-cache.app/0x0,skd3C84XOET-f_o2GCjihNVPice4QcXbcm7VCYmTojck/https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/d9c4ae0ec8e6484981ddf90c1c4504cf~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp" alt="" loading="lazy"></p>
<p data-omnivore-anchor-idx="12">注解不同于注释，注释的作用是为了方便自己或者别人的阅读，能够利用 javadoc 提取源文件里的注释来生成人们所期望的文档，对于代码本身的运行是没有任何影响的。</p>
<p data-omnivore-anchor-idx="13">而注解的功能就要强大很多，不但能够生成描述符文件，而且有助于减轻编写“样板”代码的负担，使代码干净易读。通过使用扩展的注解（annotation）API 我们能够在 <strong data-omnivore-anchor-idx="14">编译期</strong> 和 <strong data-omnivore-anchor-idx="15">运行期</strong> 对代码进行操控。</p>
<blockquote data-omnivore-anchor-idx="16">
<p data-omnivore-anchor-idx="17">注解（也被称为元数据）为我们在代码中添加信息提供了一种形式化的方法，使我们可以在稍后的某个时刻非常方便的使用这些数据。  —Jeremy Meyer</p>
</blockquote>
<p data-omnivore-anchor-idx="18">本文主要对于下面几个方面进行讲解，篇幅很长，建议收藏查看：</p>
<p data-omnivore-anchor-idx="19"><img data-omnivore-anchor-idx="20" data-omnivore-original-src="https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/496bdbdf3ae04484b282a7ff67337005~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp" src="https://proxy-prod.omnivore-image-cache.app/0x0,sLTQDEwIOcnNTCXJ93t_fR8RxrUqXWukSkIoAjv_wwB0/https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/496bdbdf3ae04484b282a7ff67337005~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp" alt="" loading="lazy"></p>
<h2 data-omnivore-anchor-idx="21" data-id="heading-0">Java 最初内置的三种标准注解</h2>
<p data-omnivore-anchor-idx="22">注解是 java SE5中的重要的语言变化之一，你可能对注解的原理不太理解，但你每天的开发中可能无时无刻不在跟注解打交道，最常见的就是 @Override 注解，所以注解并没有那么神秘，也没有那么冷僻，不要害怕使用注解（虽然使用的注解大部分情况都是根据需要自定义的注解），用的多了自然就熟了。为什么说最初的三种标准注解呢，因为在后续的 java 版本中又陆陆续续的增加了一些注解，不过原理都是一样的。</p>





















<table data-omnivore-anchor-idx="23"><thead data-omnivore-anchor-idx="24"><tr data-omnivore-anchor-idx="25"><th data-omnivore-anchor-idx="26">java SE5内置的标准注解</th><th data-omnivore-anchor-idx="27">含义</th></tr></thead><tbody data-omnivore-anchor-idx="28"><tr data-omnivore-anchor-idx="29"><td data-omnivore-anchor-idx="30">@Override</td><td data-omnivore-anchor-idx="31">表示当前的方法定义将覆盖超类中的方法，如果方法拼写错误或者方法签名不匹配，编译器便会提出错误提示</td></tr><tr data-omnivore-anchor-idx="32"><td data-omnivore-anchor-idx="33">@Deprecated</td><td data-omnivore-anchor-idx="34">表示当前方法已经被弃用，如果开发者使用了注解为它的元素，编译器便会发出警告信息</td></tr><tr data-omnivore-anchor-idx="35"><td data-omnivore-anchor-idx="36">@SuppressWarnings</td><td data-omnivore-anchor-idx="37">可以关闭不当的编译器警告信息</td></tr></tbody></table>
<h2 data-omnivore-anchor-idx="38" data-id="heading-1">Java 提供的四种元注解和一般注解</h2>
<p data-omnivore-anchor-idx="39">所谓元注解（meta-annotation）也是一种注解，只不过这种注解负责注解其他的注解。所以再说元注解之前我们来看一下普通的注解：</p>
<blockquote data-omnivore-anchor-idx="40">
<p data-omnivore-anchor-idx="41">public @interface LogClassMessage {}</p>
</blockquote>
<p data-omnivore-anchor-idx="42">这是一个最普通的注解，注解的定义看起来很像一个接口，在 interface 前加上 @ 符号。事实上在语言级别上，注解也和 java 中的接口、类、枚举是同一个级别的，都会被编译成 class 文件。而前面提到的元注解存在的目的就是为了修饰这些普通注解，但是要明确一点，元注解只是给普通注解提供了作用，并不是必须存在的。</p>

























<table data-omnivore-anchor-idx="43"><thead data-omnivore-anchor-idx="44"><tr data-omnivore-anchor-idx="45"><th data-omnivore-anchor-idx="46">java 提供的元注解</th><th data-omnivore-anchor-idx="47">作用</th></tr></thead><tbody data-omnivore-anchor-idx="48"><tr data-omnivore-anchor-idx="49"><td data-omnivore-anchor-idx="50">@Target</td><td data-omnivore-anchor-idx="51">定义你的注解应用到什么地方（详见下文解释）</td></tr><tr data-omnivore-anchor-idx="52"><td data-omnivore-anchor-idx="53">@Retention</td><td data-omnivore-anchor-idx="54">定义该注解在哪个级别可用（详见下文解释）</td></tr><tr data-omnivore-anchor-idx="55"><td data-omnivore-anchor-idx="56">@Documented</td><td data-omnivore-anchor-idx="57">将此注解包含在 javadoc 中</td></tr><tr data-omnivore-anchor-idx="58"><td data-omnivore-anchor-idx="59">@Inherited</td><td data-omnivore-anchor-idx="60">允许子类继承超类中的注解</td></tr></tbody></table>
<p data-omnivore-anchor-idx="61">〔1〕@Target使用的时候添加一个 ElementType 参数，表示当前注解可以应用到什么地方，即可以指定一种，也可以同时指定多种，使用方法如下：</p>
<pre data-omnivore-anchor-idx="62"><code data-omnivore-anchor-idx="63" class="hljs language-less language-angelscript">    <span data-omnivore-anchor-idx="64" class="hljs-comment">// 表示当前的注解只能应用到类、接口（包括注解）、enum上面</span>
    <span data-omnivore-anchor-idx="65" class="hljs-variable">@Target</span>(ElementType.TYPE) 
    public <span data-omnivore-anchor-idx="66" class="hljs-variable">@interface</span> LogClassMessage {}
</code></pre>
<pre data-omnivore-anchor-idx="67"><code data-omnivore-anchor-idx="68" class="hljs language-less language-angelscript">    <span data-omnivore-anchor-idx="69" class="hljs-comment">// 表示当前的注解只能应用到方法和成员变量上面</span>
    <span data-omnivore-anchor-idx="70" class="hljs-variable">@Target</span>({ElementType.METHOD,ElementType.FIELD})
    public <span data-omnivore-anchor-idx="71" class="hljs-variable">@interface</span> LogClassMessage {}
</code></pre>
<p data-omnivore-anchor-idx="72">下面来看一下 ElementType 的全部参数含义：</p>





































<table data-omnivore-anchor-idx="73"><thead data-omnivore-anchor-idx="74"><tr data-omnivore-anchor-idx="75"><th data-omnivore-anchor-idx="76">ElementType 参数</th><th data-omnivore-anchor-idx="77">说明</th></tr></thead><tbody data-omnivore-anchor-idx="78"><tr data-omnivore-anchor-idx="79"><td data-omnivore-anchor-idx="80">ElementType.CONSTRUCTOR</td><td data-omnivore-anchor-idx="81">构造器的声明</td></tr><tr data-omnivore-anchor-idx="82"><td data-omnivore-anchor-idx="83">ElementType.FIELD</td><td data-omnivore-anchor-idx="84">域的声明（包括enum的实例）</td></tr><tr data-omnivore-anchor-idx="85"><td data-omnivore-anchor-idx="86">ElementType.LOCATION_VARLABLE</td><td data-omnivore-anchor-idx="87">局部变量的声明</td></tr><tr data-omnivore-anchor-idx="88"><td data-omnivore-anchor-idx="89">ElementType.METHOD</td><td data-omnivore-anchor-idx="90">方法的声明</td></tr><tr data-omnivore-anchor-idx="91"><td data-omnivore-anchor-idx="92">ElementType.PACKAGE</td><td data-omnivore-anchor-idx="93">包的声明</td></tr><tr data-omnivore-anchor-idx="94"><td data-omnivore-anchor-idx="95">ElementType.PARAMETER</td><td data-omnivore-anchor-idx="96">参数的声明</td></tr><tr data-omnivore-anchor-idx="97"><td data-omnivore-anchor-idx="98">ElementType.TYPE</td><td data-omnivore-anchor-idx="99">类、接口（包括注解类型）、enum声明</td></tr></tbody></table>
<p data-omnivore-anchor-idx="100">〔2〕@Retention用来注解在哪一个级别可用，需要添加一个 RetentionPolicy 参数，用来表示在源代码中（SOURCE），在类文件中（CLASS）或者运行时（RUNTIME）：</p>
<pre data-omnivore-anchor-idx="101"><code data-omnivore-anchor-idx="102" class="hljs language-less language-angelscript">    <span data-omnivore-anchor-idx="103" class="hljs-comment">// 表示当前注解运行时可用</span>
    <span data-omnivore-anchor-idx="104" class="hljs-variable">@Retention</span>(RetentionPolicy.RUNTIME)
    public <span data-omnivore-anchor-idx="105" class="hljs-variable">@interface</span> LogClassMessage {}
</code></pre>
<p data-omnivore-anchor-idx="106">下面来看一下 RetentionPolicy 的全部参数含义：</p>





















<table data-omnivore-anchor-idx="107"><thead data-omnivore-anchor-idx="108"><tr data-omnivore-anchor-idx="109"><th data-omnivore-anchor-idx="110">RetentionPolicy 参数</th><th data-omnivore-anchor-idx="111">说明</th></tr></thead><tbody data-omnivore-anchor-idx="112"><tr data-omnivore-anchor-idx="113"><td data-omnivore-anchor-idx="114">RetentionPolicy.SOURCE</td><td data-omnivore-anchor-idx="115">注解将被编译器丢弃，只能存于源代码中</td></tr><tr data-omnivore-anchor-idx="116"><td data-omnivore-anchor-idx="117">RetentionPolicy.CLASS</td><td data-omnivore-anchor-idx="118">注解在class文件中可用，能够存于编译之后的字节码之中，但会被VM丢弃</td></tr><tr data-omnivore-anchor-idx="119"><td data-omnivore-anchor-idx="120">RetentionPolicy.RUNTIME</td><td data-omnivore-anchor-idx="121">VM在运行期也会保留注解，因此运行期注解可以通过反射获取注解的相关信息</td></tr></tbody></table>
<p data-omnivore-anchor-idx="122">在注解中，一般都会包含一些元素表示某些值，并且可以为这些元素设置默认值，没有元素的注解也称为标记注解（marker annotation）</p>
<pre data-omnivore-anchor-idx="123"><code data-omnivore-anchor-idx="124" class="hljs language-routeros language-java">    @Retention(RetentionPolicy.RUNTIME)
    @Target({ElementType.METHOD,ElementType.FIELD})
    public @interface LogClassMessage {
        public int id ()<span data-omnivore-anchor-idx="125" class="hljs-built_in"> default </span>-1;
        public String message()<span data-omnivore-anchor-idx="126" class="hljs-built_in"> default </span><span data-omnivore-anchor-idx="127" class="hljs-string">""</span>;
    }
</code></pre>
<p data-omnivore-anchor-idx="128">注：虽然上面的 id 和 message 定义和接口的方法定义很类似，但是在注解中将 id 和 message 称为：int 元素 id , String 元素 message。而且注解元素的类型是有限制的，并不是任何类型都可以，主要包括：基本数据类型（理论上是没有基本类型的包装类型的，但是由于自动封装箱，所以也不会报错）、String 类型、enum 类型、Class 类型、Annotation 类型、以及以上类型的数组，（没有等字，说明目前注解的元素类型只支持上面列出的这几种），否则编译器便会提示错误。</p>
<blockquote data-omnivore-anchor-idx="129">
<p data-omnivore-anchor-idx="130">invalid type 'void ' for annotation member  // 例如注解类型为void的错误信息</p>
</blockquote>
<p data-omnivore-anchor-idx="131">对于默认值限制 ，Bruce Eckel 在其书中是这样描述的：编译器对元素的默认值有些过分挑剔，首先，元素不能有不确定的值。也就是说，元素必须要么具有默认值，要么在使用注解时提供注解的值。其次，对于非基本类型的元素，无论在源代码声明中，或者在注解接口中定义默认值时，都不能以 null 作为其值。这个约束使得处理器很难表现一个元素的存在或缺失的状态，因为在每个注解的声明中，所有元素都存在，并且都具有相应的值。为了绕开这个约束，我们只能自己定义一些特殊的值，例如空字符串或者负数，以此表示某个元素的不存在，这算得上是一个习惯用法。</p>
<h2 data-omnivore-anchor-idx="132" data-id="heading-2">参考系统的标准注解</h2>
<p data-omnivore-anchor-idx="133">怎么说呢，接触一种知识的途径有很多，可能每一种的结果都是大同小异的，都能让你学到东西，但是实现的方式、实现过程中的规范、方法和思路却并不一定是最佳的。</p>
<p data-omnivore-anchor-idx="134">上文讲到的是注解的基本语法，那么系统是怎么用的呢？首先让我们来看一下使用频率最高的 @Override ：</p>
<pre data-omnivore-anchor-idx="135"><code data-omnivore-anchor-idx="136" class="hljs language-less language-oxygene">    <span data-omnivore-anchor-idx="137" class="hljs-variable">@Target</span>(ElementType.METHOD)
    <span data-omnivore-anchor-idx="138" class="hljs-variable">@Retention</span>(RetentionPolicy.SOURCE)
    public <span data-omnivore-anchor-idx="139" class="hljs-variable">@interface</span> Override {}
</code></pre>
<p data-omnivore-anchor-idx="140">〔1〕首先系统定义一个没有元素的标记注解 Override ，随后使用元注解 @Target 指明 Override 注解只能应用于方法之上（你可以细想想，是不是在我们实际使用这个注解的时候，只能是重写方法，没有见过重写类或者字段的吧），使用注解 @Retention 表示当前注解只能存在源代码中，并不会出现在编译之后的 class 文件之中。</p>
<pre data-omnivore-anchor-idx="141"><code data-omnivore-anchor-idx="142" class="hljs language-aspectj language-java">    <span data-omnivore-anchor-idx="143" class="hljs-meta">@Override</span>
    <span data-omnivore-anchor-idx="144" class="hljs-keyword">protected</span> <span data-omnivore-anchor-idx="145" class="hljs-function"><span data-omnivore-anchor-idx="146" class="hljs-keyword">void</span> <span data-omnivore-anchor-idx="147" class="hljs-title">onResume</span><span data-omnivore-anchor-idx="148" class="hljs-params">()</span> </span>{
        <span data-omnivore-anchor-idx="149" class="hljs-keyword">super</span>.onResume();
    }
</code></pre>
<p data-omnivore-anchor-idx="150">〔2〕如在 Activity 中我们可以重写 onResume() 方法，添加注解 @override 之后编译器便会去检查父类中是否存在相同方法，如果不存在便会报错。</p>
<p data-omnivore-anchor-idx="151">〔3〕也许到这里你会感到很疑惑，注解到底是怎么工作的，怎么系统这样定义一个注解 Override 它就能工作了？黑魔法吗，擦擦，完成看不到实现过程嘛（泪流满面），经过查阅了一些资料（非权威）了解到，其实处理过程都编写在了编译器里面，也就是说编译器已经给我们写好了处理方法，当编译器进行检查的时候就会调用相应的处理方法。</p>
<h2 data-omnivore-anchor-idx="152" data-id="heading-3">注解处理器</h2>
<p data-omnivore-anchor-idx="153">介绍之前，先引用 Jeremy Meyer 的一段话：如果没有用来读取注解的工具，那么注解也不会比注释更有用。使用注解的过程中，很重要的一个部分就是创建与使用注解处理器。Java SE5 扩展了反射机制的API，以帮助程序员构造这类工具。同时，它还提供了一个外部工具     apt帮助程序员解析带有注解的 java 源代码。</p>
<p data-omnivore-anchor-idx="154">根据上面描述我们可以知道，注解处理器并不是一个特定格式，并不是只有继承了  AbstractProcessor 这个抽象类才叫注解处理器，凡是根据相关API 来读取注解的类或者方法都可以称为注解处理器。</p>
<h4 data-omnivore-anchor-idx="155" data-id="heading-4">反射机制下的处理器</h4>
<p data-omnivore-anchor-idx="156">最简单的注解处理器莫过于，直接使用反射机制的 getDeclaredMethods 方法获取类上所有方法（字段原理是一样的），再通过调用 getAnnotation 获取每个方法上的特定注解，有了注解便可以获取注解之上的元素值，方法如下：</p>
<pre data-omnivore-anchor-idx="157"><code data-omnivore-anchor-idx="158" class="hljs language-monkey language-pgsql">    <span data-omnivore-anchor-idx="159" class="hljs-keyword">public</span> void getAnnoUtil(<span data-omnivore-anchor-idx="160" class="hljs-class"><span data-omnivore-anchor-idx="161" class="hljs-keyword">Class</span>&lt;?&gt; <span data-omnivore-anchor-idx="162" class="hljs-title">cl</span>) {</span>
        <span data-omnivore-anchor-idx="163" class="hljs-keyword">for</span>(<span data-omnivore-anchor-idx="164" class="hljs-function"><span data-omnivore-anchor-idx="165" class="hljs-keyword">Method</span> <span data-omnivore-anchor-idx="166" class="hljs-title">m</span> :</span> cl.getDeclaredMethods()) {
            LogClassMessage logClassMessage = m.getAnnotation(LogClassMessage <span data-omnivore-anchor-idx="167" class="hljs-class">.<span data-omnivore-anchor-idx="168" class="hljs-keyword">class</span>);</span>
            <span data-omnivore-anchor-idx="169" class="hljs-keyword">if</span>(<span data-omnivore-anchor-idx="170" class="hljs-literal">null</span> != logClassMessage) {
                int id = logClassMessage.id();
                String <span data-omnivore-anchor-idx="171" class="hljs-function"><span data-omnivore-anchor-idx="172" class="hljs-keyword">method</span> =</span> logClassMessage.message();
            }
        }
    }
</code></pre>
<p data-omnivore-anchor-idx="173">由于反射对性能会有一定的损耗，所以上述类型的注解处理器并不占主流，现在使用最多的还是 AbstractProcessor 自定义注解处理器，因为后者并不需要通过反射实现，效率和直接调用普通方法没有区别，这也是为什么编译期注解比运行时注解更受欢迎。</p>
<p data-omnivore-anchor-idx="174">但是并不是说为了性能运行期注解就不能用了，只能说不能滥用，要在性能方面给予考虑。目前主要的用到运行期注解的框架差不多都有缓存机制，只有在第一次使用时通过反射机制，当再次使用时直接从缓存中取出。</p>
<p data-omnivore-anchor-idx="175">好了，说着说着就跑题，还是来聊一下这个 AbstractProcessor 类吧，到底有何魅力让这么多人为她沉迷，方法如下：</p>
<pre data-omnivore-anchor-idx="176"><code data-omnivore-anchor-idx="177" class="hljs language-dart language-aspectj">
public <span data-omnivore-anchor-idx="178" class="hljs-class"><span data-omnivore-anchor-idx="179" class="hljs-keyword">class</span> <span data-omnivore-anchor-idx="180" class="hljs-title">MyFirstProcessor</span> <span data-omnivore-anchor-idx="181" class="hljs-keyword">extends</span> <span data-omnivore-anchor-idx="182" class="hljs-title">AbstractProcessor</span> </span>{

    <span data-omnivore-anchor-idx="183" class="hljs-comment"><span data-omnivore-anchor-idx="184" class="markdown">/**
<span data-omnivore-anchor-idx="185" class="hljs-bullet">     * </span>做一些初始化工作，注释处理工具框架调用了这个方法，给我们传递一个 ProcessingEnvironment 类型的实参。
<span data-omnivore-anchor-idx="186" class="hljs-bullet">     *
     </span>* <span data-omnivore-anchor-idx="187" class="xml"><span data-omnivore-anchor-idx="188" class="hljs-tag">&lt;<span data-omnivore-anchor-idx="189" class="hljs-name">p</span>&gt;</span></span>如果在同一个对象多次调用此方法，则抛出IllegalStateException异常。
<span data-omnivore-anchor-idx="190" class="hljs-bullet">     *
     </span>* @param processingEnvironment 这个参数里面包含了很多工具方法
<span data-omnivore-anchor-idx="191" class="hljs-code">     */</span></span></span>
    <span data-omnivore-anchor-idx="192" class="hljs-meta">@Override</span>
    public synchronized <span data-omnivore-anchor-idx="193" class="hljs-keyword">void</span> init(ProcessingEnvironment processingEnvironment) {

        <span data-omnivore-anchor-idx="194" class="hljs-comment">// 返回用来在元素上进行操作的某些工具方法的实现</span>
        Elements es = processingEnvironment.getElementUtils();
        <span data-omnivore-anchor-idx="195" class="hljs-comment">// 返回用来创建新源、类或辅助文件的Filer</span>
        Filer filer = processingEnvironment.getFiler();
        <span data-omnivore-anchor-idx="196" class="hljs-comment">// 返回用来在类型上进行操作的某些实用工具方法的实现</span>
        Types types = processingEnvironment.getTypeUtils();
        
        <span data-omnivore-anchor-idx="197" class="hljs-comment">// 这是提供给开发者日志工具，我们可以用来报告错误和警告以及提示信息</span>
        <span data-omnivore-anchor-idx="198" class="hljs-comment">// 注意 message 使用后并不会结束过程，Kind 参数表示日志级别</span>
        Messager messager = processingEnvironment.getMessager();
        messager.printMessage(Diagnostic.Kind.ERROR, <span data-omnivore-anchor-idx="199" class="hljs-string">"例如当默认值为空则提示一个错误"</span>);
        <span data-omnivore-anchor-idx="200" class="hljs-comment">// 返回任何生成的源和类文件应该符合的源版本</span>
        SourceVersion version = processingEnvironment.getSourceVersion();

        <span data-omnivore-anchor-idx="201" class="hljs-keyword">super</span>.init(processingEnvironment);
    }

    <span data-omnivore-anchor-idx="202" class="hljs-comment"><span data-omnivore-anchor-idx="203" class="markdown">/**
<span data-omnivore-anchor-idx="204" class="hljs-bullet">     * </span>@return 如果返回true 不要求后续Processor处理它们，反之，则继续执行处理。
<span data-omnivore-anchor-idx="205" class="hljs-code">     */</span></span></span>
    <span data-omnivore-anchor-idx="206" class="hljs-meta">@Override</span>
    public boolean process(<span data-omnivore-anchor-idx="207" class="hljs-built_in">Set</span>&lt;? <span data-omnivore-anchor-idx="208" class="hljs-keyword">extends</span> TypeElement&gt; <span data-omnivore-anchor-idx="209" class="hljs-keyword">set</span>, RoundEnvironment roundEnvironment) {

        <span data-omnivore-anchor-idx="210" class="hljs-comment"><span data-omnivore-anchor-idx="211" class="markdown">/**
<span data-omnivore-anchor-idx="212" class="hljs-bullet">         * </span>TypeElement 这表示一个类或者接口元素集合常用方法不多，TypeMirror getSuperclass()返回直接超类。
<span data-omnivore-anchor-idx="213" class="hljs-bullet">         * 
         </span>* <span data-omnivore-anchor-idx="214" class="xml"><span data-omnivore-anchor-idx="215" class="hljs-tag">&lt;<span data-omnivore-anchor-idx="216" class="hljs-name">p</span>&gt;</span></span>详细介绍下 RoundEnvironment 这个类,常用方法：
<span data-omnivore-anchor-idx="217" class="hljs-bullet">         * </span>boolean errorRaised() 如果在以前的处理round中发生错误，则返回true
<span data-omnivore-anchor-idx="218" class="hljs-bullet">         * </span>Set<span data-omnivore-anchor-idx="219" class="xml"><span data-omnivore-anchor-idx="220" class="php"><span data-omnivore-anchor-idx="221" class="hljs-meta">&lt;?</span> extends Element&gt;</span></span> getElementsAnnotatedWith(Class<span data-omnivore-anchor-idx="222" class="xml"><span data-omnivore-anchor-idx="223" class="php"><span data-omnivore-anchor-idx="224" class="hljs-meta">&lt;?</span> extends Annotation&gt;</span></span> </span>a<span data-omnivore-anchor-idx="225" class="markdown">)
<span data-omnivore-anchor-idx="226" class="hljs-bullet">         * </span>这里的 </span>a<span data-omnivore-anchor-idx="227" class="markdown"> 即你自定义的注解class类，返回使用给定注解类型注解的元素的集合
<span data-omnivore-anchor-idx="228" class="hljs-bullet">         * </span>Set<span data-omnivore-anchor-idx="229" class="xml"><span data-omnivore-anchor-idx="230" class="php"><span data-omnivore-anchor-idx="231" class="hljs-meta">&lt;?</span> extends Element&gt;</span></span> getElementsAnnotatedWith(TypeElement </span>a<span data-omnivore-anchor-idx="232" class="markdown">)
<span data-omnivore-anchor-idx="233" class="hljs-bullet">         * 
         </span>* <span data-omnivore-anchor-idx="234" class="xml"><span data-omnivore-anchor-idx="235" class="hljs-tag">&lt;<span data-omnivore-anchor-idx="236" class="hljs-name">p</span>&gt;</span></span>Element 的用法：
<span data-omnivore-anchor-idx="237" class="hljs-bullet">         * </span>TypeMirror asType() 返回此元素定义的类型 如int
<span data-omnivore-anchor-idx="238" class="hljs-bullet">         * </span>ElementKind getKind() 返回元素的类型 如 e.getkind() = ElementKind.FIELD 字段
<span data-omnivore-anchor-idx="239" class="hljs-bullet">         * </span>boolean equals(Object obj) 如果参数表示与此元素相同的元素，则返回true
<span data-omnivore-anchor-idx="240" class="hljs-bullet">         * </span>Name getSimpleName() 返回此元素的简单名称
<span data-omnivore-anchor-idx="241" class="hljs-bullet">         * </span>List<span data-omnivore-anchor-idx="242" class="xml"><span data-omnivore-anchor-idx="243" class="php"><span data-omnivore-anchor-idx="244" class="hljs-meta">&lt;?</span> extends Elements&gt;</span></span> getEncloseElements 返回元素直接封装的元素
<span data-omnivore-anchor-idx="245" class="hljs-bullet">         * </span>Element getEnclosingElements 返回此元素的最里层元素，如果这个元素是个字段等，则返回为类
<span data-omnivore-anchor-idx="246" class="hljs-code">         */</span></span></span>

        <span data-omnivore-anchor-idx="247" class="hljs-keyword">return</span> <span data-omnivore-anchor-idx="248" class="hljs-keyword">false</span>;
    }

    <span data-omnivore-anchor-idx="249" class="hljs-comment"><span data-omnivore-anchor-idx="250" class="markdown">/**
<span data-omnivore-anchor-idx="251" class="hljs-bullet">     * </span>指出注解处理器 处理哪种注解
<span data-omnivore-anchor-idx="252" class="hljs-bullet">     * </span>在 jdk1.7 中，我们可以使用注解 {@SupportedAnnotationTypes()} 代替
<span data-omnivore-anchor-idx="253" class="hljs-code">     */</span></span></span>
    <span data-omnivore-anchor-idx="254" class="hljs-meta">@Override</span>
    public <span data-omnivore-anchor-idx="255" class="hljs-built_in">Set</span>&lt;<span data-omnivore-anchor-idx="256" class="hljs-built_in">String</span>&gt; getSupportedAnnotationTypes() {
        <span data-omnivore-anchor-idx="257" class="hljs-keyword">return</span> <span data-omnivore-anchor-idx="258" class="hljs-keyword">super</span>.getSupportedAnnotationTypes();
    }

    <span data-omnivore-anchor-idx="259" class="hljs-comment"><span data-omnivore-anchor-idx="260" class="markdown">/**
<span data-omnivore-anchor-idx="261" class="hljs-bullet">     * </span>指定当前注解器使用的Jdk版本。
<span data-omnivore-anchor-idx="262" class="hljs-bullet">     * </span>在 jdk1.7 中，我们可以使用注解{@SupportedSourceVersion()}代替
<span data-omnivore-anchor-idx="263" class="hljs-code">     */</span></span></span>
    <span data-omnivore-anchor-idx="264" class="hljs-meta">@Override</span>
    public SourceVersion getSupportedSourceVersion() {
        <span data-omnivore-anchor-idx="265" class="hljs-keyword">return</span> <span data-omnivore-anchor-idx="266" class="hljs-keyword">super</span>.getSupportedSourceVersion();
    }
}

</code></pre>
<h2 data-omnivore-anchor-idx="267" data-id="heading-5">自定义运行期注解（RUNTIME）</h2>
<p data-omnivore-anchor-idx="268">我们在开发中经常会需要计算一个方法所要执行的时间，以此来直观的比较哪个实现方式最优，常用方法是开始结束时间相减</p>
<blockquote data-omnivore-anchor-idx="269">
<p data-omnivore-anchor-idx="270">System.currentTimeMillis()</p>
</blockquote>
<p data-omnivore-anchor-idx="271">但是当方法多的时候，是不是减来减去都要减的怀疑人生啦，哈哈，那么下面我就来写一个运行时注解来打印方法执行的时间。</p>
<p data-omnivore-anchor-idx="272"><strong data-omnivore-anchor-idx="273">1.首先我们先定义一个注解，并给注解添加我们需要的元注解：</strong></p>
<pre data-omnivore-anchor-idx="274"><code data-omnivore-anchor-idx="275" class="hljs language-dart language-kotlin"><span data-omnivore-anchor-idx="276" class="hljs-comment"><span data-omnivore-anchor-idx="277" class="markdown">/**
<span data-omnivore-anchor-idx="278" class="hljs-bullet"> * </span>这是一个自定义的计算方法执行时间的注解。
<span data-omnivore-anchor-idx="279" class="hljs-bullet"> * </span>只能作用于方法之上,属于运行时注解，能被VM处理，可以通过反射得到注解信息。
 */</span></span>
<span data-omnivore-anchor-idx="280" class="hljs-meta">@Target</span>(ElementType.METHOD)
<span data-omnivore-anchor-idx="281" class="hljs-meta">@Retention</span>(RetentionPolicy.RUNTIME)
public <span data-omnivore-anchor-idx="282" class="hljs-meta">@interface</span> CalculateMethodRunningTime {

    <span data-omnivore-anchor-idx="283" class="hljs-comment">// 要计算时间的方法的名字</span>
    <span data-omnivore-anchor-idx="284" class="hljs-built_in">String</span> methodName() <span data-omnivore-anchor-idx="285" class="hljs-keyword">default</span> <span data-omnivore-anchor-idx="286" class="hljs-string">"no method to set"</span>;
}
</code></pre>
<p data-omnivore-anchor-idx="287"><strong data-omnivore-anchor-idx="288">2.利用反射方法在程序运行时，获取被添加注解的类的信息：</strong></p>
<pre data-omnivore-anchor-idx="289"><code data-omnivore-anchor-idx="290" class="hljs language-reasonml language-gradle">public <span data-omnivore-anchor-idx="291" class="hljs-keyword">class</span> AnnotationUtils {

    <span data-omnivore-anchor-idx="292" class="hljs-comment">// 使用反射通过类名获取类的相关信息。</span>
    public static void get<span data-omnivore-anchor-idx="293" class="hljs-constructor">ClassInfo(String <span data-omnivore-anchor-idx="294" class="hljs-params">className</span>)</span> {
        <span data-omnivore-anchor-idx="295" class="hljs-keyword">try</span> {
            Class c = <span data-omnivore-anchor-idx="296" class="hljs-module-access"><span data-omnivore-anchor-idx="297" class="hljs-module"><span data-omnivore-anchor-idx="298" class="hljs-identifier">Class</span>.</span></span>for<span data-omnivore-anchor-idx="299" class="hljs-constructor">Name(<span data-omnivore-anchor-idx="300" class="hljs-params">className</span>)</span>;
            <span data-omnivore-anchor-idx="301" class="hljs-comment">// 获取所有公共的方法</span>
            Method<span data-omnivore-anchor-idx="302" class="hljs-literal">[]</span> methods = c.get<span data-omnivore-anchor-idx="303" class="hljs-constructor">Methods()</span>;
            for (Method m : methods) {
                Class&lt;CalculateMethodRunningTime&gt; ctClass = <span data-omnivore-anchor-idx="304" class="hljs-module-access"><span data-omnivore-anchor-idx="305" class="hljs-module"><span data-omnivore-anchor-idx="306" class="hljs-identifier">CalculateMethodRunningTime</span>.</span></span><span data-omnivore-anchor-idx="307" class="hljs-keyword">class</span>;
                <span data-omnivore-anchor-idx="308" class="hljs-keyword">if</span> (m.is<span data-omnivore-anchor-idx="309" class="hljs-constructor">AnnotationPresent(<span data-omnivore-anchor-idx="310" class="hljs-params">ctClass</span>)</span>) {
                    CalculateMethodRunningTime anno = m.get<span data-omnivore-anchor-idx="311" class="hljs-constructor">Annotation(<span data-omnivore-anchor-idx="312" class="hljs-params">ctClass</span>)</span>;
                    <span data-omnivore-anchor-idx="313" class="hljs-comment">// 当前方法包含查询时间的注解时</span>
                    <span data-omnivore-anchor-idx="314" class="hljs-keyword">if</span> (anno != null) {
                        final long beginTime = <span data-omnivore-anchor-idx="315" class="hljs-module-access"><span data-omnivore-anchor-idx="316" class="hljs-module"><span data-omnivore-anchor-idx="317" class="hljs-identifier">System</span>.</span></span>current<span data-omnivore-anchor-idx="318" class="hljs-constructor">TimeMillis()</span>;
                        m.invoke(c.<span data-omnivore-anchor-idx="319" class="hljs-keyword">new</span><span data-omnivore-anchor-idx="320" class="hljs-constructor">Instance()</span>, null);
                        final long time = <span data-omnivore-anchor-idx="321" class="hljs-module-access"><span data-omnivore-anchor-idx="322" class="hljs-module"><span data-omnivore-anchor-idx="323" class="hljs-identifier">System</span>.</span></span>current<span data-omnivore-anchor-idx="324" class="hljs-constructor">TimeMillis()</span> - beginTime;
                        <span data-omnivore-anchor-idx="325" class="hljs-module-access"><span data-omnivore-anchor-idx="326" class="hljs-module"><span data-omnivore-anchor-idx="327" class="hljs-identifier">Log</span>.</span></span>i(<span data-omnivore-anchor-idx="328" class="hljs-string">"Tag"</span>, anno.<span data-omnivore-anchor-idx="329" class="hljs-keyword">method</span><span data-omnivore-anchor-idx="330" class="hljs-constructor">Name()</span> + <span data-omnivore-anchor-idx="331" class="hljs-string">"方法执行所需要时间："</span> + time + <span data-omnivore-anchor-idx="332" class="hljs-string">"ms"</span>);
                    }
                }
            }
        } catch (Exception e) {
            e.print<span data-omnivore-anchor-idx="333" class="hljs-constructor">StackTrace()</span>;
        }
    }
}
</code></pre>
<p data-omnivore-anchor-idx="334"><strong data-omnivore-anchor-idx="335">3.在 activity 中使用注解，注意咱们的注解是作用于方法之上的：</strong></p>
<pre data-omnivore-anchor-idx="336"><code data-omnivore-anchor-idx="337" class="hljs language-scala language-java">public <span data-omnivore-anchor-idx="338" class="hljs-class"><span data-omnivore-anchor-idx="339" class="hljs-keyword">class</span> <span data-omnivore-anchor-idx="340" class="hljs-title">ActivityAnnotattion</span> <span data-omnivore-anchor-idx="341" class="hljs-keyword">extends</span> <span data-omnivore-anchor-idx="342" class="hljs-title">AppCompatActivity</span> </span>{

    <span data-omnivore-anchor-idx="343" class="hljs-meta">@Override</span>
    <span data-omnivore-anchor-idx="344" class="hljs-keyword">protected</span> void onCreate(<span data-omnivore-anchor-idx="345" class="hljs-type">Bundle</span> savedInstanceState) {
        <span data-omnivore-anchor-idx="346" class="hljs-keyword">super</span>.onCreate(savedInstanceState);
        setContentView(<span data-omnivore-anchor-idx="347" class="hljs-type">R</span>.layout.activity_anno);
        <span data-omnivore-anchor-idx="348" class="hljs-type">AnnotationUtils</span>.getClassInfo(<span data-omnivore-anchor-idx="349" class="hljs-string">"com.annotation.zmj.annotationtest.ActivityAnnotattion"</span>);
    }

    <span data-omnivore-anchor-idx="350" class="hljs-meta">@CalculateMethodRunningTime</span>(methodName = <span data-omnivore-anchor-idx="351" class="hljs-string">"method1"</span>)
    public void method1() {
        long i = <span data-omnivore-anchor-idx="352" class="hljs-number">100000000</span>L;
        <span data-omnivore-anchor-idx="353" class="hljs-keyword">while</span> (i &gt; <span data-omnivore-anchor-idx="354" class="hljs-number">0</span>) { i--; }
    }

}
</code></pre>
<p data-omnivore-anchor-idx="355"><strong data-omnivore-anchor-idx="356">4.运行结果：</strong></p>
<p data-omnivore-anchor-idx="357"><img data-omnivore-anchor-idx="358" data-omnivore-original-src="https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/60781f6e7b364e18bf4917a2b622edbd~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp" src="https://proxy-prod.omnivore-image-cache.app/0x0,s7sZShexee7tyBL60q5nob62z5r7cWytRSVfuml1nAL8/https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/60781f6e7b364e18bf4917a2b622edbd~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp" alt="这里写图片描述" loading="lazy"></p>
<h2 data-omnivore-anchor-idx="359" data-id="heading-6">自定义编译期注解（CLASS）</h2>
<p data-omnivore-anchor-idx="360">为什么要最后说编译期注解呢，因为相对前面的自定义注解来说，编译期注解有些难度，涉及到的东西比较多，但却是平时用到的最多的注解，因为编译期注解不存在反射，所以对性能没有影响。</p>
<p data-omnivore-anchor-idx="361">本来也想用绑定 View 的例子讲解，但是现在这样的 demo 网上各种泛滥，而且还有各路大牛写的，所以我就没必要班门弄斧了。在这里以跳转界面为例：</p>
<pre data-omnivore-anchor-idx="362"><code data-omnivore-anchor-idx="363" class="hljs language-fortran language-irpf90">    <span data-omnivore-anchor-idx="364" class="hljs-keyword">Intent</span> <span data-omnivore-anchor-idx="365" class="hljs-keyword">intent</span> = new <span data-omnivore-anchor-idx="366" class="hljs-keyword">Intent</span> (this, NextActivity.<span data-omnivore-anchor-idx="367" class="hljs-keyword">class</span>);
    startActivity (<span data-omnivore-anchor-idx="368" class="hljs-keyword">intent</span>);
</code></pre>
<p data-omnivore-anchor-idx="369">本着方便就是改进的原则，让我们定义一个编译期注解，来自动生成上述的代码，想想每次需要的时候只需要一个注解就能跳转到想要跳转的界面是不是很刺激。</p>
<p data-omnivore-anchor-idx="370"><strong data-omnivore-anchor-idx="371">1.首先新建一个 android 项目，在创建两个 java module（File -&gt; New -&gt; new Module -&gt;java Module），因为有的类在android项目中不支持，建完后项目结构如下：</strong></p>
<p data-omnivore-anchor-idx="372"><img data-omnivore-anchor-idx="373" data-omnivore-original-src="https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/11465ff967e54952a63a3fa4e9a006f7~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp" src="https://proxy-prod.omnivore-image-cache.app/0x0,sy3P7XmXQQetWBnSt6bVv8-qvmSiYa1t9wf4r2T0dCr4/https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/11465ff967e54952a63a3fa4e9a006f7~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp" alt="这里写图片描述" loading="lazy"></p>
<p data-omnivore-anchor-idx="374">其中 annotation 中盛放自定义的注解，annotationprocessor 中创建注解处理器并做相关处理，最后的 app 则为我们的项目。</p>
<p data-omnivore-anchor-idx="375">注意：MyFirstProcessor类为上文讲解 AbstractProcessor 所建的类，可以删去，跟本项目没有关系。</p>
<p data-omnivore-anchor-idx="376"><strong data-omnivore-anchor-idx="377">2.处理各自的依赖</strong></p>
<p data-omnivore-anchor-idx="378"><img data-omnivore-anchor-idx="379" data-omnivore-original-src="https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/7bd83eabeda84908bc77682a259c317f~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp" src="https://proxy-prod.omnivore-image-cache.app/0x0,sj0P0HJl8MSxzgN9JSSCRDJ6_yXbKVOPcpFmsbtC1bbI/https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/7bd83eabeda84908bc77682a259c317f~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp" alt="annotation" loading="lazy"></p>
<p data-omnivore-anchor-idx="380"><img data-omnivore-anchor-idx="381" data-omnivore-original-src="https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/68e4814c9c3f4b3cba175f2865266def~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp" src="https://proxy-prod.omnivore-image-cache.app/0x0,smdm96iJ_9sKvVRzwBYUfKeYeoQzRvqFL-dqCMQMKW1M/https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/68e4814c9c3f4b3cba175f2865266def~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp" alt="processor" loading="lazy"></p>
<p data-omnivore-anchor-idx="382"><img data-omnivore-anchor-idx="383" data-omnivore-original-src="https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/6183148385534851a4164872ceef9d47~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp" src="https://proxy-prod.omnivore-image-cache.app/0x0,s4v6N2-Wi_MJk-i44XHZfRbX4s57gg85txr0FYqlXQBc/https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/6183148385534851a4164872ceef9d47~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp" alt="app" loading="lazy"></p>
<p data-omnivore-anchor-idx="384"><strong data-omnivore-anchor-idx="385">3.编写自定义注解，这是一个应用到字段之上的注解，被注解的字段为传递的参数</strong></p>
<pre data-omnivore-anchor-idx="386"><code data-omnivore-anchor-idx="387" class="hljs language-dart language-kotlin"><span data-omnivore-anchor-idx="388" class="hljs-comment"><span data-omnivore-anchor-idx="389" class="markdown">/**
<span data-omnivore-anchor-idx="390" class="hljs-bullet"> * </span>这是一个自定义的跳转传值所用到的注解。
<span data-omnivore-anchor-idx="391" class="hljs-bullet"> * </span>value 表示要跳转到哪个界面activity的元素，传入那个界面的名字。
 */</span></span>
<span data-omnivore-anchor-idx="392" class="hljs-meta">@Retention</span>(RetentionPolicy.CLASS)
<span data-omnivore-anchor-idx="393" class="hljs-meta">@Target</span>(ElementType.FIELD)
public <span data-omnivore-anchor-idx="394" class="hljs-meta">@interface</span> IntentField {
    <span data-omnivore-anchor-idx="395" class="hljs-built_in">String</span> value () <span data-omnivore-anchor-idx="396" class="hljs-keyword">default</span> <span data-omnivore-anchor-idx="397" class="hljs-string">" "</span>;
}
</code></pre>
<p data-omnivore-anchor-idx="398"><strong data-omnivore-anchor-idx="399">4.自定义注解处理器，获取被注解元素的类型，进行相应的操作。</strong></p>
<pre data-omnivore-anchor-idx="400"><code data-omnivore-anchor-idx="401" class="hljs language-dart language-scala"><span data-omnivore-anchor-idx="402" class="hljs-meta">@AutoService</span>(javax.annotation.processing.Processor<span data-omnivore-anchor-idx="403" class="hljs-class">.<span data-omnivore-anchor-idx="404" class="hljs-keyword">class</span>)
<span data-omnivore-anchor-idx="405" class="hljs-title">public</span> <span data-omnivore-anchor-idx="406" class="hljs-title">class</span> <span data-omnivore-anchor-idx="407" class="hljs-title">MyProcessot</span> <span data-omnivore-anchor-idx="408" class="hljs-keyword">extends</span> <span data-omnivore-anchor-idx="409" class="hljs-title">AbstractProcessor</span></span>{

    private <span data-omnivore-anchor-idx="410" class="hljs-built_in">Map</span>&lt;<span data-omnivore-anchor-idx="411" class="hljs-built_in">Element</span>, <span data-omnivore-anchor-idx="412" class="hljs-built_in">List</span>&lt;VariableElement&gt;&gt; items = <span data-omnivore-anchor-idx="413" class="hljs-keyword">new</span> HashMap&lt;&gt;();
    private <span data-omnivore-anchor-idx="414" class="hljs-built_in">List</span>&lt;Generator&gt; generators = <span data-omnivore-anchor-idx="415" class="hljs-keyword">new</span> LinkedList&lt;&gt;();

    <span data-omnivore-anchor-idx="416" class="hljs-comment">// 做一些初始化工作</span>
    <span data-omnivore-anchor-idx="417" class="hljs-meta">@Override</span>
    public synchronized <span data-omnivore-anchor-idx="418" class="hljs-keyword">void</span> init(ProcessingEnvironment processingEnvironment) {
        <span data-omnivore-anchor-idx="419" class="hljs-keyword">super</span>.init(processingEnvironment);
        Utils.init();
        generators.add(<span data-omnivore-anchor-idx="420" class="hljs-keyword">new</span> ActivityEnterGenerator());
        generators.add(<span data-omnivore-anchor-idx="421" class="hljs-keyword">new</span> ActivityInitFieldGenerator());
    }

    <span data-omnivore-anchor-idx="422" class="hljs-meta">@Override</span>
    public boolean process(<span data-omnivore-anchor-idx="423" class="hljs-built_in">Set</span>&lt;? <span data-omnivore-anchor-idx="424" class="hljs-keyword">extends</span> TypeElement&gt; <span data-omnivore-anchor-idx="425" class="hljs-keyword">set</span>, RoundEnvironment roundEnvironment) {

        <span data-omnivore-anchor-idx="426" class="hljs-comment">// 获取所有注册IntentField注解的元素</span>
        <span data-omnivore-anchor-idx="427" class="hljs-keyword">for</span> (<span data-omnivore-anchor-idx="428" class="hljs-built_in">Element</span> elem : roundEnvironment.getElementsAnnotatedWith(IntentField<span data-omnivore-anchor-idx="429" class="hljs-class">.<span data-omnivore-anchor-idx="430" class="hljs-keyword">class</span>)) </span>{
            <span data-omnivore-anchor-idx="431" class="hljs-comment">// 主要获取ElementType 是不是null，即class，interface，enum或者注解类型</span>
            <span data-omnivore-anchor-idx="432" class="hljs-keyword">if</span> (elem.getEnclosingElement() == <span data-omnivore-anchor-idx="433" class="hljs-keyword">null</span>) {
                <span data-omnivore-anchor-idx="434" class="hljs-comment">// 直接结束处理器</span>
                <span data-omnivore-anchor-idx="435" class="hljs-keyword">return</span> <span data-omnivore-anchor-idx="436" class="hljs-keyword">true</span>;
            }

            <span data-omnivore-anchor-idx="437" class="hljs-comment">// 如果items的key不存在，则添加一个key</span>
            <span data-omnivore-anchor-idx="438" class="hljs-keyword">if</span> (items.<span data-omnivore-anchor-idx="439" class="hljs-keyword">get</span>(elem.getEnclosingElement()) == <span data-omnivore-anchor-idx="440" class="hljs-keyword">null</span>) {
                items.put(elem.getEnclosingElement(), <span data-omnivore-anchor-idx="441" class="hljs-keyword">new</span> LinkedList&lt;VariableElement&gt;());
            }

            <span data-omnivore-anchor-idx="442" class="hljs-comment">// 我们这里的IntentField是应用在一般成员变量上的注解</span>
            <span data-omnivore-anchor-idx="443" class="hljs-keyword">if</span> (elem.getKind() == ElementKind.FIELD) {
                items.<span data-omnivore-anchor-idx="444" class="hljs-keyword">get</span>(elem.getEnclosingElement()).add((VariableElement)elem);
            }
        }

        <span data-omnivore-anchor-idx="445" class="hljs-built_in">List</span>&lt;VariableElement&gt; variableElements;
        <span data-omnivore-anchor-idx="446" class="hljs-keyword">for</span> (<span data-omnivore-anchor-idx="447" class="hljs-built_in">Map</span>.Entry&lt;<span data-omnivore-anchor-idx="448" class="hljs-built_in">Element</span>, <span data-omnivore-anchor-idx="449" class="hljs-built_in">List</span>&lt;VariableElement&gt;&gt; entry : items.entrySet()) {
            variableElements = entry.getValue();
            <span data-omnivore-anchor-idx="450" class="hljs-keyword">if</span> (variableElements == <span data-omnivore-anchor-idx="451" class="hljs-keyword">null</span> || variableElements.isEmpty()) {
                <span data-omnivore-anchor-idx="452" class="hljs-keyword">return</span> <span data-omnivore-anchor-idx="453" class="hljs-keyword">true</span>;
            }
            <span data-omnivore-anchor-idx="454" class="hljs-comment">// 去通过自动javapoet生成代码</span>
            <span data-omnivore-anchor-idx="455" class="hljs-keyword">for</span> (Generator generator : generators) {
                generator.genetate(entry.getKey(), variableElements, processingEnv);
                generator.genetate(entry.getKey(), variableElements, processingEnv);
            }
        }
        <span data-omnivore-anchor-idx="456" class="hljs-keyword">return</span> <span data-omnivore-anchor-idx="457" class="hljs-keyword">false</span>;
    }

    <span data-omnivore-anchor-idx="458" class="hljs-comment">// 指定当前注解器使用的Java版本</span>
    <span data-omnivore-anchor-idx="459" class="hljs-meta">@Override</span> public SourceVersion getSupportedSourceVersion() {
        <span data-omnivore-anchor-idx="460" class="hljs-keyword">return</span> SourceVersion.latestSupported();
    }

    <span data-omnivore-anchor-idx="461" class="hljs-comment">// 指出注解处理器 处理哪种注解</span>
    <span data-omnivore-anchor-idx="462" class="hljs-meta">@Override</span>
    public <span data-omnivore-anchor-idx="463" class="hljs-built_in">Set</span>&lt;<span data-omnivore-anchor-idx="464" class="hljs-built_in">String</span>&gt; getSupportedAnnotationTypes() {
        <span data-omnivore-anchor-idx="465" class="hljs-built_in">Set</span>&lt;<span data-omnivore-anchor-idx="466" class="hljs-built_in">String</span>&gt; annotations = <span data-omnivore-anchor-idx="467" class="hljs-keyword">new</span> LinkedHashSet&lt;&gt;(<span data-omnivore-anchor-idx="468" class="hljs-number">2</span>);
        annotations.add(IntentField<span data-omnivore-anchor-idx="469" class="hljs-class">.<span data-omnivore-anchor-idx="470" class="hljs-keyword">class</span>.<span data-omnivore-anchor-idx="471" class="hljs-title">getCanonicalName</span>());
        <span data-omnivore-anchor-idx="472" class="hljs-title">return</span> <span data-omnivore-anchor-idx="473" class="hljs-title">annotations</span>;
    }
}
</span></code></pre>
<p data-omnivore-anchor-idx="474"><strong data-omnivore-anchor-idx="475">5.这是一个工具类方法，提供了本 demo 中所用到的一些方法，其实实际里面的方法都很常见，只不过做了一个封装而已.</strong></p>
<pre data-omnivore-anchor-idx="476"><code data-omnivore-anchor-idx="477" class="hljs language-reasonml language-processing">public <span data-omnivore-anchor-idx="478" class="hljs-keyword">class</span> Utils {

    <span data-omnivore-anchor-idx="479" class="hljs-keyword">private</span> static Set&lt;String&gt; supportTypes = <span data-omnivore-anchor-idx="480" class="hljs-keyword">new</span> HashSet&lt;&gt;<span data-omnivore-anchor-idx="481" class="hljs-literal">()</span>;

    <span data-omnivore-anchor-idx="482" class="hljs-comment">/** 当getIntent的时候，每种类型写的方式都不一样，所以把每种方式都添加到了Set容器中。*/</span>
    static void init<span data-omnivore-anchor-idx="483" class="hljs-literal">()</span> {
        supportTypes.add(<span data-omnivore-anchor-idx="484" class="hljs-built_in">int</span>.<span data-omnivore-anchor-idx="485" class="hljs-keyword">class</span>.get<span data-omnivore-anchor-idx="486" class="hljs-constructor">SimpleName()</span>);
        supportTypes.add(<span data-omnivore-anchor-idx="487" class="hljs-built_in">int</span><span data-omnivore-anchor-idx="488" class="hljs-literal">[]</span>.<span data-omnivore-anchor-idx="489" class="hljs-keyword">class</span>.get<span data-omnivore-anchor-idx="490" class="hljs-constructor">SimpleName()</span>);
        supportTypes.add(short.<span data-omnivore-anchor-idx="491" class="hljs-keyword">class</span>.get<span data-omnivore-anchor-idx="492" class="hljs-constructor">SimpleName()</span>);
        supportTypes.add(short<span data-omnivore-anchor-idx="493" class="hljs-literal">[]</span>.<span data-omnivore-anchor-idx="494" class="hljs-keyword">class</span>.get<span data-omnivore-anchor-idx="495" class="hljs-constructor">SimpleName()</span>);
        supportTypes.add(<span data-omnivore-anchor-idx="496" class="hljs-module-access"><span data-omnivore-anchor-idx="497" class="hljs-module"><span data-omnivore-anchor-idx="498" class="hljs-identifier">String</span>.</span></span><span data-omnivore-anchor-idx="499" class="hljs-keyword">class</span>.get<span data-omnivore-anchor-idx="500" class="hljs-constructor">SimpleName()</span>);
        supportTypes.add(String<span data-omnivore-anchor-idx="501" class="hljs-literal">[]</span>.<span data-omnivore-anchor-idx="502" class="hljs-keyword">class</span>.get<span data-omnivore-anchor-idx="503" class="hljs-constructor">SimpleName()</span>);
        supportTypes.add(boolean.<span data-omnivore-anchor-idx="504" class="hljs-keyword">class</span>.get<span data-omnivore-anchor-idx="505" class="hljs-constructor">SimpleName()</span>);
        supportTypes.add(boolean<span data-omnivore-anchor-idx="506" class="hljs-literal">[]</span>.<span data-omnivore-anchor-idx="507" class="hljs-keyword">class</span>.get<span data-omnivore-anchor-idx="508" class="hljs-constructor">SimpleName()</span>);
        supportTypes.add(long.<span data-omnivore-anchor-idx="509" class="hljs-keyword">class</span>.get<span data-omnivore-anchor-idx="510" class="hljs-constructor">SimpleName()</span>);
        supportTypes.add(long<span data-omnivore-anchor-idx="511" class="hljs-literal">[]</span>.<span data-omnivore-anchor-idx="512" class="hljs-keyword">class</span>.get<span data-omnivore-anchor-idx="513" class="hljs-constructor">SimpleName()</span>);
        supportTypes.add(<span data-omnivore-anchor-idx="514" class="hljs-built_in">char</span>.<span data-omnivore-anchor-idx="515" class="hljs-keyword">class</span>.get<span data-omnivore-anchor-idx="516" class="hljs-constructor">SimpleName()</span>);
        supportTypes.add(<span data-omnivore-anchor-idx="517" class="hljs-built_in">char</span><span data-omnivore-anchor-idx="518" class="hljs-literal">[]</span>.<span data-omnivore-anchor-idx="519" class="hljs-keyword">class</span>.get<span data-omnivore-anchor-idx="520" class="hljs-constructor">SimpleName()</span>);
        supportTypes.add(byte.<span data-omnivore-anchor-idx="521" class="hljs-keyword">class</span>.get<span data-omnivore-anchor-idx="522" class="hljs-constructor">SimpleName()</span>);
        supportTypes.add(byte<span data-omnivore-anchor-idx="523" class="hljs-literal">[]</span>.<span data-omnivore-anchor-idx="524" class="hljs-keyword">class</span>.get<span data-omnivore-anchor-idx="525" class="hljs-constructor">SimpleName()</span>);
        supportTypes.add(<span data-omnivore-anchor-idx="526" class="hljs-string">"Bundle"</span>);
    }

    <span data-omnivore-anchor-idx="527" class="hljs-comment">/** 获取元素所在的包名。*/</span>
    public static String get<span data-omnivore-anchor-idx="528" class="hljs-constructor">PackageName(Element <span data-omnivore-anchor-idx="529" class="hljs-params">element</span>)</span> {
        String clazzSimpleName = element.get<span data-omnivore-anchor-idx="530" class="hljs-constructor">SimpleName()</span>.<span data-omnivore-anchor-idx="531" class="hljs-keyword">to</span><span data-omnivore-anchor-idx="532" class="hljs-constructor">String()</span>;
        String clazzName = element.<span data-omnivore-anchor-idx="533" class="hljs-keyword">to</span><span data-omnivore-anchor-idx="534" class="hljs-constructor">String()</span>;
        return clazzName.substring(<span data-omnivore-anchor-idx="535" class="hljs-number">0</span>, clazzName.length<span data-omnivore-anchor-idx="536" class="hljs-literal">()</span> - clazzSimpleName.length<span data-omnivore-anchor-idx="537" class="hljs-literal">()</span> - <span data-omnivore-anchor-idx="538" class="hljs-number">1</span>);
    }


    <span data-omnivore-anchor-idx="539" class="hljs-comment">/** 判断是否是String类型或者数组或者bundle，因为这三种类型getIntent()不需要默认值。*/</span>
    public static boolean is<span data-omnivore-anchor-idx="540" class="hljs-constructor">ElementNoDefaultValue(String <span data-omnivore-anchor-idx="541" class="hljs-params">typeName</span>)</span> {
        return (<span data-omnivore-anchor-idx="542" class="hljs-module-access"><span data-omnivore-anchor-idx="543" class="hljs-module"><span data-omnivore-anchor-idx="544" class="hljs-identifier">String</span>.</span></span><span data-omnivore-anchor-idx="545" class="hljs-keyword">class</span>.get<span data-omnivore-anchor-idx="546" class="hljs-constructor">Name()</span>.equals(typeName)<span data-omnivore-anchor-idx="547" class="hljs-operator"> || </span>typeName.contains(<span data-omnivore-anchor-idx="548" class="hljs-string">"[]"</span>)<span data-omnivore-anchor-idx="549" class="hljs-operator"> || </span>typeName.contains(<span data-omnivore-anchor-idx="550" class="hljs-string">"Bundle"</span>));
    }

    <span data-omnivore-anchor-idx="551" class="hljs-comment">/**
     * 获得注解要传递参数的类型。
     * @param typeName 注解获取到的参数类型
     */</span>
    public static String get<span data-omnivore-anchor-idx="552" class="hljs-constructor">IntentTypeName(String <span data-omnivore-anchor-idx="553" class="hljs-params">typeName</span>)</span> {
        for (String name : supportTypes) {
            <span data-omnivore-anchor-idx="554" class="hljs-keyword">if</span> (name.equals(get<span data-omnivore-anchor-idx="555" class="hljs-constructor">SimpleName(<span data-omnivore-anchor-idx="556" class="hljs-params">typeName</span>)</span>)) {
                return name.replace<span data-omnivore-anchor-idx="557" class="hljs-constructor">First(String.<span data-omnivore-anchor-idx="558" class="hljs-params">valueOf</span>(<span data-omnivore-anchor-idx="559" class="hljs-params">name</span>.<span data-omnivore-anchor-idx="560" class="hljs-params">charAt</span>(0)</span>), <span data-omnivore-anchor-idx="561" class="hljs-module-access"><span data-omnivore-anchor-idx="562" class="hljs-module"><span data-omnivore-anchor-idx="563" class="hljs-identifier">String</span>.</span></span>value<span data-omnivore-anchor-idx="564" class="hljs-constructor">Of(<span data-omnivore-anchor-idx="565" class="hljs-params">name</span>.<span data-omnivore-anchor-idx="566" class="hljs-params">charAt</span>(0)</span>).<span data-omnivore-anchor-idx="567" class="hljs-keyword">to</span><span data-omnivore-anchor-idx="568" class="hljs-constructor">UpperCase()</span>)
                        .replace(<span data-omnivore-anchor-idx="569" class="hljs-string">"[]"</span>, <span data-omnivore-anchor-idx="570" class="hljs-string">"Array"</span>);
            }
        }
        return <span data-omnivore-anchor-idx="571" class="hljs-string">""</span>;
    }

    <span data-omnivore-anchor-idx="572" class="hljs-comment">/**
     * 获取类的的名字的字符串。
     * @param typeName 可以是包名字符串，也可以是类名字符串
     */</span>
    static String get<span data-omnivore-anchor-idx="573" class="hljs-constructor">SimpleName(String <span data-omnivore-anchor-idx="574" class="hljs-params">typeName</span>)</span> {
        <span data-omnivore-anchor-idx="575" class="hljs-keyword">if</span> (typeName.contains(<span data-omnivore-anchor-idx="576" class="hljs-string">"."</span>)) {
            return typeName.substring(typeName.last<span data-omnivore-anchor-idx="577" class="hljs-constructor">IndexOf(<span data-omnivore-anchor-idx="578" class="hljs-string">"."</span>)</span> + <span data-omnivore-anchor-idx="579" class="hljs-number">1</span>, typeName.length<span data-omnivore-anchor-idx="580" class="hljs-literal">()</span>);
        }<span data-omnivore-anchor-idx="581" class="hljs-keyword">else</span> {
            return typeName;
        }
    }


    <span data-omnivore-anchor-idx="582" class="hljs-comment">/** 自动生成代码。*/</span>
    public static void write<span data-omnivore-anchor-idx="583" class="hljs-constructor">ToFile(String <span data-omnivore-anchor-idx="584" class="hljs-params">className</span>, String <span data-omnivore-anchor-idx="585" class="hljs-params">packageName</span>, MethodSpec <span data-omnivore-anchor-idx="586" class="hljs-params">methodSpec</span>, ProcessingEnvironment <span data-omnivore-anchor-idx="587" class="hljs-params">processingEnv</span>, ArrayList&lt;FieldSpec&gt; <span data-omnivore-anchor-idx="588" class="hljs-params">listField</span>)</span> {
        TypeSpec genedClass;
        <span data-omnivore-anchor-idx="589" class="hljs-keyword">if</span>(listField<span data-omnivore-anchor-idx="590" class="hljs-operator"> == </span>null) {
            genedClass = <span data-omnivore-anchor-idx="591" class="hljs-module-access"><span data-omnivore-anchor-idx="592" class="hljs-module"><span data-omnivore-anchor-idx="593" class="hljs-identifier">TypeSpec</span>.</span></span><span data-omnivore-anchor-idx="594" class="hljs-keyword">class</span><span data-omnivore-anchor-idx="595" class="hljs-constructor">Builder(<span data-omnivore-anchor-idx="596" class="hljs-params">className</span>)</span>
                    .add<span data-omnivore-anchor-idx="597" class="hljs-constructor">Modifiers(Modifier.PUBLIC, Modifier.FINAL)</span>
                    .add<span data-omnivore-anchor-idx="598" class="hljs-constructor">Method(<span data-omnivore-anchor-idx="599" class="hljs-params">methodSpec</span>)</span>.build<span data-omnivore-anchor-idx="600" class="hljs-literal">()</span>;
        }<span data-omnivore-anchor-idx="601" class="hljs-keyword">else</span>{
            genedClass = <span data-omnivore-anchor-idx="602" class="hljs-module-access"><span data-omnivore-anchor-idx="603" class="hljs-module"><span data-omnivore-anchor-idx="604" class="hljs-identifier">TypeSpec</span>.</span></span><span data-omnivore-anchor-idx="605" class="hljs-keyword">class</span><span data-omnivore-anchor-idx="606" class="hljs-constructor">Builder(<span data-omnivore-anchor-idx="607" class="hljs-params">className</span>)</span>
                    .add<span data-omnivore-anchor-idx="608" class="hljs-constructor">Modifiers(Modifier.PUBLIC, Modifier.FINAL)</span>
                    .add<span data-omnivore-anchor-idx="609" class="hljs-constructor">Method(<span data-omnivore-anchor-idx="610" class="hljs-params">methodSpec</span>)</span>
                    .add<span data-omnivore-anchor-idx="611" class="hljs-constructor">Fields(<span data-omnivore-anchor-idx="612" class="hljs-params">listField</span>)</span>.build<span data-omnivore-anchor-idx="613" class="hljs-literal">()</span>;
        }
        JavaFile javaFile = <span data-omnivore-anchor-idx="614" class="hljs-module-access"><span data-omnivore-anchor-idx="615" class="hljs-module"><span data-omnivore-anchor-idx="616" class="hljs-identifier">JavaFile</span>.</span></span>builder(packageName, genedClass)
                .build<span data-omnivore-anchor-idx="617" class="hljs-literal">()</span>;
        <span data-omnivore-anchor-idx="618" class="hljs-keyword">try</span> {
            javaFile.write<span data-omnivore-anchor-idx="619" class="hljs-constructor">To(<span data-omnivore-anchor-idx="620" class="hljs-params">processingEnv</span>.<span data-omnivore-anchor-idx="621" class="hljs-params">getFiler</span>()</span>);
        } catch (IOException e) {
            e.print<span data-omnivore-anchor-idx="622" class="hljs-constructor">StackTrace()</span>;
        }
    }

}

</code></pre>
<p data-omnivore-anchor-idx="623"><strong data-omnivore-anchor-idx="624">6.自定义一个接口，把需要自动生成的每个java文件的方法都独立出去。</strong></p>
<pre data-omnivore-anchor-idx="625"><code data-omnivore-anchor-idx="626" class="hljs language-routeros language-angelscript">public<span data-omnivore-anchor-idx="627" class="hljs-built_in"> interface </span>Generator {
    void genetate(Element typeElement
            , List&lt;VariableElement&gt; variableElements
            , ProcessingEnvironment processingEnv);

}
</code></pre>
<p data-omnivore-anchor-idx="628"><strong data-omnivore-anchor-idx="629">7.编写自动生成文件的格式，生成后的类格式如下：</strong></p>
<p data-omnivore-anchor-idx="630"><img data-omnivore-anchor-idx="631" data-omnivore-original-src="https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/dd95fe937e9b469eb75673b2a0ce6626~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp" src="https://proxy-prod.omnivore-image-cache.app/0x0,saQ9B4gb5wIS6zVEyXY13Q33KQp-rCqCWUz0UnWtOgt8/https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/dd95fe937e9b469eb75673b2a0ce6626~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp" alt="跳转类格式" loading="lazy"></p>
<p data-omnivore-anchor-idx="632">上图为本例中的MainActivity$Enter类，如果你想生成一个类，那么这个类的格式和作用肯定已经在你的脑海中有了定型，如果你自己都不知道想要生成啥，那还玩啥。</p>
<pre data-omnivore-anchor-idx="633"><code data-omnivore-anchor-idx="634" class="hljs language-reasonml language-dart"><span data-omnivore-anchor-idx="635" class="hljs-comment">/**
 * 这是一个要自动生成跳转功能的.java文件类
 * 主要思路：1.使用javapoet生成一个空方法
 *         2.为方法加上实参
 *         3.方法的里面的代码拼接
 * 主要需要：获取字段的类型和名字，获取将要跳转的类的名字
 */</span>
public <span data-omnivore-anchor-idx="636" class="hljs-keyword">class</span> ActivityEnterGenerator implements Generator{

    <span data-omnivore-anchor-idx="637" class="hljs-keyword">private</span> static final String SUFFIX = <span data-omnivore-anchor-idx="638" class="hljs-string">"$Enter"</span>;

    <span data-omnivore-anchor-idx="639" class="hljs-keyword">private</span> static final String METHOD_NAME = <span data-omnivore-anchor-idx="640" class="hljs-string">"intentTo"</span>;

    @Override
    public void genetate(Element typeElement, List&lt;VariableElement&gt; variableElements,  ProcessingEnvironment processingEnv) {
        MethodSpec.Builder methodBuilder = <span data-omnivore-anchor-idx="641" class="hljs-module-access"><span data-omnivore-anchor-idx="642" class="hljs-module"><span data-omnivore-anchor-idx="643" class="hljs-identifier">MethodSpec</span>.</span></span><span data-omnivore-anchor-idx="644" class="hljs-keyword">method</span><span data-omnivore-anchor-idx="645" class="hljs-constructor">Builder(METHOD_NAME)</span>
                .add<span data-omnivore-anchor-idx="646" class="hljs-constructor">Modifiers(Modifier.PUBLIC)</span>
                .returns(void.<span data-omnivore-anchor-idx="647" class="hljs-keyword">class</span>);
        <span data-omnivore-anchor-idx="648" class="hljs-comment">// 设置生成的METHOD_NAME方法第一个参数</span>
        methodBuilder.add<span data-omnivore-anchor-idx="649" class="hljs-constructor">Parameter(Object.<span data-omnivore-anchor-idx="650" class="hljs-params">class</span>, <span data-omnivore-anchor-idx="651" class="hljs-string">"context"</span>)</span>;
        methodBuilder.add<span data-omnivore-anchor-idx="652" class="hljs-constructor">Statement(<span data-omnivore-anchor-idx="653" class="hljs-string">"android.content.Intent intent = new android.content.Intent()"</span>)</span>;

        <span data-omnivore-anchor-idx="654" class="hljs-comment">// 获取将要跳转的类的名字</span>
        String name = <span data-omnivore-anchor-idx="655" class="hljs-string">""</span>;

        <span data-omnivore-anchor-idx="656" class="hljs-comment">// VariableElement 主要代表一般字段元素，是Element的一种</span>
        for (VariableElement element : variableElements) {
            <span data-omnivore-anchor-idx="657" class="hljs-comment">// Element 只是一种语言元素，本身并不包含信息，所以我们这里获取TypeMirror</span>
            TypeMirror typeMirror = element.<span data-omnivore-anchor-idx="658" class="hljs-keyword">as</span><span data-omnivore-anchor-idx="659" class="hljs-constructor">Type()</span>;
            <span data-omnivore-anchor-idx="660" class="hljs-comment">// 获取注解在身上的字段的类型</span>
            TypeName <span data-omnivore-anchor-idx="661" class="hljs-keyword">type</span> = <span data-omnivore-anchor-idx="662" class="hljs-module-access"><span data-omnivore-anchor-idx="663" class="hljs-module"><span data-omnivore-anchor-idx="664" class="hljs-identifier">TypeName</span>.</span></span>get(typeMirror);
            <span data-omnivore-anchor-idx="665" class="hljs-comment">// 获取注解在身上字段的名字</span>
            String fileName = element.get<span data-omnivore-anchor-idx="666" class="hljs-constructor">SimpleName()</span>.<span data-omnivore-anchor-idx="667" class="hljs-keyword">to</span><span data-omnivore-anchor-idx="668" class="hljs-constructor">String()</span>;
            <span data-omnivore-anchor-idx="669" class="hljs-comment">// 设置生成的METHOD_NAME方法第二个参数</span>
            methodBuilder.add<span data-omnivore-anchor-idx="670" class="hljs-constructor">Parameter(<span data-omnivore-anchor-idx="671" class="hljs-params">type</span>, <span data-omnivore-anchor-idx="672" class="hljs-params">fileName</span>)</span>;
            methodBuilder.add<span data-omnivore-anchor-idx="673" class="hljs-constructor">Statement(<span data-omnivore-anchor-idx="674" class="hljs-string">"intent.putExtra(\""</span> + <span data-omnivore-anchor-idx="675" class="hljs-params">fileName</span> + <span data-omnivore-anchor-idx="676" class="hljs-string">"\","</span> +<span data-omnivore-anchor-idx="677" class="hljs-params">fileName</span> + <span data-omnivore-anchor-idx="678" class="hljs-string">")"</span>)</span>;
            <span data-omnivore-anchor-idx="679" class="hljs-comment">// 获取注解上的元素</span>
            IntentField toClassName = element.get<span data-omnivore-anchor-idx="680" class="hljs-constructor">Annotation(IntentField.<span data-omnivore-anchor-idx="681" class="hljs-params">class</span>)</span>;
            String name1 = toClassName.value<span data-omnivore-anchor-idx="682" class="hljs-literal">()</span>;
            <span data-omnivore-anchor-idx="683" class="hljs-keyword">if</span>(null != name<span data-omnivore-anchor-idx="684" class="hljs-operator"> &amp;&amp; </span><span data-omnivore-anchor-idx="685" class="hljs-string">""</span>.equals(name)){
                name = name1;
            }
            <span data-omnivore-anchor-idx="686" class="hljs-comment">// 理论上每个界面上的注解value一样，都是要跳转到的那个类名字，否则提示错误</span>
            <span data-omnivore-anchor-idx="687" class="hljs-keyword">else</span> <span data-omnivore-anchor-idx="688" class="hljs-keyword">if</span>(name1 != null<span data-omnivore-anchor-idx="689" class="hljs-operator"> &amp;&amp; </span>!name1.equals(name)){
                processingEnv.get<span data-omnivore-anchor-idx="690" class="hljs-constructor">Messager()</span>.print<span data-omnivore-anchor-idx="691" class="hljs-constructor">Message(Diagnostic.Kind.ERROR, <span data-omnivore-anchor-idx="692" class="hljs-string">"同一个界面不能跳转到多个活动，即value必须一致"</span>)</span>;
            }
        }
        methodBuilder.add<span data-omnivore-anchor-idx="693" class="hljs-constructor">Statement(<span data-omnivore-anchor-idx="694" class="hljs-string">"intent.setClass((android.content.Context)context, "</span> + <span data-omnivore-anchor-idx="695" class="hljs-params">name</span> +<span data-omnivore-anchor-idx="696" class="hljs-string">".class)"</span>)</span>;
        methodBuilder.add<span data-omnivore-anchor-idx="697" class="hljs-constructor">Statement(<span data-omnivore-anchor-idx="698" class="hljs-string">"((android.content.Context)context).startActivity(intent)"</span>)</span>;

        <span data-omnivore-anchor-idx="699" class="hljs-comment">/**
         * 自动生成.java文件
         * 第一个参数：要生成的类的名字
         * 第二个参数：生成类所在的包的名字
         * 第三个参数：javapoet 中提供的与自动生成代码的相关的类
         * 第四个参数：能够为注解器提供Elements,Types和Filer
         */</span>
        <span data-omnivore-anchor-idx="700" class="hljs-module-access"><span data-omnivore-anchor-idx="701" class="hljs-module"><span data-omnivore-anchor-idx="702" class="hljs-identifier">Utils</span>.</span></span>write<span data-omnivore-anchor-idx="703" class="hljs-constructor">ToFile(<span data-omnivore-anchor-idx="704" class="hljs-params">typeElement</span>.<span data-omnivore-anchor-idx="705" class="hljs-params">getSimpleName</span>()</span>.<span data-omnivore-anchor-idx="706" class="hljs-keyword">to</span><span data-omnivore-anchor-idx="707" class="hljs-constructor">String()</span> + SUFFIX, <span data-omnivore-anchor-idx="708" class="hljs-module-access"><span data-omnivore-anchor-idx="709" class="hljs-module"><span data-omnivore-anchor-idx="710" class="hljs-identifier">Utils</span>.</span></span>get<span data-omnivore-anchor-idx="711" class="hljs-constructor">PackageName(<span data-omnivore-anchor-idx="712" class="hljs-params">typeElement</span>)</span>, methodBuilder.build<span data-omnivore-anchor-idx="713" class="hljs-literal">()</span>, processingEnv,null);
    }

}
</code></pre>
<p data-omnivore-anchor-idx="714">当我们定义了跳转的类，那么接下来肯定就是在另一个界面获取传递过来的数据了，参考格式如下，这是本demo中自动生成的MainActivity$Init 类。</p>
<p data-omnivore-anchor-idx="715"><img data-omnivore-anchor-idx="716" data-omnivore-original-src="https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/d01cf2e1741e40d9b937eb22f84f9858~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp" src="https://proxy-prod.omnivore-image-cache.app/0x0,sjAQJc8Q66H__vjUtMibjQ7KuWBucaj_mZ4SkiTqhDcs/https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/d01cf2e1741e40d9b937eb22f84f9858~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp" alt="获取参数格式" loading="lazy"></p>
<pre data-omnivore-anchor-idx="717"><code data-omnivore-anchor-idx="718" class="hljs language-dart language-processing"><span data-omnivore-anchor-idx="719" class="hljs-comment"><span data-omnivore-anchor-idx="720" class="markdown">/**
<span data-omnivore-anchor-idx="721" class="hljs-bullet"> * </span>要生成一个.Java文件，在这个Java文件里生成一个获取上个界面传递过来数据的方法
<span data-omnivore-anchor-idx="722" class="hljs-bullet"> * </span>主要思路：1.使用Javapoet生成一个空的的方法
<span data-omnivore-anchor-idx="723" class="hljs-bullet"> *         </span>2.为方法添加需要的形参
<span data-omnivore-anchor-idx="724" class="hljs-bullet"> *         </span>3.拼接方法内部的代码
<span data-omnivore-anchor-idx="725" class="hljs-bullet"> * </span>主要需要：获取传递过来字段的类型
 */</span></span>
public <span data-omnivore-anchor-idx="726" class="hljs-class"><span data-omnivore-anchor-idx="727" class="hljs-keyword">class</span> <span data-omnivore-anchor-idx="728" class="hljs-title">ActivityInitFieldGenerator</span> <span data-omnivore-anchor-idx="729" class="hljs-keyword">implements</span> <span data-omnivore-anchor-idx="730" class="hljs-title">Generator</span> </span>{

    private <span data-omnivore-anchor-idx="731" class="hljs-keyword">static</span> <span data-omnivore-anchor-idx="732" class="hljs-keyword">final</span> <span data-omnivore-anchor-idx="733" class="hljs-built_in">String</span> SUFFIX = <span data-omnivore-anchor-idx="734" class="hljs-string">"<span data-omnivore-anchor-idx="735" class="hljs-subst">$Init</span>"</span>;

    private <span data-omnivore-anchor-idx="736" class="hljs-keyword">static</span> <span data-omnivore-anchor-idx="737" class="hljs-keyword">final</span> <span data-omnivore-anchor-idx="738" class="hljs-built_in">String</span> METHOD_NAME = <span data-omnivore-anchor-idx="739" class="hljs-string">"initFields"</span>;

    <span data-omnivore-anchor-idx="740" class="hljs-meta">@Override</span>
    public <span data-omnivore-anchor-idx="741" class="hljs-keyword">void</span> genetate(<span data-omnivore-anchor-idx="742" class="hljs-built_in">Element</span> typeElement, <span data-omnivore-anchor-idx="743" class="hljs-built_in">List</span>&lt;VariableElement&gt; variableElements, ProcessingEnvironment processingEnv) {

        MethodSpec.Builder methodBuilder = MethodSpec.methodBuilder(METHOD_NAME)
                .addModifiers(Modifier.PROTECTED)
                .returns(<span data-omnivore-anchor-idx="744" class="hljs-built_in">Object</span><span data-omnivore-anchor-idx="745" class="hljs-class">.<span data-omnivore-anchor-idx="746" class="hljs-keyword">class</span>);

        <span data-omnivore-anchor-idx="747" class="hljs-title">final</span> <span data-omnivore-anchor-idx="748" class="hljs-title">ArrayList</span>&lt;<span data-omnivore-anchor-idx="749" class="hljs-title">FieldSpec</span>&gt; <span data-omnivore-anchor-idx="750" class="hljs-title">listField</span> = <span data-omnivore-anchor-idx="751" class="hljs-title">new</span> <span data-omnivore-anchor-idx="752" class="hljs-title">ArrayList</span>&lt;&gt;();

        <span data-omnivore-anchor-idx="753" class="hljs-title">if</span> (<span data-omnivore-anchor-idx="754" class="hljs-title">null</span> != <span data-omnivore-anchor-idx="755" class="hljs-title">variableElements</span> &amp;&amp; <span data-omnivore-anchor-idx="756" class="hljs-title">variableElements</span>.<span data-omnivore-anchor-idx="757" class="hljs-title">size</span>() != 0) </span>{
            VariableElement element = variableElements.<span data-omnivore-anchor-idx="758" class="hljs-keyword">get</span>(<span data-omnivore-anchor-idx="759" class="hljs-number">0</span>);
            <span data-omnivore-anchor-idx="760" class="hljs-comment">// 当前接收数据的字段的名字</span>
            IntentField currentClassName = element.getAnnotation(IntentField<span data-omnivore-anchor-idx="761" class="hljs-class">.<span data-omnivore-anchor-idx="762" class="hljs-keyword">class</span>);
            <span data-omnivore-anchor-idx="763" class="hljs-title">String</span> <span data-omnivore-anchor-idx="764" class="hljs-title">name</span> = <span data-omnivore-anchor-idx="765" class="hljs-title">currentClassName</span>.<span data-omnivore-anchor-idx="766" class="hljs-title">value</span>();

            <span data-omnivore-anchor-idx="767" class="hljs-title">methodBuilder</span>.<span data-omnivore-anchor-idx="768" class="hljs-title">addParameter</span>(<span data-omnivore-anchor-idx="769" class="hljs-title">Object</span>.<span data-omnivore-anchor-idx="770" class="hljs-title">class</span>, "<span data-omnivore-anchor-idx="771" class="hljs-title">currentActivity</span>");
            <span data-omnivore-anchor-idx="772" class="hljs-title">methodBuilder</span>.<span data-omnivore-anchor-idx="773" class="hljs-title">addStatement</span>(<span data-omnivore-anchor-idx="774" class="hljs-title">name</span> + " <span data-omnivore-anchor-idx="775" class="hljs-title">activity</span> = (" + <span data-omnivore-anchor-idx="776" class="hljs-title">name</span> + ")<span data-omnivore-anchor-idx="777" class="hljs-title">currentActivity</span>");
            <span data-omnivore-anchor-idx="778" class="hljs-title">methodBuilder</span>.<span data-omnivore-anchor-idx="779" class="hljs-title">addStatement</span>("<span data-omnivore-anchor-idx="780" class="hljs-title">android</span>.<span data-omnivore-anchor-idx="781" class="hljs-title">content</span>.<span data-omnivore-anchor-idx="782" class="hljs-title">Intent</span> <span data-omnivore-anchor-idx="783" class="hljs-title">intent</span> = <span data-omnivore-anchor-idx="784" class="hljs-title">activity</span>.<span data-omnivore-anchor-idx="785" class="hljs-title">getIntent</span>()");
        }

        <span data-omnivore-anchor-idx="786" class="hljs-title">for</span> (<span data-omnivore-anchor-idx="787" class="hljs-title">VariableElement</span> <span data-omnivore-anchor-idx="788" class="hljs-title">element</span> : <span data-omnivore-anchor-idx="789" class="hljs-title">variableElements</span>) </span>{

            <span data-omnivore-anchor-idx="790" class="hljs-comment">// 获取接收字段的类型</span>
            TypeName currentTypeName = TypeName.<span data-omnivore-anchor-idx="791" class="hljs-keyword">get</span>(element.asType());
            <span data-omnivore-anchor-idx="792" class="hljs-built_in">String</span> currentTypeNameStr = currentTypeName.toString();
            <span data-omnivore-anchor-idx="793" class="hljs-built_in">String</span> intentTypeName = Utils.getIntentTypeName(currentTypeNameStr);

            <span data-omnivore-anchor-idx="794" class="hljs-comment">// 字段的名字，即key值</span>
            Name filedName = element.getSimpleName();

            <span data-omnivore-anchor-idx="795" class="hljs-comment">// 创建成员变量</span>
            FieldSpec fieldSpec = FieldSpec.builder(TypeName.<span data-omnivore-anchor-idx="796" class="hljs-keyword">get</span>(element.asType()),filedName+<span data-omnivore-anchor-idx="797" class="hljs-string">""</span>)
                    .addModifiers(Modifier.PUBLIC)
                    .build();
            listField.add(fieldSpec);

            <span data-omnivore-anchor-idx="798" class="hljs-comment">// 因为String类型的获取 和 其他基本类型的获取在是否需要默认值问题上不一样，所以需要判断是哪种</span>
            <span data-omnivore-anchor-idx="799" class="hljs-keyword">if</span> (Utils.isElementNoDefaultValue(currentTypeNameStr)) {
                methodBuilder.addStatement(<span data-omnivore-anchor-idx="800" class="hljs-string">"this."</span>+filedName+<span data-omnivore-anchor-idx="801" class="hljs-string">"= intent.get"</span> + intentTypeName + <span data-omnivore-anchor-idx="802" class="hljs-string">"Extra(\""</span> + filedName + <span data-omnivore-anchor-idx="803" class="hljs-string">"\")"</span>);
            } <span data-omnivore-anchor-idx="804" class="hljs-keyword">else</span> {
                <span data-omnivore-anchor-idx="805" class="hljs-built_in">String</span> defaultValue = <span data-omnivore-anchor-idx="806" class="hljs-string">"default"</span> + element.getSimpleName();
                <span data-omnivore-anchor-idx="807" class="hljs-keyword">if</span> (intentTypeName == <span data-omnivore-anchor-idx="808" class="hljs-keyword">null</span>) {
                    <span data-omnivore-anchor-idx="809" class="hljs-comment">// 当字段类型为null时，需要打印错误信息</span>
                    processingEnv.getMessager().printMessage(Diagnostic.Kind.ERROR, <span data-omnivore-anchor-idx="810" class="hljs-string">"the type:"</span> + element.asType().toString() + <span data-omnivore-anchor-idx="811" class="hljs-string">" is not support"</span>);
                } <span data-omnivore-anchor-idx="812" class="hljs-keyword">else</span> {
                    <span data-omnivore-anchor-idx="813" class="hljs-keyword">if</span> (<span data-omnivore-anchor-idx="814" class="hljs-string">""</span>.equals(intentTypeName)) {
                        methodBuilder.addStatement(<span data-omnivore-anchor-idx="815" class="hljs-string">"this."</span> + filedName + <span data-omnivore-anchor-idx="816" class="hljs-string">"= ("</span> + TypeName.<span data-omnivore-anchor-idx="817" class="hljs-keyword">get</span>(element.asType()) + <span data-omnivore-anchor-idx="818" class="hljs-string">")intent.getSerializableExtra(\""</span> + filedName + <span data-omnivore-anchor-idx="819" class="hljs-string">"\")"</span>);
                    } <span data-omnivore-anchor-idx="820" class="hljs-keyword">else</span> {
                        methodBuilder.addParameter(TypeName.<span data-omnivore-anchor-idx="821" class="hljs-keyword">get</span>(element.asType()), defaultValue);
                        methodBuilder.addStatement(<span data-omnivore-anchor-idx="822" class="hljs-string">"this."</span>+ filedName +<span data-omnivore-anchor-idx="823" class="hljs-string">"= intent.get"</span>
                                + intentTypeName + <span data-omnivore-anchor-idx="824" class="hljs-string">"Extra(\""</span> + filedName + <span data-omnivore-anchor-idx="825" class="hljs-string">"\", "</span> + defaultValue + <span data-omnivore-anchor-idx="826" class="hljs-string">")"</span>);
                    }
                }
            }
        }
        methodBuilder.addStatement(<span data-omnivore-anchor-idx="827" class="hljs-string">"return this"</span>);
        Utils.writeToFile(typeElement.getSimpleName().toString() + SUFFIX,  Utils.getPackageName(typeElement), methodBuilder.build(), processingEnv, listField);
    }
}
</code></pre>
<p data-omnivore-anchor-idx="828"><strong data-omnivore-anchor-idx="829">8、在Activity中使用刚才的自定义注解。</strong></p>
<pre data-omnivore-anchor-idx="830"><code data-omnivore-anchor-idx="831" class="hljs language-reasonml language-java">public <span data-omnivore-anchor-idx="832" class="hljs-keyword">class</span> MainActivity extends AppCompatActivity {

    @<span data-omnivore-anchor-idx="833" class="hljs-constructor">IntentField(<span data-omnivore-anchor-idx="834" class="hljs-string">"NextActivity"</span>)</span>
    <span data-omnivore-anchor-idx="835" class="hljs-built_in">int</span> count = <span data-omnivore-anchor-idx="836" class="hljs-number">10</span>;
    @<span data-omnivore-anchor-idx="837" class="hljs-constructor">IntentField(<span data-omnivore-anchor-idx="838" class="hljs-string">"NextActivity"</span>)</span>
    String str = <span data-omnivore-anchor-idx="839" class="hljs-string">"编译器注解"</span>;
    @<span data-omnivore-anchor-idx="840" class="hljs-constructor">IntentField(<span data-omnivore-anchor-idx="841" class="hljs-string">"NextActivity"</span>)</span>
    StuBean bean = <span data-omnivore-anchor-idx="842" class="hljs-keyword">new</span> <span data-omnivore-anchor-idx="843" class="hljs-constructor">StuBean(1,<span data-omnivore-anchor-idx="844" class="hljs-string">"No1"</span>)</span>;

    @Override
    protected void on<span data-omnivore-anchor-idx="845" class="hljs-constructor">Create(Bundle <span data-omnivore-anchor-idx="846" class="hljs-params">savedInstanceState</span>)</span> {
        super.on<span data-omnivore-anchor-idx="847" class="hljs-constructor">Create(<span data-omnivore-anchor-idx="848" class="hljs-params">savedInstanceState</span>)</span>;
        set<span data-omnivore-anchor-idx="849" class="hljs-constructor">ContentView(R.<span data-omnivore-anchor-idx="850" class="hljs-params">layout</span>.<span data-omnivore-anchor-idx="851" class="hljs-params">activity_main</span>)</span>;
        add<span data-omnivore-anchor-idx="852" class="hljs-constructor">OnclickListener()</span>;
    }

    public void add<span data-omnivore-anchor-idx="853" class="hljs-constructor">OnclickListener()</span> {
        find<span data-omnivore-anchor-idx="854" class="hljs-constructor">ViewById(R.<span data-omnivore-anchor-idx="855" class="hljs-params">id</span>.<span data-omnivore-anchor-idx="856" class="hljs-params">tvnext</span>)</span>.set<span data-omnivore-anchor-idx="857" class="hljs-constructor">OnClickListener(<span data-omnivore-anchor-idx="858" class="hljs-params">new</span> View.OnClickListener()</span> {
            @Override
            public void on<span data-omnivore-anchor-idx="859" class="hljs-constructor">Click(View <span data-omnivore-anchor-idx="860" class="hljs-params">v</span>)</span> {
                <span data-omnivore-anchor-idx="861" class="hljs-comment">// 从哪个界面进行跳转，则以哪个界面打头，enter 结尾</span>
                <span data-omnivore-anchor-idx="862" class="hljs-comment">// 例如 MainActivity$Enter</span>
                <span data-omnivore-anchor-idx="863" class="hljs-keyword">new</span> <span data-omnivore-anchor-idx="864" class="hljs-constructor">MainActivity$Enter()</span>
                        .intent<span data-omnivore-anchor-idx="865" class="hljs-constructor">To(MainActivity.<span data-omnivore-anchor-idx="866" class="hljs-params">this</span>, <span data-omnivore-anchor-idx="867" class="hljs-params">count</span>, <span data-omnivore-anchor-idx="868" class="hljs-params">str</span>, <span data-omnivore-anchor-idx="869" class="hljs-params">bean</span>)</span>;
            }
        });
    }
}
</code></pre>
<p data-omnivore-anchor-idx="870"><strong data-omnivore-anchor-idx="871">9.这是实体bean</strong></p>
<pre data-omnivore-anchor-idx="872"><code data-omnivore-anchor-idx="873" class="hljs language-angelscript language-arduino"><span data-omnivore-anchor-idx="874" class="hljs-keyword">public</span> <span data-omnivore-anchor-idx="875" class="hljs-keyword">class</span> <span data-omnivore-anchor-idx="876" class="hljs-symbol">StuBean</span> <span data-omnivore-anchor-idx="877" class="hljs-symbol">implements</span> <span data-omnivore-anchor-idx="878" class="hljs-symbol">Serializable</span>{
    <span data-omnivore-anchor-idx="879" class="hljs-keyword">public</span> StuBean(<span data-omnivore-anchor-idx="880" class="hljs-built_in">int</span> id , String name) {
        <span data-omnivore-anchor-idx="881" class="hljs-keyword">this</span>.id = id;
        <span data-omnivore-anchor-idx="882" class="hljs-keyword">this</span>.name = name;
    }
    <span data-omnivore-anchor-idx="883" class="hljs-comment">//学号</span>
    <span data-omnivore-anchor-idx="884" class="hljs-keyword">public</span> <span data-omnivore-anchor-idx="885" class="hljs-built_in">int</span> id;
    <span data-omnivore-anchor-idx="886" class="hljs-comment">//姓名</span>
    <span data-omnivore-anchor-idx="887" class="hljs-keyword">public</span> String name;
}
</code></pre>
<p data-omnivore-anchor-idx="888"><strong data-omnivore-anchor-idx="889">10、在NextActivity接收并打印数据:</strong></p>
<pre data-omnivore-anchor-idx="890"><code data-omnivore-anchor-idx="891" class="hljs language-reasonml language-scala">public <span data-omnivore-anchor-idx="892" class="hljs-keyword">class</span> NextActivity extends AppCompatActivity {

    <span data-omnivore-anchor-idx="893" class="hljs-keyword">private</span> TextView textView;

    @Override
    protected void on<span data-omnivore-anchor-idx="894" class="hljs-constructor">Create(Bundle <span data-omnivore-anchor-idx="895" class="hljs-params">savedInstanceState</span>)</span> {
        super.on<span data-omnivore-anchor-idx="896" class="hljs-constructor">Create(<span data-omnivore-anchor-idx="897" class="hljs-params">savedInstanceState</span>)</span>;
        set<span data-omnivore-anchor-idx="898" class="hljs-constructor">ContentView(R.<span data-omnivore-anchor-idx="899" class="hljs-params">layout</span>.<span data-omnivore-anchor-idx="900" class="hljs-params">activity_next</span>)</span>;
        textView = (TextView) find<span data-omnivore-anchor-idx="901" class="hljs-constructor">ViewById(R.<span data-omnivore-anchor-idx="902" class="hljs-params">id</span>.<span data-omnivore-anchor-idx="903" class="hljs-params">tv</span>)</span>;
        
        <span data-omnivore-anchor-idx="904" class="hljs-comment">// 想获取从哪个界面传递过来的数据，就已哪个类打头，init结尾</span>
        <span data-omnivore-anchor-idx="905" class="hljs-comment">// 例如 MainActivity$Init</span>
        MainActivity$Init formIntent = (MainActivity$Init)<span data-omnivore-anchor-idx="906" class="hljs-keyword">new</span> <span data-omnivore-anchor-idx="907" class="hljs-constructor">MainActivity$Init()</span>.init<span data-omnivore-anchor-idx="908" class="hljs-constructor">Fields(<span data-omnivore-anchor-idx="909" class="hljs-params">this</span>,0)</span>;
        textView.set<span data-omnivore-anchor-idx="910" class="hljs-constructor">Text(<span data-omnivore-anchor-idx="911" class="hljs-params">formIntent</span>.<span data-omnivore-anchor-idx="912" class="hljs-params">count</span> + <span data-omnivore-anchor-idx="913" class="hljs-string">"---"</span> + <span data-omnivore-anchor-idx="914" class="hljs-params">formIntent</span>.<span data-omnivore-anchor-idx="915" class="hljs-params">str</span> + <span data-omnivore-anchor-idx="916" class="hljs-string">"---"</span> +<span data-omnivore-anchor-idx="917" class="hljs-params">formIntent</span>.<span data-omnivore-anchor-idx="918" class="hljs-params">bean</span>.<span data-omnivore-anchor-idx="919" class="hljs-params">name</span>)</span>;
      
        <span data-omnivore-anchor-idx="920" class="hljs-comment">// 打印上个界面传递过来的数据</span>
        <span data-omnivore-anchor-idx="921" class="hljs-module-access"><span data-omnivore-anchor-idx="922" class="hljs-module"><span data-omnivore-anchor-idx="923" class="hljs-identifier">Log</span>.</span></span>i(<span data-omnivore-anchor-idx="924" class="hljs-string">"Tag"</span>,formIntent.count + <span data-omnivore-anchor-idx="925" class="hljs-string">"---"</span> + formIntent.str + <span data-omnivore-anchor-idx="926" class="hljs-string">"---"</span> + formIntent.bean.name);
    }
}
</code></pre>
<p data-omnivore-anchor-idx="927"><strong data-omnivore-anchor-idx="928">11.运行结果：</strong></p>
<p data-omnivore-anchor-idx="929"><img data-omnivore-anchor-idx="930" data-omnivore-original-src="https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/7760b03f4c36477f911314459ea7e266~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp" src="https://proxy-prod.omnivore-image-cache.app/0x0,seYzJUQ-7Psw45QDGCoDl6ZO-8LOD6Y-wHULYm7bc0WM/https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/7760b03f4c36477f911314459ea7e266~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp" alt="这里写图片描述" loading="lazy"></p>
<h2 data-omnivore-anchor-idx="931" data-id="heading-7">总结</h2>
<p data-omnivore-anchor-idx="932">好了，看到这里，你应该对注解有所了解了，但是看的再懂也不如自己动手练一下。如果你仔细研究了，你会发现一个非常奇怪的事情，当我们设置 RetentionPolicy.CLASS 级别的时候，仍能通过反射获取注解信息，当我们设置 RetentionPolicy.SOURCE 级别的时候，仍能走通编译期注解，是不是非常迷惑。</p>
<p data-omnivore-anchor-idx="933">之后只能又找了一些资料（非权威），看到了一个比较受认同的解释：这个属性主要给IDE 或者编译器开发者准备的，一般应用级别上不太会用到。</p>
<blockquote data-omnivore-anchor-idx="934">
<p data-omnivore-anchor-idx="935">好了，本文到这里就结束了，关于注解的讲解应该非常全面了。</p>
</blockquote>
<p data-omnivore-anchor-idx="936"><strong data-omnivore-anchor-idx="937">参考</strong> 1、B.E，Java编程思想：机械工业出版社</p></div></article>  <!---->  <div data-omnivore-anchor-idx="938" init-follow-status="true" data-v-5762947c="" data-v-2c6459d4="" data-v-935cc2c6="">  <p data-omnivore-anchor-idx="939"><span data-omnivore-anchor-idx="940" data-v-935cc2c6="" z-index="100"><span data-omnivore-anchor-idx="941"> <div data-omnivore-anchor-idx="942" data-v-03256cc6="" data-v-935cc2c6=""><p data-omnivore-anchor-idx="943"><img data-omnivore-anchor-idx="944" data-omnivore-original-src="https://p26-passport.byteacctimg.com/img/user-avatar/51c39d694666d63e89edcd2e79a1977f~40x40.awebp" data-v-5244ef91="" data-v-03256cc6="" src="https://proxy-prod.omnivore-image-cache.app/0x0,sBK3Tl4yfrUjG6r3vgz7p3IP27lmfNiH0miLxRo0ZtCo/https://p26-passport.byteacctimg.com/img/user-avatar/51c39d694666d63e89edcd2e79a1977f~40x40.awebp" alt="avatar" loading="lazy"></p></div></span></span></p> <!----></div></div></DIV></DIV>

---

## Highlights

> java 提供的元注解
> 
> 作用
> 
> @Target
> 
> 定义你的注解应用到什么地方（详见下文解释）
> 
> @Retention
> 
> 定义该注解在哪个级别可用（详见下文解释）
> 
> @Documented
> 
> 将此注解包含在 javadoc 中
> 
> @Inherited
> 
> 允许子类继承超类中的注解 [⤴️](https://omnivore.app/me/android-annotation-18df8f7387e#8966a16f-8b1a-4802-a8d0-58f84711fb01) 

> 下面来看一下 ElementType 的全部参数含义：
> 
> | ElementType 参数                 | 说明                  |
> | ------------------------------ | ------------------- |
> | ElementType.CONSTRUCTOR        | 构造器的声明              |
> | ElementType.FIELD              | 域的声明（包括enum的实例）     |
> | ElementType.LOCATION\_VARLABLE | 局部变量的声明             |
> | ElementType.METHOD             | 方法的声明               |
> | ElementType.PACKAGE            | 包的声明                |
> | ElementType.PARAMETER          | 参数的声明               |
> | ElementType.TYPE               | 类、接口（包括注解类型）、enum声明 | [⤴️](https://omnivore.app/me/android-annotation-18df8f7387e#0028987b-f489-48a1-86b9-1f0bdaf756c2) 

> 下面来看一下 RetentionPolicy 的全部参数含义：
> 
> | RetentionPolicy 参数      | 说明                                   |
> | ----------------------- | ------------------------------------ |
> | RetentionPolicy.SOURCE  | 注解将被编译器丢弃，只能存于源代码中                   |
> | RetentionPolicy.CLASS   | 注解在class文件中可用，能够存于编译之后的字节码之中，但会被VM丢弃 |
> | RetentionPolicy.RUNTIME | VM在运行期也会保留注解，因此运行期注解可以通过反射获取注解的相关信息  | [⤴️](https://omnivore.app/me/android-annotation-18df8f7387e#9f029255-22d2-44f1-949c-3acf15c54555) 

> 其实处理过程都编写在了编译器里面，也就是说编译器已经给我们写好了处理方法，当编译器进行检查的时候就会调用相应的处理方法。 [⤴️](https://omnivore.app/me/android-annotation-18df8f7387e#c7b2052a-0fcd-4233-8f0d-b8155bd239fa) 

> 最简单的注解处理器莫过于，直接使用反射机制的 getDeclaredMethods 方法获取类上所有方法（字段原理是一样的），再通过调用 getAnnotation 获取每个方法上的特定注解 [⤴️](https://omnivore.app/me/android-annotation-18df8f7387e#05b5853a-6f12-4138-bbd0-9544d1add630) 

