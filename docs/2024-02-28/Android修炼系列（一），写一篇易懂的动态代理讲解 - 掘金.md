---
id: f4a09e8b-ecf5-45d1-ae96-a41e4a1c30df
---

# Android修炼系列（一），写一篇易懂的动态代理讲解 - 掘金
#Omnivore

[Read on Omnivore](https://omnivore.app/me/android-18dee7a9e06)
[Read Original](https://juejin.cn/post/6935029399125262349)

在说动态代理之前，先来简单看下代理模式。代理是最基本的设计模式之一。它能够插入一个用来替代“实际”对象的“代理”对象，来提供额外的或不同的操作。这些操作通常涉及与“实际”对象的通信，因此“代理”对象通常充当着中间人的角色。

### 代理模式

代理对象为“实际”对象提供一个替身或占位符以控制对这个“实际”对象的访问。被代理的对象可以是远程的对象，创建开销大的对象或需要安全控制的对象。来看下类图：

![代理模式](https://proxy-prod.omnivore-image-cache.app/0x0,snAAbdyqlygE3HHEijkdbGSZDclFATSGym9On3D2QwGs/https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/af6e9e39178c4d9f852f6a1b7f53f359~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp)

再来看下类图对应代码，这是IObject接口，真实对象RealObj和代理对象ObjProxy都实现此接口：

```angelscript
/**
 * 为实际对象Tested和代理对象TestedProxy提供对外接口
 */
public interface IObject {
    void request();
}

```

RealObj是实际处理request() 逻辑的对象，但是出于设计的考量，需要对RealObj内部的方法调用进行控制访问

```java
public class RealObject implements IObject {

    @Override
    public void request() {
        // 模拟一些操作
    }
}

```

ObjProxy是RealObj的代理类，其同样实现了IObject接口，所以具有相同的对外方法。客户端与RealObj的所有交互，都必须通过ObjProxy。

```java
public class ObjProxy implements IObject {
    IObject realT;

    public ObjProxy(IObject t) {
        realT = t;
    }

    @Override
    public void request() {
        if (isAllow()) realT.request();
    }

    private boolean isAllow() {
        return true;
    }
}

```

### 番外

代理模式和装饰者模式不管是在类图，还是在代码实现上，几乎是一样的，但我们为何还要进行划分呢？其实学设计模式，不能拘泥于格式，不能死记形式，重要的是要理解模式背后的意图，意图只有一个，但实现的形式却可能多种多样。这也就是为何那么多变体依然属于xx设计模式的原因。

==代理模式的意图是替代真正的对象以实现访问控制，而装饰者模式的意图是为对象加入额外的行为。==

### 动态代理

Java的动态代理可以动态的创建代理并动态的处理所代理方法的调用，在动态代理上所做的所以调用都会被重定向到单一的调用处理器上，它的工作是揭示调用的类型并确定相应的策略。类图见下：

![动态代理](https://proxy-prod.omnivore-image-cache.app/0x0,si_9lwt2Uy0vbup4_g7GZq8hCtaoZ_2IEiupqMZjc1lI/https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/836411f5fb3d4693a147219d1a528550~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp)

还以上面的代码为例，这是对外的接口IObject：

```routeros
public interface IObject {
    void request();
}

```

这是 InvocationHandler 的实现类，类图中 Proxy 的方法调用都会被系统传入此类，即 invoke 方法，而 ObjProxyHandler 又持有着 RealObject 实例，所以 ObjProxyHandler 是“真正”对 RealObject 对象进行访问控制的代理类。

```aspectj
public class ObjProxyHandler implements InvocationHandler {
    IObject realT;

    public ObjProxyHandler(IObject t) {
        realT = t;
    }

    @Override
    public Object invoke(Object proxy, Method method, Object[] args)
            throws Throwable {
        // request方法时，进行校验
        if (method.getName().equals("request") && !isAllow())
            return null;
        return method.invoke(realT, args);
    }

    private boolean isAllow() {
        return false;
    }
}

```

RealObj是实际处理request() 逻辑的对象。

```java
public class RealObject implements IObject {
    @Override
    public void request() {
        // 模拟一些操作
    }
}

```

==动态代理的使用方法如下：我们通过 Proxy.newProxyInstance 静态方法来创建代理，其参数如下，一个类加载器、一个代理实现的接口列表、一个 InvocationHandler 的接口实现。==

```haxe
    public void startTest() {
        IObject proxy = (IObject) Proxy.newProxyInstance(
                IObject.class.getClassLoader(),
                new Class[]{IObject.class},
                new ObjProxyHandler(new RealObject()));
        proxy.request(); // ObjProxyHandler的invoke方法会被调用
    }

```

### Proxy源码

来看下Proxy 源码，当我们 newProxyInstance(...) 时，首先系统会进行判空处理，之后获取我们实际的 Proxy 代理类 Class 对象，再通过一个参数的构造方法生成我们的代理对象 p（p : 返回值），这里能看出来 p 是持有我们的对象 h 的。注意 cons.setAccessible(true) 表示，即使是 cl 是私有构造，也可以获得对象。源码见下：

```gradle
public static Object newProxyInstance(ClassLoader loader,
                                          Class<?>[] interfaces,
                                          InvocationHandler h)
        throws IllegalArgumentException
    {
        Objects.requireNonNull(h);

        final Class<?>[] intfs = interfaces.clone();
     
        /*
         * Look up or generate the designated proxy class.
         */
        Class<?> cl = getProxyClass0(loader, intfs);
        ...
        final Constructor<?> cons = cl.getConstructor(constructorParams);
            final InvocationHandler ih = h;
            if (!Modifier.isPublic(cl.getModifiers())) {
                cons.setAccessible(true);
                // END Android-removed: Excluded AccessController.doPrivileged call.
            }
            return cons.newInstance(new Object[]{h});
        ...
    }

```

其中 getProxyClass0(...) 是用来检查并获取实际代理对象的。首先会有一个65535的接口限制检测，随后从代理缓存proxyClassCache 中获取代理类，如果给定的接口不存在，则通过 ProxyClassFactory 新建。见下：

```gradle
    private static Class<?> getProxyClass0(ClassLoader loader,
                                           Class<?>... interfaces) {
        if (interfaces.length > 65535) {
            throw new IllegalArgumentException("interface limit exceeded");
        }

        // If the proxy class defined by the given loader implementing
        // the given interfaces exists, this will simply return the cached copy;
        // otherwise, it will create the proxy class via the ProxyClassFactory
        return proxyClassCache.get(loader, interfaces);
    }

```

存放代理 Proxy.class 的缓存 proxyClassCache，是一个静态常量，所以在我们类加载时，其就已经被初始化完毕了。见下：

```gradle
private static final WeakCache<ClassLoader, Class<?>[], Class<?>>
        proxyClassCache = new WeakCache<>(new KeyFactory(), new ProxyClassFactory());

```

Proxy 提供的 getInvocationHandler(Object proxy)方法和 invoke(...) 方法很重要。分别为获取当前代理关联的调用处理器对象 InvocationHandler，并将当前Proxy方法调用 调度给 InvocationHandler。是不是与上面的代理思维很像，至于这两个方法何时被调用的，推测是写在了本地方法内，当我们调用proxy.request 方法时（系统创建Proxy时，会自动 implements 用户传递的接口，可以为多个），系统就会调用Proxy invoke 方法，随后proxy 将方法调用传递给 InvocationHandler。

```aspectj
public static InvocationHandler getInvocationHandler(Object proxy)
        throws IllegalArgumentException
    {
        /*
         * Verify that the object is actually a proxy instance.
         */
        if (!isProxyClass(proxy.getClass())) {
            throw new IllegalArgumentException("not a proxy instance");
        }
        final Proxy p = (Proxy) proxy;
        final InvocationHandler ih = p.h;
   
        return ih;
    }

    // Android-added: Helper method invoke(Proxy, Method, Object[]) for ART native code.
    private static Object invoke(Proxy proxy, Method method, Object[] args) throws Throwable {
        InvocationHandler h = proxy.h;
        return h.invoke(proxy, method, args);
    }

```

### ProxyClassFactory

重点是ProxyClassFactory 类，这里的逻辑不少，所以我将ProxyClassFactory 单独抽出来了。能看到，首先其会检测当前interface 是否已被当前类加载器所加载。

```angelscript
        Class<?> interfaceClass = null;
        try {
            interfaceClass = Class.forName(intf.getName(), false, loader);
        } catch (ClassNotFoundException e) {
        }
        if (interfaceClass != intf) {
            throw new IllegalArgumentException(
                intf + " is not visible from class loader");
        }

```

之后会进行判断是否为接口。这也是我们说的第二个参数为何不能传基类或抽象类的原因。

```haxe
        if (!interfaceClass.isInterface()) {
            throw new IllegalArgumentException(
                interfaceClass.getName() + " is not an interface");
        }

```

之后判断当前 interface 是否已经存在于缓存cache内了。

```gradle
        if (interfaceSet.put(interfaceClass, Boolean.TRUE) != null) {
            throw new IllegalArgumentException(
                "repeated interface: " + interfaceClass.getName());
        }

```

检测非 public 修饰符的 interface 是否在是同一个包名，如果不是则抛出异常

```nix
    for (Class<?> intf : interfaces) {
        int flags = intf.getModifiers();
        if (!Modifier.isPublic(flags)) {
            accessFlags = Modifier.FINAL;
            String name = intf.getName();
            int n = name.lastIndexOf('.');
            String pkg = ((n == -1) ? "" : name.substring(0, n + 1));
            if (proxyPkg == null) {
                proxyPkg = pkg;
            } else if (!pkg.equals(proxyPkg)) {
                throw new IllegalArgumentException(
                    "non-public interfaces from different packages");
            }
            ...


```

检验通过后，会 getMethods(...) 获取接口内的全部方法。

随后会对methords进行一个排序。具体的代码我就不贴了，排序规则是：如果方法相等（返回值和方法签名一样）或同是一个接口内方法，则当前顺序不变，如果两个方法所在的接口存在继承关系，则父类在前，子类在后。

之后 validateReturnTypes(...) 判断 methords 是否存在方法签名相同并且返回值类型也相同的methord，如果有则抛出异常。

之后通过 deduplicateAndGetExceptions(...) 方法，将 methords 方法内的相同方法的父类方法剔除掉，并将 methord 保存在数组中。

转成一维数组和二维数组，Method\[\] methodsArray，Class< ? >\[\]\[\] exceptionsArray，随后给当前代理类命名：包名 + “$Proxy” + num

==最后调用系统提供的 native 方法 generateProxy(...) 。这是真正的代理类创建方法。==感兴趣的可以查看下[java\_lang\_reflect\_Proxy.cc源码](https://link.juejin.cn/?target=http%3A%2F%2Faospxref.com%2Fandroid-10.0.0%5Fr2%2Fxref%2Fart%2Fruntime%2Fnative%2Fjava%5Flang%5Freflect%5FProxy.cc "http://aospxref.com/android-10.0.0_r2/xref/art/runtime/native/java_lang_reflect_Proxy.cc")和 [class\_linker.cc源码](https://link.juejin.cn/?target=http%3A%2F%2Faospxref.com%2Fandroid-10.0.0%5Fr2%2Fxref%2Fart%2Fruntime%2Fclass%5Flinker.cc "http://aospxref.com/android-10.0.0_r2/xref/art/runtime/class_linker.cc")

```gradle
        List<Method> methods = getMethods(interfaces);
        Collections.sort(methods, ORDER_BY_SIGNATURE_AND_SUBTYPE);
        validateReturnTypes(methods);
        List<Class<?>[]> exceptions = deduplicateAndGetExceptions(methods);

        Method[] methodsArray = methods.toArray(new Method[methods.size()]);
        Class<?>[][] exceptionsArray = exceptions.toArray(new Class<?>[exceptions.size()][]);

        /*
         * Choose a name for the proxy class to generate.
         */
        long num = nextUniqueNumber.getAndIncrement();
        String proxyName = proxyPkg + proxyClassNamePrefix + num;

        return generateProxy(proxyName, interfaces, loader, methodsArray,
                             exceptionsArray);

```

本文完。

参考 1、Head First 设计模式：中国电力出版社

---

## Highlights

> 代理模式的意图是替代真正的对象以实现访问控制，而装饰者模式的意图是为对象加入额外的行为。 [⤴️](https://omnivore.app/me/android-18dee7a9e06#865fd5c4-40d1-4626-9203-e64dff583845) 

> 动态代理的使用方法如下：我们通过 Proxy.newProxyInstance 静态方法来创建代理，其参数如下，一个类加载器、一个代理实现的接口列表、一个 InvocationHandler 的接口实现。 [⤴️](https://omnivore.app/me/android-18dee7a9e06#0f4d4af6-ecab-4002-81e2-a5fe329a7748) 

> 最后调用系统提供的 native 方法 generateProxy(...) 。这是真正的代理类创建方法。 [⤴️](https://omnivore.app/me/android-18dee7a9e06#345919a3-4a9f-412a-b911-8c01f50aa830) 

