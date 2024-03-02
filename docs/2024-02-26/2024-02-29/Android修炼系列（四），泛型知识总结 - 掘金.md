---
id: 69d0e8b3-bc34-488a-83d6-abebbeb22fdf
---

# Android修炼系列（四），泛型知识总结 - 掘金
#Omnivore

[Read on Omnivore](https://omnivore.app/me/android-18df42beab2)
[Read Original](https://juejin.cn/post/6936588753032970276)

说起泛型，不用想，肯定都是用的佛性，可用可不用四舍五入下就是不用。可现实是，你不用，我不用，可总有“别人家的孩子”在用，你说气不气。

![](https://proxy-prod.omnivore-image-cache.app/0x0,s3vf9zrQ4ZxTfCX8HER_xbL9iBRQRuufMJme7dEVYdXg/https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/bcce83e9fc324c74904a96a571b1b0e0~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp)

为何有了接口，我们还需要使用泛型呢？因为即便使用了接口，对于程序的约束还是太强。因为一旦指明了接口，就会要求我们的代码使用特定的接口，而我们的目的是希望编写出更通用的代码，是要使代码能够应用于某种不确定的类型，而不是一个具体的接口或类。这是《Java编程思想》说的，可不是我吹的，香不香看了才知道。本文主要涉及下面几个方面的介绍：

![](https://proxy-prod.omnivore-image-cache.app/0x0,s7Pq_nsfGskuHJikjgLawjwxVE-pP9cXlODXGs4oI_5E/https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/4776fd682a1f48c8b6ad33d59ea2ce7e~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp)

### 泛型类

泛型的目的是用来指定要持有什么类型的对象，而由编译器来保证类型的正确性。使用泛型参数 T，用尖括号括住，放在类后。

```cpp
public class Tested<T> {
    private T t;

    public void set(T t) {
        this.t = t;
    }

    public T get() {
        return t;
    }
}

```

现有测试类Test1th ：

```angelscript
public class Test1th { }

```

需要Tested持有什么类型的对象，将其放在尖括号内即可。泛型与多态不冲突，所以我们也可以使用其子类。

```arduino
    public void startTest() {
        Tested<Test1th> test = new Tested<>();
        test.set(new Test1th());
        Test1th td = test.get();
    }

```

很简单吧，如果我们需要Tested 持有多个对象呢？来看栗子：

```angelscript
public class Tested<A, B> {
    private A a;
    private B b;

    public void set(A a, B b) {
        this.a = a;
        this.b = b;
    }

    public A getA() {
        return a;
    }

    public B getB() {
        return b;
    }
}

```

新增测试类Test2th：

```angelscript
public class Test2th { }

```

在使用时，为A、B 指定类型。当然Tested<A, B> 也支持继承，可以通过Test2ed<A, B, C> extend Tested<A, B>来进行扩展。

```haxe
    public void startTest() {
        Tested<Test1th, Test2th> test = new Tested<>();
        test.set(new Test1th(), new Test2th());
        Test1th tdA = test.getA();
        Test2th tdB = test.getB();
    }

```

### 泛型接口

泛型也可应用于接口。泛型接口与泛型类在使用上相同。这里就拿常见的泛型接口 Iterable< T> 来举例吧，来让Tested<A, B> 具有简单迭代功能。注意在使用泛型接口时，要指定泛型接口的泛型参数类型。其中TestBase见下：

```angelscript
public class TestBase { }

```

栗子Tested<A, B>见下，也许你也注意到了Iterator< TestBase>，这说明泛型也是可以应用到匿名内部类之上的。

```java
public class Tested<A, B> implements Iterable<TestBase> {
    private A a;
    private B b;

    public Tested(A a, B b) {
        this.a = a;
        this.b = b;
    }

    @Override
    public Iterator<TestBase> iterator() {
        return new Iterator<TestBase>() {
            @Override
            public boolean hasNext() {
                return a != null || b != null;
            }

            @Override
            public TestBase next() {
                TestBase tb = null;
                if (a instanceof TestBase) {
                    tb = (TestBase) a;
                    a = null;
                } else if (b instanceof TestBase) {
                    tb = (TestBase) b;
                    b = null;
                }
                return tb;
            }
        };
    }
}

```

现在有测试类Test1th：

```scala
public class Test1th extends TestBase {
    @Override
    public String toString() {
        return getClass().getSimpleName();
    }
}

```

还有测试类Test2th：

```scala
public class Test2th extends TestBase {
    @Override
    public String toString() {
        return getClass().getSimpleName();
    }
}

```

在使用时，我们可以这样为泛型类Tested指定泛型参数类型。迭代如下：

```haxe
    public void startTest() {
        Tested<Test1th, Test2th> ts = new Tested<>(new Test1th(), new Test2th());
        for (TestBase t : ts) {
            String str = t.toString();
        }
    }

```

### 泛型方法

是否拥有泛型方法，与其所在的类是否是泛型类是没有关系的。说白了就是泛型方法是可以独立于类的，而且泛型方法也能更清楚的表达意图。

此外，由于static的方法无法访问泛型类的泛型参数的，所以，如果static方法想拥有泛型能力，就必须使其成为泛型方法了。

还是举个栗子，上文在使用泛型类的时候，是将泛型参数列表放在类后的尖括号内，而使用泛型方法，是将泛型参数列表置于返回值之前（列表嘛，可支持多个），如下：

```angelscript
public class Tested {
    public <T> void startTest(T t) { }
}

```

泛型方法也可以和可变参数一起使用，来看下Arrays 底层的asList方法。

```cs
    public static <T> List<T> asList(T... a) {
        return new ArrayList<>(a);
    }

```

如果没有理解，那在Tested 内，换种方式，是不是懂了：

```php
public class Tested {

    /**
     * 泛型方法与可变参数搭配
     */
    public <T> List<T> asList(T... a) {
        List<T> list = new ArrayList<>();
        for (T t : a)
            list.add(t);
        return list;
    }
}

```

### 擦除与边界

说起泛型，不可避免的会说到擦除和边界，其实也很好理解。在说擦除之前，可以来看下这段代码，输出结果？

```arduino
public class Tested {

    public boolean startTest() {
        Class c1 = new ArrayList<String>().getClass();
        Class c2 = new ArrayList<Integer>().getClass();
        return c1 == c2;
    }
}

```

结果是true，为何？因为JAVA泛型就是使用擦除来实现的。在泛型代码内部，我们无法获得任何有关泛型参数类型的信息，任何具体的类型信息都被擦除了，我们唯一知道的就是在使用一个对象。因此List< String >和List< Integer >在运行时事实上是相同类型，这两种形式都被擦除成它们的“原生”类型，即List。

再看如下代码Tested，由于T没有指明具体类型，所以这样写t.test() 是编译都无法通过的：

```cpp
public class Tested<T> {
    private T t;

    public void set(T t) {
        this.t = t;
    }

    public T get() {
        return t;
    }

    public void sT() {
        t.test(); // err : 无法编译
    }
}

```

现有测试类TestBase：

```angelscript
public class TestBase {
    public void test() { }
}

```

为了调用test 方法，我们必须协助泛型类，给定泛型类的边界，以此告知编译器只能接受遵循这个边界的类型。这里使用extend 关键字来设定边界，来看下代码：

```java
public class Tested<T extends TestBase> {
    private T t;

    public void set(T t) {
        this.t = t;
    }

    public T get() {
        return t;
    }

    public void sT() {
        t.test(); // suc : 编译成功
    }
}

```

边界< T extends TestBase >声明T必须具有TestBase 类型或其子类型，这样就可以调用test 方法了。而泛型的类型参数会被擦除到它的第一个边界，也就是我们的编译器会把类型参数替换为它的擦除边界类，就像上面示例，T被擦除到了TestBase，就好像在类的声明中用TestBase 替换了T 一样。

泛型类型只有在类型检查期间才出现，在此之后，程序中的所有泛型类型都将被擦除，替换成他们的非泛型上界。例如：LIst< T >会被擦除为List，而普通的类型变量 T 会被擦除成Object。因为擦除移除了类型信息，所以，用无界的泛型参数调用的方法只是那些可以用Object调用的方法。

而如果T 不指定类型，T 是没有办法用于显示地引用运行时类型的操作的，所以new T()，obj instance T， (T) obj 这些都是错误的。举个栗子：

```cpp
public class Tested<T> {
    private T t;

    public void set(T t) {
        this.t = t;
        new T(); // 无法编译
    }

    public T get() {
        return t;
    }
}

```

虽然T 会被擦除成了 Object，但我们依然能给这个Object t对象 赋值一个 具体类型的对象E，随后将 t 强转成 E类型，可以参考下面的栗子：

```arduino
    public void startTest() {
        Tested<String> td = new Tested<>();
        td.set("test");
        String obj = td.get();
    }

```

也许你会疑惑，既然Tested 在类型检查后，编译期将泛型 T 都擦除成了Object，为何 String obj = td.get(); 能直接获取到 String 对象，而不是Object 对象呢？其实这是编译器帮我们在Class文件中自动插入了转型的代码，与下面的代码是没有区别的，因为编译后的Class文件是一样的。

```vala
public class Tested {
    private Object t;

    public void set(Object t) {
        this.t = t;
    }

    public Object get() {
        return t;
    }
}

```

```arduino
    public void startTest() {
        Tested td = new Tested();
        td.set("test");
        String obj = (String) td.get();
    }

```

说了这么多，那为何JAVA 要引入擦除呢？主要是一个兼容性问题，怎么保证低版本或未使用泛型的类库能正常被使用的问题。例如A使用了泛型，但是A使用的类库B无泛型，怎么办？这就要在实际的“通信”中，将A的泛型信息擦除，来保证“通信”的类库都是一致的。

### 擦除补偿

擦除丢失了在泛型代码中执行某些操作的能力。如上面说的对于 T 的new，instance，转型操作都是错误的。这就非常难受了，好好的泛型类（接口、方法）如果不能对 T 进行上述的操作，那还有啥用。好在有刚刚提到的 extend 关键字，能给泛型设定一个边界。

这里先不说 extend，除了extend 这些通配符，其实我们还能使用 类型标签 来对于擦除进行补偿。来看段代码：

```arduino
public class Tested<T> {
    private Class<T> tc;

    public void set(Class<T> tc) {
        this.tc = tc;
    }

    public boolean isInstance(Object obj) {
        // 判断obj是否能够转型成T 
        return tc.isInstance(obj);
    }
}

```

如上面类内的Class 就是我们添加的类型标签，当然其他类同理。在这里就可以使用 tc 的 isInstance 方法了。下面是测试类：

```angelscript
public class TestBase { }

```

测试Test1th：

```angelscript
public class Test1th { }

```

测试Test2th：

```scala
public class Test2th extends TestBase { }

```

类比较简单，来测试下：

```java
    public void startTest() {
        Tested<TestBase> td = new Tested<>();
        td.set(TestBase.class);
        boolean td1 = td.isInstance(new Test1th()); // td1 == false
        boolean td2 = td.isInstance(new Test2th()); // td2 == true
    }

```

能够发现，td1 = false， td2 = true，这说明Tested 内的泛型 T 即使被擦除成了 Object，但编译器依然会帮我们确保类型标签可以匹配泛型参数。**这是很重要的属性**。

### 泛型数组

之所以将泛型数组放在后面，是因为泛型数组是擦除的受害者，讲泛型数组就离不开擦除。来看下代码：

```arduino
public class Tested<T> {
    private T[] array;

    @SuppressWarnings("unchecked")
    public Tested(int size) {
        array = (T[]) new Object[size];
    }

    public void set(int index, T item) {
        array[index] = item;
    }

    public T[] get() {
        return array;
    }
}

```

当我们执行代码，会代码转型报错：

```pgsql
    public void startTest() {
        Tested<Integer> td = new Tested<>(4);
        td.set(0, 10);
        try {
            Integer[] array = td.get();
        } catch (Exception e) {
            // java.lang.Object[] cannot be cast to java.lang.Integer[]
        }
    }

```

代码转型报错。为何？还是上文说的擦除问题，即使我们将 Tested 参数类型设置成了Integer，并且在构造中进行了Integer\[\] 转型，但是这个信息呢，只存在于编译期的类型检查阶段，在之后它仍然是一个Object数组，所以我们无法强转。

泛型就是这般，底层规定的数组类型是Object\[\]，那么它就只能是Object\[\]，推翻不了。那么我们就没法得到想要的结果了吗？上面不是说了类型标记了嘛，我们再来看代码：

```arduino
public class Tested<T> {
    private T[] array;

    @SuppressWarnings("unchecked")
    public Tested(Class<T> type, int size) {
        array = (T[]) Array.newInstance(type, size);
    }

    public void set(int index, T item) {
        array[index] = item;
    }

    public T[] get() {
        return array;
    }
}

```

我们再来执行下，与我们的预期相同。

```smali
    public void startTest() {
        Tested<Integer> td = new Tested<>(Integer.class, 4);
        td.set(0, 10);
        Integer[] array = td.get();
        int t = array[0]; // t == 10
    }

```

### 通配符

再看< ? extend MyClass> 之前，先看段简单代码，见下：

```haxe
public class Tested<T> {
    List<TestBase> list1 = new ArrayList<>();
    List<Test1th> list2 = new ArrayList<>();

    public Tested() {
        list1.add(new TestBase());
        list2.add(new Test1th());
    }

    public T get(List<T> t) {
        return t.get(0);
    }

    public List<TestBase> getList1() {
        return list1;
    }

    public List<Test1th> getList2() {
        return list2;
    }
}

```

测试基类TestBase：

```angelscript
public class TestBase { }

```

测试类Test1th：

```scala
public class Test1th extends TestBase { }

```

编写测试代码见下。在这里Tested T为何擦除成Object恢复了？还是因为List< T >类型标签。这里不重复说了。在这里为何不能获取t2，也很好理解，因为我们能从Tested< TestBase > 中读取TestBase，是因为这就是它的确定类型。一个 T 不能代表两个类型，不能即是TestBase 又是 Test1th。关于“一个确定类型”详见下文的番外。

```arduino
    public void startTest() {
        Tested<TestBase> list = new Tested<>();
        TestBase t1 = list.get(list.getList1()); // suc
        TestBase t2 = (Test1th) list.get(list.getList2()); // fail
    }

```

为解决上述问题，< ? extends T> 就出现了，在这里List<? extends T> t 这个List的元素类型的上边界是类型T，List的元素类型还可以是 T 的子类。所以T t = t.get(0)，不会存在安全问题。但是要注意 T 仍然是一个具体的类型，只不过取值可以是 T 或 T 的子类的某个具体类型。

```haxe
public class Tested<T> {
    List<TestBase> list1 = new ArrayList<>();
    List<Test1th> list2 = new ArrayList<>();

    public Tested() {
        list1.add(new TestBase());
        list2.add(new Test1th());
    }

    public T get(List<? extends T> t) {
        return t.get(0);
    }

    public List<TestBase> getList1() {
        return list1;
    }

    public List<Test1th> getList2() {
        return list2;
    }
}

```

< ? super MyClass> 通配符也是同理。其可以声明通配符是由某个特定类的任何基类界定的。直接来看下代码：

```php
public class Tested<T> {
    List<TestBase> list1 = new ArrayList<>();
    List<Test1th> list2 = new ArrayList<>();

    public void set(List<? super T> t, T item) {
        t.add(item);
    }

    public List<TestBase> getList1() {
        return list1;
    }

    public List<Test1th> getList2() {
        return list2;
    }
}

```

在本例中的List<? super T> 规定了，容器List 泛型的下边界是 T 类型，即List 的某种确定类型可以是 T 的基类。所以 t.add(item)，不存在安全问题。

```cpp
    public void startTest() {
        Tested<Test1th> list = new Tested<>();
        list.set(list.getList1(), new Test1th()); // suc
        list.set(list.getList2(), new Test1th()); // suc
    }

```

### 番外

为了理解 T 是具体类型，我们来看段代码：

```arduino
    public void startTest() {
        List<Object> list = new ArrayList<String>(); // error
    }

```

为何会报错？这里需要明确的是，代码的含义是：不能把一个涉及String的泛型赋值给一个涉及Object 的泛型，而这两者都不存在向上转型的关系，所以肯定是错误的。那下面代码呢？

```arduino
    public void startTest() {
        List<? extends Object> list = new ArrayList<String>(); // 编译运行正常 
        list.add("test"); // error
        list.add(new Object());// error
    }

```

list 现在是<? extends Object> ，可以解读成：具有任何从Object继承来的类的列表。但是，这并不意味着list 将能持有任何类型，因为通配符引用的是明确的类型，因此这意味着：某种还未被指定具体类型的引用。至于这个引用具体是什么，鬼才知道，而由于编译器不能了解这里需要Object 的哪个具体类型，所以就不会接受任何类型的Object了，当然你add String or Object 肯定会报错了。

> 好了，本文到这里就结束了，关于泛型的讲解应该完全够用了。

**参考**1、B.E，Java编程思想：机械工业出版社

---

