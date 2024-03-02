---
id: Usk6pIEB62zZ77t7Rkdv
---

# Lifecycle，看完这次就真的懂了
#Omnivore

[Read on Omnivore](https://omnivore.app/me/lifecycle-181a43a45ba)
[Read Original](https://mp.weixin.qq.com/s?__biz=MzA5MzI3NjE2MA%3D%3D&amp%3Bchksm=88632285bf14ab93ba6cdf06bf7a7dfbdf8e6b33b31993b47dc626c2c75ba8141625cee8ddda&amp%3Bidx=1&amp%3Bmid=2650264554&amp%3Bmpshare=1&amp%3Bscene=1&amp%3Bsharer_shareid=a1c1a089a599c63559b93d9e0110f8ff&amp%3Bsharer_sharetime=1655258065191&amp%3Bsn=f082344ffc922503b60b534a564ac0f0&amp%3Bsrcid=0615D1VpNFtwwNWmKxm7Gegr)

 g小志  郭霖 _发表于江苏_ 

![图片](https://proxy-prod.omnivore-image-cache.app/0x0,sExgtTwr-wkaVoqgd6O7cJxkortO-m3zlTePnsQfTWdQ/https://mmbiz.qpic.cn/mmbiz_jpg/v1LbPPWiaSt5u4qlRDV7JCPTlhLruwgCE7IwG1NBPXaJxfvDKvhCWSDe0PMuVbEb1pavYAiaAjbELXcNC1UPzbJw/640?wx_fmt=jpeg&wxfrom=5&wx_lazy=1&wx_co=1)  

/ 今日科技快讯 /

近日，谷歌已经就一项集体诉讼与1.55万名女性员工达成和解协议，并同意支付1.18亿美元补偿。此前，谷歌被控歧视女性员工，向她们支付的薪酬低于从事相同工作的男性员工。按照和解协议，原告将撤回对谷歌的指控，即“在基本类似的工作中，谷歌为女性提供的薪酬低于男性，谷歌为女性分配的职位低于男性，谷歌未能在员工离职时支付所有应支付的工资”。

/ 作者简介 /

本篇文章来自g小志的投稿，文章主要分享了他对Lifecycle的探索分析，相信会对大家有所帮助！同时也感谢作者贡献的精彩文章。

g小志的博客地址：

> https://www.jianshu.com/u/70a8f4edb323

/ 前言 /

Lifecycle生命周期感知型组件，用来执行、操作、响应另一个组件（如 Activity 和 Fragment）的生命周期状态的变化。

本文Lifecycle版本为2.2.0：

**implementation 'androidx.lifecycler:lifecycle-common:2.2.0' //22.2.23 更新 2.5 ，2.2是用的比较多的版本**

/ 你真的了解Lifecycle了吗？ /

Lifecycle使用非常非常简单。默认你已经使用过Lifecycle。但如果我问你以下几个问题。你能回答出来几个？

* Lifecycle的创建方式有几种？
* 有什么不同？推荐使用哪种？为什么？
* Event事件和State状态是什么关系
* nStop()生命周期，处于什么State状态
* Lifecycle是如何进行生命周期同步
* 如果在onResume() 注册观察者会收到那几个种回调？为什么？
* Activity/Fragment 实现Lifecycle能力的方式一样吗？
* 为什么要这么设计？有什么好处？
* Application能感知Activity生命周期吗?（如何使用Lifecycle监听前后台的能力）
* Lifecycle从源码角度，简述Lifecycle的注册，派发，感知的过程
* 什么嵌套事件？发生的时机？Lifecycle是如何解决的？

如果我是面试官，遇到简历上写掌握Jetpack组件，我一定是会问Lifecycle这几个问题。因为它首先是Jetpack另外两个超级核心组件ViewModel,LiveData，实现能力的基石。同时它的使用频率也非常高，看似简单，容易被忽略，但却很多东西值得学习。

这十几个问题，从用法到源码，从表面到延伸。如果全懂，说明你真正掌握了Lifecycle的80%，没错\~！仅仅是8成。因为下面的源码分析，还会有更多延伸的问题。

/ Lifecycle基本使用 /

作为生命周期感知组件、它的作用就是监听宿主Activity/Fragment，然后派发给观察者。这句看似简单的概括，却倒出3个重要的角色：

**宿主，观察者，用来派发的调度器**

使用Lifecycle的方法很简单。

先创建Observer，可以直接继承父类LifecycleObserver。

public class LocationObserver implements LifecycleObserver {  
    private static final String TAG = "LocationObserver";  
    //1. 自定义的LifecycleObserver观察者，用注解声明每个方法观察的宿主的状态  
    @OnLifecycleEvent(Lifecycle.Event.ON_CREATE)  
    void onCreate(@NotNull LifecycleOwner owner) {  
        Timber.e("onCreate_ON_CREATE");  
    }  
    @OnLifecycleEvent(Lifecycle.Event.ON_START)  
    void onStart(@NotNull LifecycleOwner owner) {  
        Timber.e("onStart_ON_START");  
    }  
    @OnLifecycleEvent(Lifecycle.Event.ON_RESUME)  
    void onResume(@NotNull LifecycleOwner owner) {  
        Timber.e("onResume_ON_RESUME");  
    }  
    @OnLifecycleEvent(Lifecycle.Event.ON_PAUSE)  
    void onPause(@NotNull LifecycleOwner owner) {  
        Timber.e("onPause_ON_PAUSE");  
    }  
    @OnLifecycleEvent(Lifecycle.Event.ON_STOP)  
    void onStop(@NotNull LifecycleOwner owner) {  
        Timber.e("onStop_ON_STOP");  
    }  
    @OnLifecycleEvent(Lifecycle.Event.ON_DESTROY)  
    void onDestroy(@NotNull LifecycleOwner owner) {  
        Timber.e("onDestroy_ON_DESTROY");  
    }  
    @OnLifecycleEvent(Lifecycle.Event.ON_ANY)  
    void onAny(LifecycleOwner owner) {  
        Timber.e("onAny_ON_ANY-->%s", owner.getLifecycle().getCurrentState());  
    }  
}

自己定义生命周期方法，并在每个方法上面标记对应生命周期的注解。同时还能获得LifecycleOwner也就是宿主Activity。

继承LifecycleEventObserver，复写onStateChanged方法。

public class EventObserver implements LifecycleEventObserver {

    @Override  
    public void onStateChanged(@NonNull LifecycleOwner source, @NonNull Lifecycle.Event event) {  
        switch (event) {  
            case ON_CREATE:  
                Timber.d("ON_CREATE");  
                break;  
            case ON_START:  
                Timber.d("ON_START");  
                break;  
            case ON_RESUME:  
                Timber.d("ON_RESUME");  
                break;  
            case ON_PAUSE:  
                Timber.d("ON_PAUSE");  
                break;  
            case ON_STOP:  
                Timber.d("ON_STOP");  
                break;  
            case ON_DESTROY:  
                Timber.d("ON_DESTROY");  
                break;  
            default:  
                break;  
        }  
    }  
}

继承FullLifecycleObserver，直接复写对应的生命周期回调。

public class FullLocationObserver implements DefaultLifecycleObserver {  
    @Override  
    public void onCreate(@NonNull LifecycleOwner owner) {  
        Timber.e("onCreate");  
    }  
    @Override  
    public void onStart(@NonNull LifecycleOwner owner) {  
        Timber.e("onStart");  
    }  
    @Override  
    public void onResume(@NonNull LifecycleOwner owner) {  
        Timber.e("onResume");  
    }  
    @Override  
    public void onPause(@NonNull LifecycleOwner owner) {  
        Timber.e("onPause");  
    }  
    @Override  
    public void onStop(@NonNull LifecycleOwner owner) {  
        Timber.e("onStop");  
    }  
    @Override  
    public void onDestroy(@NonNull LifecycleOwner owner) {  
        Timber.e("onDestroy");  
    }  
}

此时你会发现，你无法直接继承FullLifecycleObserver这时你要添加一个依赖：

**implementation 'androidx.lifecycler:lifecycle-common:2.2.0'**

**替换上面引入的依赖(默认会集成上面的)**

**implementation "androidx.lifecycle:lifecycle-common-java8:2.2.0"**

继承DefaultLifecycleObserver，它是FullLifecycleObserver的子类，因为在Java8以后，支持interface接口类型，可以有自己的默认实现。然后在Activity#OnCreate()中调用如下方法：

     lifecycle.addObserver(LocationObserver())

接着，你就可以使用Lifecycle的能力了。

/ 从源码了解过程 /

如果是MVP，你可以让你的Presenter去实现Observer，在处理逻辑时获得感知的能力。但如果我们把注册的代码lifecycle.addObserver(LocationObserver())放入onResume()方法中，会发生什么？你会发现Observer除了可以收到onResume事件，竟然还可以收到onCreate，onStart。也就说宿主的状态，会同步给观察者。这是怎么做到的？

**感知监听**

getLifecycle点进去，会进入到ComponentActivity核心代码。

public class ComponentActivity extends Activity implements LifecycleOwner{  
  private LifecycleRegistry mLifecycleRegistry = new LifecycleRegistry(this);  
   @NonNull  
   @Override  
   public Lifecycle getLifecycle() {  
      return mLifecycleRegistry;  
   }

  protected void onCreate(Bundle bundle) {  
      super.onCreate(savedInstanceState);  
      //往Activity上添加一个fragment,用以报告生命周期的变化  
      //目的是为了兼顾不是继承自AppCompactActivity的场景.  
      ReportFragment.injectIfNeededIn(this);   
}

1. LifecycleRegistry是Lifecycle的子类，通过new LifecycleRegistry(this)把宿主Owner，也就是当前Activity作为构造参数传递进去
2. Activity并不是直接派发生命周期，而是利用ReportFragment.injectIfNeededIn(this)，

public class ReportFragment extends Fragment{  
  public static void injectIfNeededIn(Activity activity) {  
        android.app.FragmentManager manager = activity.getFragmentManager();  
        if (manager.findFragmentByTag(REPORT_FRAGMENT_TAG) == null) {  
            manager.beginTransaction().add(new ReportFragment(), REPORT_FRAGMENT_TAG).commit();  
            manager.executePendingTransactions();  
        }  
  }

    @Override  
    public void onStart() {  
        super.onStart();  
        dispatch(Lifecycle.Event.ON_START);  
    }  
    @Override  
    public void onResume() {  
        super.onResume();  
        dispatch(Lifecycle.Event.ON_RESUME);  
    }  
    @Override  
    public void onPause() {  
        super.onPause();  
        dispatch(Lifecycle.Event.ON_PAUSE);  
    }  
    @Override  
    public void onDestroy() {  
        super.onDestroy();  
        dispatch(Lifecycle.Event.ON_DESTROY);  
    }  
    private void dispatch(Lifecycle.Event event) {  
         //调用宿主的Lifecycle   
         Lifecycle lifecycle = activity.getLifecycle();  
         if (lifecycle instanceof LifecycleRegistry) {  
             ((LifecycleRegistry) lifecycle).handleLifecycleEvent(event);  
         }  
}

ReportFragment.injectIfNeededIn(this)的作用是在Activity之上，创建一个不可见的Fragment的。当Fragment的生命周期发生变化，会通过dispatch()，接着调用((LifecycleRegistry) lifecycle).handleLifecycleEvent(event)来分发事件。这样做的目的是为了当页面不是继承ComponentActivity，而是直接继承Activity，那么它就没有了感知的能力。此时需要自己实现LifecycleOwner，复写getLifecycle(),然后将自己传入进new LifecycleRegistry(this)，就可以成为宿主，让其他Observer来监听。ReportFragment.injectIfNeededIn(this)另一个使用的地方LifecycleDispatcher。

class LifecycleDispatcher {

    private static AtomicBoolean sInitialized = new AtomicBoolean(false);

    static void init(Context context) {  
        if (sInitialized.getAndSet(true)) {  
            return;  
        }  
        ((Application) context.getApplicationContext())  
                .registerActivityLifecycleCallbacks(new DispatcherActivityCallback());  
    }

    @SuppressWarnings("WeakerAccess")  
    @VisibleForTesting  
    static class DispatcherActivityCallback extends EmptyActivityLifecycleCallbacks {

        @Override  
        public void onActivityCreated(Activity activity, Bundle savedInstanceState) {  
            ReportFragment.injectIfNeededIn(activity);  
        }

        @Override  
        public void onActivityStopped(Activity activity) {  
        }

        @Override  
        public void onActivitySaveInstanceState(Activity activity, Bundle outState) {  
        }  
    }

    private LifecycleDispatcher() {

直接为Activity注入ReportFragment，使得每个页面都能成为宿主，让观察者感知。当然，你里面要自己实现LifecycleOwner，复写getLifecycle()，然后将自己传入进new LifecycleRegistry(this)。==这部分与Lifecycle关系不大，只是作为知识扩展==

**总结**

1. 监听过程就是Activity/Fragment继承LifecycleOwner，并在子类CommponentActivity中创建Lifecycle的子类LifecycleRegistry。在复写getLifecycle()的方法中将子类LifecycleRegistry返回。
2. 在onCreate()中注入ReportFragment，在生命周期回调后，通过getLifecycle()的方法得到LifecycleRegistry对象中的handleLifecycleEvent(event)方法给每个观察者派发生命周期事件。

为什么以Activity为例子，而不是像其他文章，以Fragement为例子，是因为你去看眼源码就会发现ReportFragment类中的dispatch()过程和Fragement如出一辙：

public class Fragment implements xxx, LifecycleOwner {  
    //...  
    void performCreate(Bundle savedInstanceState) {  
        onCreate(savedInstanceState);  //1.先执行生命周期方法  
        //...省略代码  
        //2.生命周期事件分发  
        mLifecycleRegistry.handleLifecycleEvent(Lifecycle.Event.ON_CREATE);  
    }

    void performStart() {  
        onStart();  
        //...  
        mLifecycleRegistry.handleLifecycleEvent(Lifecycle.Event.ON_START);  
    }

    void performResume() {  
         onResume();  
        //...  
        mLifecycleRegistry.handleLifecycleEvent(Lifecycle.Event.ON_RESUME);  
    }

    void performPause() {  
        //3.注意，调用顺序变了  
        mLifecycleRegistry.handleLifecycleEvent(Lifecycle.Event.ON_PAUSE);  
        //...  
        onPause();  
    }

    void performStop() {  
       mLifecycleRegistry.handleLifecycleEvent(Lifecycle.Event.ON_STOP);  
        //...  
        onStop();  
    }

    void performDestroy() {  
        mLifecycleRegistry.handleLifecycleEvent(Lifecycle.Event.ON_DESTROY);  
        //...  
        onDestroy();  
    }  
}

参照《Android 架构组件（一）——Lifecycle》一文：

> https://blog.csdn.net/zhuzp\_blog/article/details/78871374?spm=1001.2014.3001.5501

文中的时序图：

同时，你会发现Fragment中performCreate()、performStart()、performResume()会先调用自身的onXXX()方法，然后再调用LifecycleRegistry的handleLifecycleEvent()方法；而在performPause()、performStop()、performDestroy()中会先LifecycleRegistry的handleLifecycleEvent()方法，然后调用自身的onXXX()方法。

**同步**

上面是监听过程，getLifecycle().addObserver(LocationObserver())注册代码的前半部分。现在我们获得感知宿主的能力，并将事件event转发给LifecycleRegistry，他是整个流程的核心。现在来看后半部分，如何注册Observer后可以在任何时机(onDestory除外)，感知完整生命周期。

不过在此之前，我们要先搞懂什么是状态State和事件Event。

public abstract class Lifecycle {  
    @MainThread  
    public abstract void addObserver(@NonNull LifecycleObserver observer);  
     @MainThread  
    public abstract void removeObserver(@NonNull LifecycleObserver observer);  
    @MainThread  
    @NonNull  
    public abstract State getCurrentState();   

public enum Event {  
        ON_CREATE,  
        ON_START,  
        ON_RESUME,  
        ON_PAUSE,  
        ON_STOP,  
        ON_DESTROY,  
        ON_ANY  
    }  
public enum State {  
        DESTROYED,  
        INITIALIZED,  
        CREATED,  
        /**  
         *     <li>after {@link android.app.Activity#onStart() onStart} call;  
         *     <li><b>right before</b> {@link android.app..Activity#onPause( onPause} call.  
         * </ul>  
         */  
        STARTED,  
        RESUMED;  
        public boolean isAtLeast(@NonNull State state) {  
            return compareTo(state) >= 0;  
        }  
    }  
}

在Lifecycle类中除了add，remove外，还有两个枚举类，Event事件对应的就是Activty的onCreate,onStart()事件，而状态却只有5种。以STARTED状态为例，这个状态发生在Activity#onStart()之后，Activity#onPause()之前。什么意思呢？请看下面这张图：

这张图我们一定见过，但这次我们横着对半切一刀，上面表示生命周期的前进，下面表示生命周期的后退，一定要记住，这对我们后的理解源码非常重要，接着我们在解释下：

**Activity刚刚创建的时候它一定是INITIALIZED状态，执行onCreate()方法后，进入到CREATED状态，执行onStart()方法后，进入到STARTED状态，执行onResume()方法后，进入到RESUMED状态，这个过程就表示生命周期的前进。**

**当我们跳转下一个Activity后，执行onPase()方法后，又重新回到STARTED状态，执行onStop()方法后，进入到CREATED状态，最后执行onDestory()方法后，进入到DESTROYED状态。这个过程表示生命周期的后退。**

参照《Android 架构组件（一）——Lifecycle》一文：

> https://blog.csdn.net/zhuzp\_blog/article/details/78871374?spm=1001.2014.3001.5501

文中的关系图：

这个图片仅作参考，ObserverWithState类中的关系有所变换，mLifeCycleObserver->LifeCycleEventObserver。

LifecycleRegistryshi生命周期注册，记录，派发事件的地方，理解状态和事件的关系，对我们搞清楚LifecycleRegistry非常有帮助，下面以在onResume()中调用lifecycle.addObserver(LocationObserver())为例：

    public LifecycleRegistry(@NonNull LifecycleOwner provider) {  
        mLifecycleOwner = new WeakReference<>(provider);  
        mState = INITIALIZED;  
    }

    public void addObserver(@NonNull LifecycleObserver observer) {  
        //1  
        State initialState = mState == DESTROYED ? DESTROYED : INITIALIZED;  
        //2  
        ObserverWithState statefulObserver = new ObserverWithState(observer, initialState);  
        //3  
        ObserverWithState previous = mObserverMap.putIfAbsent(observer, statefulObserver);

        if (previous != null) {  
            return;  
        }  
        LifecycleOwner lifecycleOwner = mLifecycleOwner.get();  
        if (lifecycleOwner == null) {  
            // it is null we should be destroyed. Fallback quickly  
            return;  
        }

        boolean isReentrance = mAddingObserverCounter != 0 || mHandlingEvent;  
        //4  
        State targetState = calculateTargetState(observer);  
        mAddingObserverCounter++;  
        while ((statefulObserver.mState.compareTo(targetState) < 0  
                && mObserverMap.contains(observer))) {  
            pushParentState(statefulObserver.mState);  
            //5  
            statefulObserver.dispatchEvent(lifecycleOwner, upEvent(statefulObserver.mState));  
            popParentState();  
            // mState / subling may have been changed recalculate  
            targetState = calculateTargetState(observer);  
        }

        if (!isReentrance) {  
            // we do sync only on the top level.  
            sync();  
        }  
        mAddingObserverCounter--;  
    }  
    //并不是继承自`Observer`  
    static class ObserverWithState {  
        State mState;  
        LifecycleEventObserver mLifecycleObserver;

        ObserverWithState(LifecycleObserver observer, State initialState) {  
            mLifecycleObserver = Lifecycling.lifecycleEventObserver(observer);  
            mState = initialState;  
        }

        void dispatchEvent(LifecycleOwner owner, Event event) {  
            State newState = getStateAfter(event);  
            mState = min(mState, newState);  
            mLifecycleObserver.onStateChanged(owner, event);  
            mState = newState;  
        }  
    }  
    private State calculateTargetState(LifecycleObserver observer) {  
        Entry<LifecycleObserver, ObserverWithState> previous = mObserverMap.ceil(observer);

        State siblingState = previous != null ? previous.getValue().mState : null;  
        State parentState = !mParentStates.isEmpty() ? mParentStates.get(mParentStates.size() - 1)  
                : null;  
        return min(min(mState, siblingState), parentState);  
    }

    private static Event upEvent(State state) {  
        switch (state) {  
            case INITIALIZED:  
            case DESTROYED:  
                return ON_CREATE;  
            case CREATED:  
                return ON_START;  
            case STARTED:  
                return ON_RESUME;  
                //发生生命周期的前进，RESUMED处于前进阶段的末尾，无法前进了。因为之后要发生生命周期后退  
                //所以抛出异常  
            case RESUMED:  
                throw new IllegalArgumentException();  
        }  
        throw new IllegalArgumentException("Unexpected state value " + state);  
    }  
    //根据事件，判断所处的状态  
    static State getStateAfter(Event event) {  
        switch (event) {  
            case ON_CREATE:  
            case ON_STOP:  
                return CREATED;  
            case ON_START:  
            case ON_PAUSE:  
                return STARTED;  
            case ON_RESUME:  
                return RESUMED;  
            case ON_DESTROY:  
                return DESTROYED;  
            case ON_ANY:  
                break;  
        }  
        throw new IllegalArgumentException("Unexpected event value " + event);  
    }

1. mState表示宿主的状态或是Observer应该处于正确的状态，如果不是DESTROYED，那么就赋值为INITIALIZED状态，什么意思？就是当你添加一个Observer的时机是在onDestory()那么直接设置为DESTROYED，之后便不会给这个观察者派发事件，否则即便你是在onReume()注册，都是INITIALIZED，为什么要这样做，而不是直接派发RESUMED。这就是LifecycleRegistry的高明之处，因为他下面要做事件同步。如果直接派发RESUMED，观察者且不是丢失了ON\_CREATE，ON\_START事件？这与Lifecycycle设计的初衷肯定是不相符的
2. 将observer和initialState，封装进ObserverWithState，从类名可以看出，他是持有观察者和它当前状态的包装类
3. 观察者Observer为key，ObserverWithState为Value封装进Map，mObserverMap这个存储集合它的作用没啥可说的，但它的数据结构很特别，可以理解为是一个链表结构的Map，记录了链头Start和链未End，同时每个Value元素，还记录了当前值的Next和Previous。
4. calculateTargetState翻译为计算目标状态，也就是计算传入的Observer应该是什么状态。而它里面计算的逻辑很有意思。展开说涉及到嵌套事件下面再讲，简单来说就是根据集合中的前一个Observer状态和宿主的状态与当前Observer应该处于正确的状态mState作min()比较。从这里我们可以得出一个Activity/Fragment可以有多个观察者，每个观察者的状态全部一致
5. 循环判断，如果观察者状态小于目标状态，表示发生生命周期的前进。调用upEvent(State state)计算前进事件。初始化是INITIALIZED状态，发生前进事件，根据前面的图，应该发生ON\_CREATE事件。这有点不好理解。就是小于的情况下。肯定发生生命周期的前进，所以INITIALIZED状态下，下一个事件必然是ON\_CREATE事件。然后调用ObserverWithState#dispatchEvent()，通过 getStateAfter(event)来根据事件，判断所处的状态。ON\_CREATE事件一定是CREATED状态。接着保存起来newState，调用注册进来的观察者的回调方法mLifecycleObserver.onStateChanged(owner, event)把事件分发出去，然后更新mStatemState = newState
6. 下次循环mState=CREATED还是小于目标状态，upEvent():CREATED-->ON\_START，getStateAfter(event)：ON\_START-->STARTED，保存状态newState，回调监听onStateChanged，保存状态mState = newState，直到mState = RESUMED

经过循环之后。新注册的Observer和宿主同步到相同的生命周期。

**派发**

当宿主生命周期发生变化，会调用mLifecycleRegistry.handleLifecycleEvent(Lifecycle.Event.ON\_RESUME)来向观察者派发，直接看分析然后再结合源码。

    public void handleLifecycleEvent(@NonNull Lifecycle.Event event) {  
        State next = getStateAfter(event);  
        moveToState(next);//1  
    }

    private void moveToState(State next) {  
        mState = next;  
        sync();//2  
    }

    private void sync() {  
        while (!isSynced()) {//3  
        //当宿主状态小于 最早添加进来的观察者，为什么是最早，首先集合中的观察者是按顺序添加的，State应该是一致的，小于最早观察者，一定小于后面最后观察者  
            if (mState.compareTo(mObserverMap.eldest().getValue().mState) < 0) {  
                backwardPass(lifecycleOwner);//4  
            }  
            Entry<LifecycleObserver, ObserverWithState> newest = mObserverMap.newest();  
            if (!mNewEventOccurred && newest != null  
                    //当宿主状态大于最新的道理相同  
                    && mState.compareTo(newest.getValue().mState) > 0) {  
                forwardPass(lifecycleOwner);//5  
            }  
        }  
    }

    private boolean isSynced() {  
        if (mObserverMap.size() == 0) {  
            return true;  
        }  
        State eldestObserverState = mObserverMap.eldest().getValue().mState;  
        State newestObserverState = mObserverMap.newest().getValue().mState;  
        return eldestObserverState == newestObserverState && mState == newestObserverState;  
    }

    private void backwardPass(LifecycleOwner lifecycleOwner) {  
            while ((observer.mState.compareTo(mState) > 0 && !mNewEventOccurred  
                    && mObserverMap.contains(entry.getKey()))) {  
                Event event = downEvent(observer.mState);  
                observer.dispatchEvent(lifecycleOwner, event);  
            }  
    }

    private void forwardPass(LifecycleOwner lifecycleOwner) {  
            while ((observer.mState.compareTo(mState) < 0 && !mNewEventOccurred  
                    && mObserverMap.contains(entry.getKey()))) {  
                observer.dispatchEvent(lifecycleOwner, upEvent(observer.mState));  
            }  
    }         
    private static Event downEvent(State state) {  
        switch (state) {  
        //最初的状态 无法再后退  
            case INITIALIZED:  
                throw new IllegalArgumentException();  
            case CREATED:  
                return ON_DESTROY;  
            case STARTED:  
                return ON_STOP;  
            case RESUMED:  
                return ON_PAUSE;  
                //最末的状态 无法再回退  
            case DESTROYED:  
                throw new IllegalArgumentException();  
        }  
        throw new IllegalArgumentException("Unexpected state value " + state);  
    }

1. 根据传入的事件event，判断宿主的状态
2. 进行复制mState = next，然后调用sync()开始同步所有观察者
3. isSynced()是否已经同步过了，取出Map中首尾元素，两者相等同时尾部元素，也就是最后添加，最新的元素和宿主状态mState相同，就说明同步过了不用同步。再次印证一个Activity/Fragment可以有多个观察者，每个观察者的状态全部一致，但注意sync()中是取的非while (!isSynced())所以不一致时进入接下来的循环
4. if (mState.compareTo(mObserverMap.eldest().getValue().mState) < 0) ，宿主状态小于观察者的状态，这是什么情况？如果你看懂前面的表，这里就不难理解，举个例子:观察者为RESUMED状态，此时宿主发生onPase()生命周期，那么宿主会进入STARTED状态。进入生命周期后退过程所以会调用backwardPass(lifecycleOwner)向后传递
5. (observer.mState.compareTo(mState) > 0 上面判断是宿主小于观察者，backwardPass判断观察者大于宿主，完全是一个意思，接着会调用downEvent，根据状态回退RESUMED-->ON\_PAUSE
6. observer.dispatchEvent(lifecycleOwner, event)更新状态，分发观察者事件，更新mState
7. mState.compareTo(newest.getValue().mState) > 0 事件前进forwardPass(lifecycleOwner)与之前同步过程完全相同

**统一Observer**

**思考一个问题**

  
ObserverWithState#dispatch是给观察者分发事件的位置，但他调用的是onStateChange()，但我们回调方式的实现，是完全不同的，他是如何做到统一的呢？

    static class ObserverWithState {  
        State mState;  
        LifecycleEventObserver mLifecycleObserver;

        ObserverWithState(LifecycleObserver observer, State initialState) {  
            mLifecycleObserver = Lifecycling.lifecycleEventObserver(observer);  
            mState = initialState;  
        }

        void dispatchEvent(LifecycleOwner owner, Event event) {  
            State newState = getStateAfter(event);  
            mState = min(mState, newState);  
            mLifecycleObserver.onStateChanged(owner, event);  
            mState = newState;  
        }  
    }

mLifecycleObserver = Lifecycling.lifecycleEventObserver(observer)答案就是适配器模式，看就在这里。

    @NonNull  
    static LifecycleEventObserver lifecycleEventObserver(Object object) {//Object 就是传入的observer  
        boolean isLifecycleEventObserver = object instanceof LifecycleEventObserver;  
        boolean isFullLifecycleObserver = object instanceof FullLifecycleObserver;  
        if (isLifecycleEventObserver && isFullLifecycleObserver) {  
            return new FullLifecycleObserverAdapter((FullLifecycleObserver) object,  
                    (LifecycleEventObserver) object);  
        }  
        if (isFullLifecycleObserver) {  
            return new FullLifecycleObserverAdapter((FullLifecycleObserver) object, null);  
        }

        if (isLifecycleEventObserver) {  
            return (LifecycleEventObserver) object;  
        }

        final Class<?> klass = object.getClass();  
        //关键代码  
        int type = getObserverConstructorType(klass);  
        if (type == GENERATED_CALLBACK) {  
            List<Constructor<? extends GeneratedAdapter>> constructors =  
                    sClassToAdapters.get(klass);  
            if (constructors.size() == 1) {  
                GeneratedAdapter generatedAdapter = createGeneratedAdapter(  
                        constructors.get(0), object);  
                return new SingleGeneratedAdapterObserver(generatedAdapter);  
            }  
            GeneratedAdapter[] adapters = new GeneratedAdapter[constructors.size()];  
            for (int i = 0; i < constructors.size(); i++) {  
                adapters[i] = createGeneratedAdapter(constructors.get(i), object);  
            }  
            return new CompositeGeneratedAdaptersObserver(adapters);  
        }  
        return new ReflectiveGenericLifecycleObserver(object);  
    }

* Object 就是传入的observer，如果是如果同时实现LifecycleEventObserver，FullLifecycleObserver，创建FullLifecycleObserverAdapter
* 如果是isFullLifecycleObserver，创建FullLifecycleObserverAdapter
* 如果是isLifecycleEventObserver，直接返回

而FullLifecycleObserverAdapter ，所有适配器Adapter都是继承自LifecycleEventObserver。这样就可以收拢统一后调用。而直接继承LifecycleObserver又是怎么判断的呢？

int type = getObserverConstructorType(klass);  

最终调用    
 /**  
     * Create a name for an adapter class.  
     */  
    public static String getAdapterName(String className) {  
        return className.replace(".", "_") + "_LifecycleAdapter";  
    }

当引入androidx.lifecycle:lifecycle-compiler:2.2.0会利用APT，运行时注解处理器生成工具类并拼接类名MyObserver\_LifecycleAdapter，然后调取注解标记的观察者，否者会用ReflectiveGenericLifecycleObserver，反射执行。

**嵌套事件**

这部分不好理解，目前个人的理解就是，先弄清楚什么时候回出现嵌套事件，两种情况：

1. 在新添加观察者时，同步还未完成，此时宿主又发生了生命周期变化，那么此时就会导致不同步的问题
2. 在派发生命周期给观察者时，又有新的观察者添加进来，那么新的观察者可能和其他观察者状态不同步的问题。

嵌套事件，说白了就是同步冲突。因为所有观察者和宿主的状态是完全相同的，一旦生命周期派发，或是新的观察者添加进来时，如果生命周期或观察者集合元素发生变化，就可能会导致不同步。这错乱不是来自多线程。因为细心的你会发现。LifeCycleRegistry的大部分方法都标注@MainThread注解。也就说，冲突并非是多线程，而是上面两种情况。

那么LifeCycleRegistry又是如何如何处理的呢？答案是利用多个标记位表示状态，同时将新添加的观察者，或是正在变化的观察者压入栈。正确同步后后再出栈,也就是mParentStates这个mParentStates类型的集合。所以一旦出现观察者状态不一致导致无法正常出栈。这个栈mParentStates内的元素就不是空。就需要来重新处理或者判断。核心思想大概是这样样子。就是多个标记位和栈管理，来确保状态的同步和一致。

以上是个人理解。对嵌套事件感兴趣，想深入理解，可以看这篇：

> https://blog.csdn.net/quiet\_olivier/article/details/103384146?spm=1001.2014.3001.5502

/ 总结 /

LifeCycle组件简单，深入却有很复杂，理解后又会发现很有意思。但大部分文章却无法做到既深入，又能体现却他人的不同。更无法完全解答开头的十几个问题。不过现在你应该有了自己的答案。

推荐阅读：

[我的新书，《第一行代码 第3版》已出版！](http://mp.weixin.qq.com/s?%5F%5Fbiz=MzA5MzI3NjE2MA==&mid=2650248955&idx=1&sn=0c5237154c4c8de2ca635f8a578aa701&chksm=88636794bf14ee823e8c11854b5c014e49a4af425c2947e7c62f3ce139062b5560b4c44e3d4f&scene=21#wechat%5Fredirect)  

[在微软工作365天，还你一个我眼中更加真实的微软](http://mp.weixin.qq.com/s?%5F%5Fbiz=MzA5MzI3NjE2MA==&mid=2650260888&idx=1&sn=b8d7eec07979fa1be2fff78f579a78a4&chksm=886334f7bf14bde139ea477e691fbc813f3eebd3967bf4e990a3e629d3bee2041663c0633a75&scene=21#wechat%5Fredirect)  

[一个Android沉浸式状态栏上的黑科技](http://mp.weixin.qq.com/s?%5F%5Fbiz=MzA5MzI3NjE2MA==&mid=2650264498&idx=1&sn=ec61e9f4be0fb77727398a54438809b2&chksm=886322ddbf14abcb685734b79af42245a898e5cc8c1052ade64546bc1dc550c3250a43794e3c&scene=21#wechat%5Fredirect)  

欢迎关注我的公众号

学习技术或投稿

![图片](https://proxy-prod.omnivore-image-cache.app/0x0,s4oUv0EiXcT20OmoYqZS2HEIbakAy7Mit2JoS19pTfQw/https://mmbiz.qpic.cn/mmbiz/wyice8kFQhf4Mm0CFWFnXy6KtFpy8UlvN0DOM3fqc64fjEj9tw23yYSqujQjSQoU1rC0vicL9Mf0X6EMR4gFluJw/640.png?wx_fmt=png)

长按上图，识别图中二维码即可关注

