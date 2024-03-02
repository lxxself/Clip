---
id: c45f9912-da06-473b-8a88-de1afb50dbd2
---

# 稳定的 Glance 来了，安卓小部件有救了！ - 掘金
#Omnivore

[Read on Omnivore](https://omnivore.app/me/glance-18a8758c746)
[Read Original](https://juejin.cn/post/7277218424690131005)

稳定版本的 `Glance` 终于发布了，来一起看看吧，看看这一路的旅程，看看好用么，再看看如何使用！

### 前世今生

故事发生在两年的一天吧，其实夸张了，不到两年，而是 633 天前。。。

![image.png](https://proxy-prod.omnivore-image-cache.app/0x0,sz883Wj5sySvZjtqMo3h-QIdiXAg94IDyOj7JCrg3SIY/https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/cec6b1a4f0124725afac309e987a05b3~tplv-k3u1fbpfcp-jj-mark:3024:0:0:0:q75.awebp#?w=870&h=1772&s=93734&e=webp&b=fefefe)

在 `Jetpack` 的更新网站上发现多了一个名叫 `Glance` 的库，版本为 `1.1.0-alpha01`，发现这个库后就赶快点击进去看看是干啥用的：

![image.png](https://proxy-prod.omnivore-image-cache.app/0x0,sXGEiCYFt20QT7YMRE3F3WL23U0kIYWmVOkiMrbKZESA/https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/861665027df148a282cdcd4e6fe8b2cf~tplv-k3u1fbpfcp-jj-mark:3024:0:0:0:q75.awebp#?w=1472&h=628&s=21296&e=webp&b=fefefe)

看到这个库的简介的时候给我高兴坏了，大致意思是：可以使用 `Compose` 风格的 API 来为小部件构建布局。然后就尝试了下并写了一篇文章：[Jetpack Glance？小部件的春天来了](https://juejin.cn/post/7042468014251311112 "https://juejin.cn/post/7042468014251311112")

小部件这个东西虽然是安卓中首先发布的，但是这么多年来一直平平无奇，直到苹果 IOS 中也“推出”了小部件之后，才唤起了小部件的第二春，然后安卓官方、也就是谷歌才想起来自己原来也有这么个东西，就在 Android 12 中才对小部件做了一些改进，不容易啊，这么多年来第一次给安卓小部件增加了一些内容。。。

之后接着官方也看不下去了，看不下去什么呢？多年前的安卓开发使用起小部件没有问题，但是现在的安卓开发变为了 `Compose` ，而小部件还是只能使用 `XML` ，于是乎，`Glance` 应运而生！

短短几行字，基本聊了下 `Glance` 的前世今生，一个库，要 635 天才能从 alpha 版本变为 stable，如果再加上第一个 alpha 版本的开发时间的话，肯定超过了两年。。。这个速度如果放到国内的话。。。。算了，大家理解就好。其实也不能怪他们，`Jetpack` 中的库实在是太多了，都需要时间和人力维护嘛！

下面再来看一下 `Glance` 的发布时间线吧：

![image.png](https://proxy-prod.omnivore-image-cache.app/0x0,sz3gn7Fgey1Yit4hmP7roUMQICnqIAppqC0DVQRVgRI4/https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/503ac807b8db47d5a3a88d43b9b838cf~tplv-k3u1fbpfcp-jj-mark:3024:0:0:0:q75.awebp#?w=1570&h=476&s=117662&e=png&b=fefefe)

没有辜负我这么久的等待，哈哈哈！

之前那篇文章使用的是我写的一个天气，这回改下，改为使用 “玩安卓” 吧！

本文中的代码地址：[玩安卓 Github：https://github.com/zhujiang521/PlayAndroid](https://link.juejin.cn/?target=https%3A%2F%2Fgithub.com%2Fzhujiang521%2FPlayAndroid "https://github.com/zhujiang521/PlayAndroid")

### 添加依赖

```nginx
dependencies {
    implementation "androidx.glance:glance:1.0.0"
}
​
android {
   buildFeatures {
       compose true
   }
​
   composeOptions {
       kotlinCompilerExtensionVersion = "1.5.3"
   }
}

```

依赖添加很简单，如果你的项目中有 `Compose` 的话，只需要添加下 `dependencies` 中的内容即可。

#### 创建小部件

首先来创建一个小部件，大家都知道，小部件其实就是一个 `BroadcastReceiver`，所以需要在 `AndroidManifest` 中声明下：

```xml
<receiver
    android:name=".widget.ArticleListWidget"
    android:exported="false">
    <intent-filter>
        <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
    </intent-filter>
​
    <meta-data
        android:name="android.appwidget.provider"
        android:resource="@xml/article_list_widget_info" />
</receiver>

```

上面的代码大部分大家都很熟悉了，唯一和普通广播不同的就是多了一个配置项，如果写过小部件的应该也很熟悉了：

```routeros
<?xml version="1.0" encoding="utf-8"?>
<appwidget-provider xmlns:android="http://schemas.android.com/apk/res/android"
    android:description="@string/app_widget_description"
    android:initialKeyguardLayout="@layout/glance_default_loading_layout"
    android:initialLayout="@layout/glance_default_loading_layout"
    android:minWidth="110dp"
    android:minHeight="69dp"
    android:minResizeWidth="110dp"
    android:minResizeHeight="69dp"
    android:resizeMode="horizontal|vertical"
    android:targetCellWidth="2"
    android:targetCellHeight="2"
    android:updatePeriodMillis="86400000"
    android:widgetCategory="home_screen" />

```

这里的配置项其实不少，上面所列举的只是常用的一些，那到底都可以配置那些项呢？点进去看看不得了！

```xml
<declare-styleable name="AppWidgetProviderInfo">
    <!-- AppWidget的最小宽度 -->
    <attr name="minWidth"/>
    <!-- AppWidget的最小高度 -->
    <attr name="minHeight"/>
    <!-- AppWidget可以调整大小的最小宽度. -->
    <attr name="minResizeWidth" format="dimension"/>
    <!-- AppWidget可以调整大小的最小高度. -->
    <attr name="minResizeHeight" format="dimension"/>
    <!-- AppWidget可以调整大小的最大宽度. -->
    <attr name="maxResizeWidth" format="dimension"/>
    <!-- AppWidget可以调整大小的最大高度. -->
    <attr name="maxResizeHeight" format="dimension"/>
    <!-- AppWidget的默认宽度，以桌面网格单元为单位 -->
    <attr name="targetCellWidth" format="integer"/>
    <!-- AppWidget的默认高度，以桌面网格单元为单位 -->
    <attr name="targetCellHeight" format="integer"/>
    <!-- 更新周期(以毫秒为单位)，如果AppWidget将更新自己，则为0 -->
    <attr name="updatePeriodMillis" format="integer" />
    <!-- 初始布局的资源id -->
    <attr name="initialLayout" format="reference" />
    <!-- 初始Keyguard布局的资源id -->
    <attr name="initialKeyguardLayout" format="reference" />
    <!-- 要启动配置的AppWidget包中的类名。如果没有提供，则不会启动任何活动 -->
    <attr name="configure" format="string" />
    <!-- 在可绘制的资源id中预览AppWidget配置后的样子。如果没有提供，则将使用AppWidget的图标 -->
    <attr name="previewImage" format="reference" />
    <!-- 预览AppWidget配置后的样子的布局资源id。与previewImage不同，previewLayout可以更好地在不同的区域、系统主题、显示大小和密度等方面展示AppWidget。如果提供了，它将优先于支持的小部件主机上的previewImage。否则，将使用previewImage -->
    <attr name="previewLayout" format="reference" />
    <!-- AppWidget子视图的视图id，应该是自动高级的。通过小部件的主机 -->
    <attr name="autoAdvanceViewId" format="reference" />
    <!-- 可选参数，指示是否以及如何调整此小部件的大小。支持使用|运算符组合值，也就是说可以横向和纵向可以同时使用 -->
    <attr name="resizeMode" format="integer">
        <flag name="none" value="0x0" />
        <flag name="horizontal" value="0x1" />
        <flag name="vertical" value="0x2" />
    </attr>
    <!-- 可选参数，指示可以显示此小部件的位置，即。主屏幕，键盘保护，搜索栏或其任何组合. -->
    <attr name="widgetCategory" format="integer">
        <flag name="home_screen" value="0x1" />
        <flag name="keyguard" value="0x2" />
        <flag name="searchbox" value="0x4" />
    </attr>
    <!-- 指示小部件支持的各种特性的标志。这些是对小部件主机的提示，实际上并不改变小部件的行为 -->
    <attr name="widgetFeatures" format="integer">
        <!-- 小部件可以在绑定后随时重新配置 -->
        <flag name="reconfigurable" value="0x1" />
        <!-- 小部件由应用程序直接添加，不需要出现在可用小部件的全局列表中 -->
        <flag name="hide_from_picker" value="0x2" />
        <!-- 小部件提供了一个默认配置。主机可能决定不启动所提供的配置活动 -->
        <flag name="configuration_optional" value="0x4" />
    </attr>
    <!-- 包含小部件简短描述的字符串的资源标识符 -->
    <attr name="description" />
</declare-styleable>

```

由于配置项确实不少，所以直接写了下注释，大家根据需求进行使用即可，目前这是所有的小部件配置项，有一些是在 Android 12 中新增的。

### 工欲善其事，必先利其器

配置项写好了，接下来该编写小部件的代码了！

#### GlanceAppWidgetReceiver

之前编写小部件的时候都会用到 `AppWidgetProvider` ，它继承自 `BroadcastReceiver` ，但现在使用 `Glance` 需要继承 `GlanceAppWidgetReceiver` ，那么 `GlanceAppWidgetReceiver` 是个啥？来，3、2、1，上代码！

```dart
abstract class GlanceAppWidgetReceiver : AppWidgetProvider() {
​
    ......
​
    /**
     * 用于生成AppWidget并将其发送给AppWidgetManager的GlanceAppWidget的实例
     * 注意:这不会为GlanceAppWidget设置CoroutineContext，它将始终在主线程上运行。
     */
    abstract val glanceAppWidget: GlanceAppWidget
    
    ......
}

```

通过上面代码可以看出 `GlanceAppWidgetReceiver` 继承自 `AppWidgetProvider` ，是一个抽象类，并且需要实现一个抽象函数 `glanceAppWidget` ，这个函数需要返回的对象为 `GlanceAppWidget` 。

#### GlanceAppWidget

那就再来看下 `GlanceAppWidget` 吧，来，3、2、1，上代码！

```kotlin
abstract class GlanceAppWidget(
    @LayoutRes
    internal val errorUiLayout: Int = R.layout.glance_error_layout,
) {
​
    ......
  
    /**
     * 重写此函数以提供 Glance Composable
     */
    abstract suspend fun provideGlance(
        context: Context,
        id: GlanceId,
    )
​
    /**
     * 定义对大小的处理。
     */
    open val sizeMode: SizeMode = SizeMode.Single
​
    /**
     * 特定于视图的小部件数据的数据存储。
     */
    open val stateDefinition: GlanceStateDefinition<*>? = PreferencesGlanceStateDefinition
​
    /**
     * 当应用程序小部件从其主机上删除时由框架调用。当该方法返回时，与glanceId关联的状态将被删除。
     */
    open suspend fun onDelete(context: Context, glanceId: GlanceId) {}
  
    ......
}

```

可以看到 `GlanceAppWidget` 也是一个抽象类，构建这个类时有一个可选参数，意思是遇到错误时需要展示的布局。然后有几个子类可以重写的函数，还有一个必须实现的抽象函数，下面来分别看下吧：

* **`provideGlance`：** 此函数为抽象函数，子类必须重写；重写此函数以提供 `Glance Composable`，也就是说这个函数是用来编写布局的。一旦数据准备好，使用 `provideContent` 提供可组合对象。`provideGlance` 作为 `CoroutineWorker` 在后台运行，以响应 `update` 和 `updateAll` 的调用，以及来自`Launcher` 的请求。在 `provideContent` 被调用之前，`provideGlance` 受限于 `WorkManager` 时间限制(目前为十分钟)，在调用 `provideContent` 之后，组合继续运行并重新组合大约45秒。当接收到UI交互或更新请求时，会添加额外的时间来处理这些请求。需要注意的是：如果 `provideGlance` 已经在运行，`update` 和 `updateAll` 不会重新启动。因此应该在调用 `provideContent` 之前加载初始数据，然后在组合中观察数据源（例如 `collectasstate`）。这可以确保小部件在组合处于活动状态时继续更新，当从应用程序的其他地方更新数据源时，确保调用update，以防这个小部件的Worker当前没有运行。
* **`sizeMode`：** 定义对小部件大小的处理，这个会在下面展开来说
* **`stateDefinition`：** 特定于视图的小部件数据的数据存储，当存储数据发生变化时，小部件会进行刷新
* **`onDelete`：** 应用程序小部件从其主机上删除时由框架调用。当该方法返回时，与glanceId关联的状态将被删除。

#### SizeMode

OK，上面简单看了下 `GlanceAppWidget` 中的公开函数，接下来看下 `SizeMode` ，老规矩，3、2、1，上代码！

```kotlin
sealed interface SizeMode {
    /**
     * GlanceAppWidget提供了一个UI。LocalSize将是AppWidget的最小尺寸，在AppWidget提供程序信息中定义，单个
     */
    object Single : SizeMode {
        override fun toString(): String = "SizeMode.Single"
    }
​
    /**
     * 为每个AppWidget可能显示的大小提供了一个UI。大小列表由选项包提供(参见getAppWidgetOptions)。每个大小都将调用可组合对象。在调用期间，LocalSize将是生成UI的对象。
     */
    object Exact : SizeMode {
        override fun toString(): String = "SizeMode.Exact"
    }
​
    /**
     * 在Android 12及以后的版本中，每个提供的大小将调用一次composable，并且从大小到视图的映射将被发送到系统。然后框架将根据App Widget的当前大小来决定显示哪个视图。在Android 12之前，composable将被调用用于显示App Widget的每个大小(如Exact)。对于每种尺寸，将选择最佳视图，即适合可用空间的最大视图，或者如果不适合则选择最小视图。Params: sizes -要使用的大小列表，不能为空。
     */
    class Responsive(val sizes: Set<DpSize>) : SizeMode {
​
        init {
            require(sizes.isNotEmpty()) { "The set of sizes cannot be empty" }
        }
​
        ......
    }
}

```

可以看到 `SizeMode` 是一个接口，一共有三个类实现了 `SizeMode` 接口，`Single` 和 `Exact` 好理解一些，`Responsive` 不太好理解，但是还记得 `Android 12` 中小部件的更新么？`RemoteView` 增加了一个构造函数，来看下吧：

```less
public RemoteViews(@NonNull Map<SizeF, RemoteViews> remoteViews)

```

即每个提供的大小将调用一次 `composable` ，并且从大小到视图的映射将被发送到系统，也就是说会将定义好的大小做缓存，可以优化小部件的展示。

### 爱码士

上面说了半天还没进入正题，一行正经代码都还没写。。。

先来搞一个 `GlanceAppWidget` 吧：

```kotlin
class ArticleListWidgetGlance : GlanceAppWidget() {
​
    override suspend fun provideGlance(context: Context, id: GlanceId) {
        provideContent {
            // 编写 Glance 代码
        }
    }
​
}

```

预料之中，继承自 `GlanceAppWidget` ，实现抽象函数 `provideGlance` ，但还是无法在 `provideGlance` 中直接使用 `Glance` 来编写 `Compose` 风格的布局，还需要调用 `provideContent` ，上面其实也提到过了，那就来看下 `provideContent` 吧，3、2、1，上代码！

```less
suspend fun GlanceAppWidget.provideContent(
    content: @Composable @GlanceComposable () -> Unit
): Nothing {
    coroutineContext[ContentReceiver]?.provideContent(content)
        ?: error("provideContent requires a ContentReceiver and should only be called from " + "GlanceAppWidget.provideGlance")
}

```

可以看到这是一个扩展函数，只有一个参数，看到这个参数是不是就理解了，终于看到了咱们熟悉的 `@Composable` ，需要注意的是：如果此函数与自身并发调用，则前一个调用将抛出 CancellationException，新内容将替换它。还有就是这个函数只能从 `GlanceAppWidget.provideGlance` 调用。

OK，`GlanceAppWidget` 编好了之后就该写下 `GlanceAppWidgetReceiver` 了，上代码！

```angelscript
class ArticleListWidget : GlanceAppWidgetReceiver() {
    override val glanceAppWidget: GlanceAppWidget = ArticleListWidgetGlance()
}

```

更简单了，只有三行代码，同样地，也实现了 `GlanceAppWidgetReceiver` 的抽象函数，并返回了刚创建好的 `ArticleListWidget` 。

其实到这里为止 `Glance` 的整套流程就简单跑通了。接下来就来编写下布局吧：

```kotlin
override suspend fun provideGlance(context: Context, id: GlanceId) {
    val articleList = getArticleList()
    provideContent {
        GlanceTheme {
            Column {
                Text(
                    text = stringResource(id = R.string.widget_name),
                )
                LazyColumn {
                    items(articleList) { data ->
                        GlanceArticleItem(context, data)
                    }
                }
            }
        }
    }
}

```

啊！熟悉的配方！熟悉的味道！

### 爽，爽，爽

看着上面熟悉的味道是不是很舒服，哈哈哈，写小部件终于也可以优雅一些了！

#### 耗时操作优化

不知道大家注意到没有，`provideGlance` 竟然是一个挂起函数，这是什么意思，难道是？？？

没错！可以放心地在这里执行耗时操作了！比如你就可以这样：

```kotlin
override suspend fun provideGlance(context: Context, id: GlanceId) {
    val name  = getName()
    provideContent {
        Text(text = name)
    }
}
​
private suspend fun getName():String {
    delay(5000L)
    return "我爱你啊"
}

```

下面来运行看下效果！

![添加小部件.gif](https://proxy-prod.omnivore-image-cache.app/0x0,s56q_kUc4_iwLd4a6mqpZwEbbr6izkq9MlYNKFuEoUIM/https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/4922844b70b14fabbb7765a557ddbf5c~tplv-k3u1fbpfcp-jj-mark:3024:0:0:0:q75.awebp#?w=270&h=599&s=9388044&e=gif&f=51&b=79787f)

是不是挺好，解决了小部件的一大坑！

#### 小部件更新

小部件的更新一直也是个问题，比如横竖屏转换后小部件的刷新、系统配置修改了之后的刷新，这些都是没有的，系统应用可以和系统进行一些骚操作，但是普通应用不可以啊，所以 `Glance` 中就引入了 `WorkManager` 来改善这个问题，最低可以设置十分钟的间隔刷新。

下面就来简单看下使用吧：

```kotlin
class WorkWorker(
    private val context: Context,
    workerParameters: WorkerParameters
) : CoroutineWorker(context, workerParameters) {
​
    companion object {
​
        private val uniqueWorkName = WorkWorker::class.java.simpleName
​
        // 排队进行工作
        fun enqueue(context: Context, size: DpSize, glanceId: GlanceId, force: Boolean = false) {
            val manager = WorkManager.getInstance(context)
            val requestBuilder = OneTimeWorkRequestBuilder<WorkWorker>().apply {
                addTag(glanceId.toString())
                setExpedited(OutOfQuotaPolicy.RUN_AS_NON_EXPEDITED_WORK_REQUEST)
                setInputData(
                    Data.Builder()
                        .putFloat("width", size.width.value.toPx)
                        .putFloat("height", size.height.value.toPx)
                        .putBoolean("force", force)
                        .build()
                )
            }
            val workPolicy = if (force) {
                ExistingWorkPolicy.REPLACE
            } else {
                ExistingWorkPolicy.KEEP
            }
​
            manager.enqueueUniqueWork(
                uniqueWorkName + size.width + size.height,
                workPolicy,
                requestBuilder.build()
            )
        }
​
        /**
         * 取消任何正在进行的工作
         */
        fun cancel(context: Context, glanceId: GlanceId) {
            WorkManager.getInstance(context).cancelAllWorkByTag(glanceId.toString())
        }
    }
​
    override suspend fun doWork(): Result {
        // 需要执行的操作
        return Result.success()
    }
}

```

OK，先创建了一个 `Work`，然后看下在 `Glance` 中如何使用吧！

```kotlin
override suspend fun onDelete(context: Context, glanceId: GlanceId) {
    super.onDelete(context, glanceId)
    WorkWorker.cancel(context, glanceId)
}
​
override suspend fun provideGlance(context: Context, id: GlanceId) {
    provideContent {
        val size = LocalSize.current
        GlanceTheme {
            CircularProgressIndicator()
            // 在合成完成后，使用glanceId作为标记为worker排队，以便在小部件实例被删除的情况下取消所有作业
            val glanceId = LocalGlanceId.current
            SideEffect {
                WorkWorker.enqueue(context, size, glanceId)
            }
        }
    }
}

```

很简单，在 `provideGlance` 中排队执行操作，然后在 `onDelete` 中将 `Work` 取消了即可。

#### 便捷的 ListView

写过小部件的都知道 `ListView` 特别坑，原生小部件想要实现 `ListView` 需要实现 `Factory`，`Service` 等，而在 `Glance` 这里直接两三行代码搞定。

```haskell
LazyColumn(
    modifier = GlanceModifier.fillMaxSize().padding(horizontal = 10.dp)
) {
    items(articleList) { data ->
        GlanceArticleItem(context, data)
    }
}

```

没错，和 `Compose` 中一样，名字也一样，都是 `LazyColumn` ，写起来非常便捷。

#### 更方便的 LocalXXX

大家都知道 `Compose` 中的 `LocalXXX` 非常方便好用，`Glance` 中也提供了一些：

```pony
/**
 * 生成的概览视图的大小。概览视图至少有那么多空间可以显示。确切的含义可能会根据表面及其配置方式而变化。
 */
val LocalSize = staticCompositionLocalOf<DpSize> { error("No default size") }
​
/**
 * 生成概览视图时应用程序的上下文。
 */
val LocalContext = staticCompositionLocalOf<Context> { error("No default context") }
​
/**
 * 本地视图状态，在surface实现中定义。用于特定于视图的状态数据的可定制存储。
 */
val LocalState = compositionLocalOf<Any?> { null }
​
/**
 * 当前合成生成的概览视图的唯一Id。
 */
val LocalGlanceId = staticCompositionLocalOf<GlanceId> { error("No default glance id") }

```

不过这块需要注意包的导入问题。

#### Action

小部件中之前如果想要实现点击效果的话只能使用 `PendingIntent` ，这样很麻烦，现在 `Glance` 为我们提供了 `Action` ，使用方法如下：

```reasonml
Button(text = "Glance按钮", onClick = actionStartActivity(ComponentName("包名","包名+类名")))
Button(text = "Glance按钮", onClick = actionStartActivity<MainActivity>())
Button(text = "Glance按钮", onClick = actionStartActivity(MainActivity::class.java))

```

不仅如此，还可以像下面这样操作：

```lisp
Text(text = "点击", modifier = GlanceModifier.clickable {
    Log.e("TAG", "provideGlance: click")
})

```

这个实在是太方便了！推荐大家使用。但这个需要注意，如果想使用这个实现动画效果的话是不行的，因为它没有办法在特别短的时间内刷新，我之前尝试过 `Compose` 中的属性动画 `animate*AsState` ，结果就是只执行了最后的结果，中间过程全部忽略了。。。。

### 坑，坑，坑

“人家官方废了这么大劲开发出来的库，怎么能说人家坑呢？”

“因为它确实坑啊！”

#### 坑一

刚才看到的熟悉的代码，其实一点也不熟悉，为什么这么说，来看下导入的包就知道了：

```css
import androidx.compose.runtime.Composable
import androidx.compose.ui.unit.dp
import androidx.glance.GlanceModifier
import androidx.glance.GlanceTheme
import androidx.glance.action.Action
import androidx.glance.action.clickable
import androidx.glance.appwidget.action.actionStartActivity
import androidx.glance.appwidget.cornerRadius
import androidx.glance.background
import androidx.glance.layout.Alignment
import androidx.glance.layout.Column
import androidx.glance.layout.Row
import androidx.glance.layout.Spacer
import androidx.glance.layout.fillMaxWidth
import androidx.glance.layout.height
import androidx.glance.layout.padding
import androidx.glance.layout.size
import androidx.glance.layout.wrapContentWidth
import androidx.glance.text.Text

```

虽然 `Composable` 还是使用的 `Compose` 的，但是里面的可组合项全部是 `Glance` 中重写的。。。。

咱就是说啊！有没有一种可能，就是你在写的时候自然地就导入了 `Compose` 的包？运行直接报错！也没有任何提醒。。

![image.png](https://proxy-prod.omnivore-image-cache.app/0x0,sOlxGuRtLXPrIClN_edtbB01vv98y-QdhxUMQocle2Y4/https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/9e44374b70534ffdb8653f1574aed156~tplv-k3u1fbpfcp-jj-mark:3024:0:0:0:q75.awebp#?w=1518&h=520&s=102925&e=png&b=ffffff)

是不是？没有一点提醒，这种情况官方有没有一种可能，就是像是 `Glance` 中的 `Modifier` 一样，也在前面加一个前缀，让开发者能够容易区分一点？即使加前缀不好看，你们不想加，有没有可能修改下编译器，让编译器告诉开发者不能这么写行不行？

#### 坑二

图片的加载，图片是安卓开发中太常见的东西了，以前咱们使用 `ImageView` 来进行图片的展示，现在有了 `Compose` 了我们使用 `Image` 来进行展示，`Glance` 中同样是使用 `Image` 来展示，来玩个游戏吧，找不同！先来看下 `Compose` 中的 `Image` ：

```kotlin
@Composable
fun Image(
    painter: Painter,
    contentDescription: String?,
    modifier: Modifier = Modifier,
    alignment: Alignment = Alignment.Center,
    contentScale: ContentScale = ContentScale.Fit,
    alpha: Float = DefaultAlpha,
    colorFilter: ColorFilter? = null
)

```

再来看下 `Glance` 中的 `Image` ：

```kotlin
@Composable
fun Image(
    provider: ImageProvider,
    contentDescription: String?,
    modifier: GlanceModifier = GlanceModifier,
    contentScale: ContentScale = ContentScale.Fit,
    colorFilter: ColorFilter? = null
)

```

是不是很像，但是 `Glance` 因为 `RemoteView` 的限制少了一些功能，在 `Compose` 中咱们可以通过 `painterResource` 来构建出 `Painter`，但在 `Glance` 中又换了个名字 `ImageProvider` ，咱就是说啊，有没有一种可能，就是要不你就都学 `Compose` ，要不你就都不学。。。。

还有就是文字，来看下 `Glance` 中的 `Text` 吧：

```kotlin
@Composable
fun Text(
    text: String,
    modifier: GlanceModifier = GlanceModifier,
    style: TextStyle = defaultTextStyle,
    maxLines: Int = Int.MAX_VALUE,
)

```

虽然 `Compose` 中的 `Text` 接收的也是一个 `String`，但是人家有 `stringResource` 函数啊，你呢。。。忘写了么？

算了，自己写一个吧：

```less
@Composable
fun stringResource(@StringRes id: Int): String {
    return LocalContext.current.getString(id)
}

```

这个函数我个人觉得可以放到 `Glance` 中。。。。

### 总结

今天所讲的 `Glance` 其实也是基于 `Compose` 的，由此可见，Google 现在对 `Compose` 发力非常足，如果大家想系统地学习 `Compose` 的话，可以购买我的新书[《Jetpack Compose：Android全新UI编程》](https://juejin.cn/post/7027020266312056840 "https://juejin.cn/post/7027020266312056840")进行阅读，里面有完整的 Compose 框架供大家学习。

[京东购买地址](https://link.juejin.cn/?target=https%3A%2F%2Fitem.jd.com%2F10039809078875.html "https://link.juejin.cn?target=https%3A%2F%2Fitem.jd.com%2F10039809078875.html")

[当当购买地址](https://link.juejin.cn/?target=http%3A%2F%2Fproduct.dangdang.com%2F593507948.html "https://link.juejin.cn?target=http%3A%2F%2Fproduct.dangdang.com%2F593507948.html")

本文中的代码地址：[玩安卓 Github：https://github.com/zhujiang521/PlayAndroid](https://link.juejin.cn/?target=https%3A%2F%2Fgithub.com%2Fzhujiang521%2FPlayAndroid "https://github.com/zhujiang521/PlayAndroid")

如果对你有帮助的话，别忘记点个 Star，感激不尽，大家如果有疑问的话可以在评论区提出来。

本文收录于以下专栏

![cover](https://proxy-prod.omnivore-image-cache.app/0x0,sKmSMnoNLgVNA5LfXucADMNHlsrnb5wzlkJGxLxMN0kk/https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/7289c80162a245d4af39c9cd5b664235~tplv-k3u1fbpfcp-jj:80:60:0:0:q75.avis)

 Android Compose 从零到精通

 专栏目录

 Android Compose 从零到精通

上一篇

 一起来看看 Compose Accompanist

---

