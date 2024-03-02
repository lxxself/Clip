---
id: Rr45pIEBKc5BngQz15sK
---

# 用Kotlin Flow无缝衔接Retrofit
#Omnivore

[Read on Omnivore](https://omnivore.app/me/kotlin-flow-retrofit-181a439d65c)
[Read Original](https://mp.weixin.qq.com/s?__biz=MzA5MzI3NjE2MA%3D%3D&amp%3Bchksm=886323abbf14aabd853b50dc2dfb2fc675fcbf79f5c4b685799a31784171f32c27ace6aaee64&amp%3Bidx=1&amp%3Bmid=2650264260&amp%3Bmpshare=1&amp%3Bscene=1&amp%3Bsharer_shareid=a1c1a089a599c63559b93d9e0110f8ff&amp%3Bsharer_sharetime=1654738821514&amp%3Bsn=93ffe6cf5672214c0feeee1a512d2cf7&amp%3Bsrcid=0609AVPdndys9rFdKR9gbrPv)

 Vincent  郭霖 _发表于江苏_ 

![图片](https://proxy-prod.omnivore-image-cache.app/0x0,sExgtTwr-wkaVoqgd6O7cJxkortO-m3zlTePnsQfTWdQ/https://mmbiz.qpic.cn/mmbiz_jpg/v1LbPPWiaSt5u4qlRDV7JCPTlhLruwgCE7IwG1NBPXaJxfvDKvhCWSDe0PMuVbEb1pavYAiaAjbELXcNC1UPzbJw/640?wx_fmt=jpeg&wxfrom=5&wx_lazy=1&wx_co=1)  

/ 今日科技快讯 /

近日，欧洲议会和欧洲理事会一致同意，将自2024年秋天起在欧盟境内统一使用Type-C接口用于移动设备充电。此举被认为将有利于减少电子垃圾，也让用户在购买移动设备时更加简易方便。

/ 作者简介 /

本篇文章来自Vincent的投稿，文章主要分享了如何使用Kotlin Flow对Retrofit进行无缝衔接，相信会对大家有所帮助！同时也感谢作者贡献的精彩文章。

Vincent的博客地址：

> https://blog.csdn.net/jungle\_pig?type=blog

/ 前言 /

Kotlin早已成为Android官方开发语言，企图统一开发规范的Jetpack系列库基本上天然支持Kotlin。Retrofit在Kotlin之前就已名扬天下，默认情况下，Retrofit的API接口方法返回值需声明为Call<ResponseBody>或Call<Response<ResponseBody>>。

我们可以通过Converter对ResponseBody进行自动解析，如GsonConverter，则方法返回值可声明为Call<Response<\[Bean\]>>或Call<\[Bean\]>。

我们还可以通过CallAdapter对Call<T>进行转化，如RxjavaCallAdapter，则方法返回值可声明为Observable<Response<\[Bean\]>>，Observable<\[Bean\]>。

Retrofit + RxjavaCallAdapter + GsonConverter 是最受欢迎的使用模式。Retrofit早期并不支持Kotlin，不支持不代表不可用，毕竟Java和Kotlin可以互相调用。在Kotlin中使用Retrofit会是这个样子。

/ Kotlin中使用RxjavaCallAdapter /

**声明ApiService**

interface WeatherApiService {  
    @GET("weather/now.json")  
    fun getWeatherInfoNow(@Query("location") location: String): Single<WeatherInfo>  
}  

**调用ApiService**

ApiServiceManager.weatherApiService  
    .getWeatherInfoNow(location = "北京")  
    .subscribeOn(Schedulers.io())  
    .observeOn(AndroidSchedulers.mainThread())  
    .subscribe(  
        { println("process biz data:$it") },  
        { println("error occurs:$it") },  
    )  

在Kotlin的世界里，异步代码应该通过协程来执行，协程的性能优势在此就不赘述了。这种代码依旧停留在基于线程切换的异步代码。在Retrofit正式推出支持Kotlin的方案前，Jake Warton大神推出了一个方案，基于Kotlin Deferred的CoroutineCallAdapter。  

/ 基于DeferredCallAdapter /

**添加CoroutineCallAdapter**

private val retrofit = Retrofit.Builder()  
    //...  
    .addCallAdapterFactory(CoroutineCallAdapterFactory())  
    //...  
    .build()

### **声明ApiService**

### 接口方法返回值声明为Deferred<T>类型。

interface WeatherApiService {  
    @GET("weather/now.json")  
    fun getWeatherInfoNow(@Query("location") location: String): Deferred<WeatherInfo>  
}  

### **调用ApiService**

MainScope().launch {  
    try {  
        val weatherInfo = ApiServiceManager.weatherApiService  
            .getWeatherInfoNow(location = "北京")  
            .await()  
        println("process biz data:$weatherInfo")  
    } catch (ex: Exception) {  
        println("error occurs:$ex")  
    }  
}  

后来，CoroutineCallAdapter废弃了，因为Retrofit自身有了支持方案，不需要使用者添加CallAdapter，ApiService接口方法可直接声明为suspend方法。

/ Retrofit内置的Kotlin支持方案 /

### **为api接口方法添加suspend关键字**

interface WeatherApiService {  
    @GET("weather/now.json")  
    suspend fun getWeatherInfoNow(@Query("location") location: String): WeatherInfo  
}  

其实在Retrofit内部，会自动为suspend方法创建CallAdapter，所以添加了suspend关键字的api方法，其返回值可声明为以下类型，后面两种需要已添加GsonConverter。

* ResponseBody
* Response<ResponseBody>
* \[Bean\]
* Response<\[Bean\]>

**调用ApiService**

MainScope().launch {  
    try {  
        val weatherInfo = ApiServiceManager.weatherApiService  
            .getWeatherInfoNow(location = "北京")  
        println("process biz data:$weatherInfo")  
    } catch (ex: Exception) {  
        println("error occurs:$ex")  
    }  
}  

尽管存在上述两种方案，很多小伙伴依然倾向于使用RxjavaCallAdapter，原因如下：

* Rxjava功能强大的操作符，可进行复杂的数据处理
* 响应式编程，数据变换、异常捕获，业务处理均流式处理。上述的示例代码还需用try-catch块包裹，不如Rxjava简洁。当然了，上述代码还可以通过CoroutineExceptionHandler实现异常捕获，但仍不如Rxjava优雅和丝滑。
* 上述两种方案的内部实现上最终都是调用Call的enqueue方法，异步调用Call，线程调度上使用Okhttp内部的线程池，真正耗时的代码片段在Okhttp的线程池里执行的，而不是由协程调用方的上下文决定。RxjavaCallAdapter可通过指定async参数控制是同步调用Call还是异步调用Call。如：

//同步调用Call  
//Call.execute()的执行线程由subscribeOn(Scheduler)方法决定  
//我们大多采用该种方式  
RxJava2CallAdapterFactory.create()  

//异步调用Call  
//仅仅Call.enqueue()的调用发生在subscribeOn(Scheduler)所指定的线程  
//真正的耗时操作在Okhttp的线程池里执行  
RxJava2CallAdapterFactory.createAsync()  

但是，前文说过了，Rxjava并没有天然支持Kotlin。

/ FlowCallAdapter /

结合以上的讨论，我们究竟需要一个什么样的CallAdapter？

* 支持Kotlin
* 类似Rxjava的响应式编程且具有强大的数据处理功能（通过操作符实现）
* 灵活指定是同步调用Call还是异步调用Call

其实，Kotlin中已经存在可与Rxjava一争高低的东西了，那就是Flow。我们只需定义一个FlowCallAdapter，使Api接口方法的返回值可声明为Flow<T>就可以了。轮子已造好，先看如何使用，然后讨论实现。

**如何使用FlowCallAdapter**

**第一步，添加依赖**

implementation "io.github.vincent-series:sharp-retrofit:1.9"

当然，你的项目里还要有Retrofit及Kotlin-Coroutine的相关依赖。

**为Retrofit添加FlowCallAdapter**

    private val retrofit = Retrofit.Builder()  
     // ...  
     .addCallAdapterFactory(FlowCallAdapterFactory.create())  
     // ...  
     .build()  

可为FlowCallAdapterFactory.create()指定async参数控制是同步调用Call还是异步调用Call，默认为false，即由协程上下文决定网络请求的执行线程。

  FlowCallAdapterFactory.create(async = false)  

**声明Api接口**

如：

 interface WeatherApiService {  
 @GET("weather/now.json")  
 fun getWeatherInfoNow(@Query("location") location: String): Flow<WeatherInfo>  
 }  

Api方法返回值支持声明为以下类型，后面两种需要已添加GsonConverter。

* Flow<ResponseBody>
* Flow<Response<ResponseBody>>
* Flow<\[Bean\]>
* Flow<Response<\[Bean\]>>

**调用Api**

     MainScope().launch {  
         ApiServiceManager.weatherApiService  
             .getWeatherInfoNow(location = "北京")  
             //通过一系列操作符处理数据，如map，如果有必要的话  
             .map {  
                 // ...  
             }  
             //在Dispatcher.IO上下文中产生订阅数据  
             .flowOn(Dispatchers.IO)  
             //捕获异常  
             .catch { ex ->  
                 //处理异常  
                 println("error occurs:$ex")  
             }  
             //订阅数据  
             .collect {  
                 //处理数据  
                 println("weather info:$it")  
             }  
     }

注意：Flow一开始同Rxjava一样，有subscribeOn和observeOn方法，后来废弃，产生订阅数据的上下文由flowOn代替，不再提供对应的observeOn，Flow认为接收数据的协程上下文应由调用Flow的协程决定，如要在主线程接收Flow发射的数据，只需在MainScope中订阅Flow即可。

### **实现FlowCallAdapter**

### 自定义CallAdapter需实现接口retrofit2.CallAdapter，看下它的相关方法：

    //泛型参数R表示Call<R>对象的泛型参数，默认为Response<ResponseBody>或ResponseBody,  
//如果运用了GsonConverter,有可能是Response<[Bean]>或[Bean]  
public interface CallAdapter<R, T> {  
  //将响应体ResponseBody解析为何种类型，如Call<User>或Call<Response<User>>的responseType为User  
  Type responseType();

  //将Call<R>转化成T类型的对象，如Rxjava中，将Call<R>转化成Observable<R>  
  T adapt(Call<R> call);  
}

**BodyFlowCallAdapter**

BodyFlowCallAdapter负责将Call<ResponseBody>、Call<\[Bean\]>转化为Flow<ResponseBody>和Flow<\[Bean\]>。

  //R表示response body的类型，默认为okhttp3.ResponseBody,  
//有可能被Converter自动解析为其他类型如[Bean]  
class BodyFlowCallAdapter<R>(private val responseBodyType: R) : CallAdapter<R, Flow<R>> {  
    //由于我们只是想将Call转为Flow，无意插足ResponseBody的解析  
    //所以直接原样返回responseBodyType即可  
    override fun responseType(): Type = responseBodyType as Type  
    //直接调用bodyFlow(call)返回Flow<R>对象。  
    override fun adapt(call: Call<R>): Flow<R> = bodyFlow(call)  
}  

bodyFlow(call)方法的实现：

  fun <R> bodyFlow(call: Call<R>): Flow<R> = flow {  
    suspendCancellableCoroutine<R> { continuation ->  
        //协程取消时，调用Call.cancel()取消call  
        continuation.invokeOnCancellation {  
            call.cancel()  
        }  
        try {  
            //执行call.execute()  
            val response = call.execute()  
            if (response.isSuccessful) {  
                //http响应[200..300)，恢复执行，并返回响应体  
                continuation.resume(response.body()!!)  
            } else {  
                //其他http响应，恢复执行，并抛出http异常  
                continuation.resumeWithException(HttpException(response))  
            }  
        } catch (e: Exception) {  
            //捕获的其他异常，恢复执行，并抛出该异常  
            continuation.resumeWithException(e)  
        }  
    }.let { responseBody ->  
        //通过flow发射响应体  
        emit(responseBody)  
    }  
}  

**ResponseFlowCallAdapter**

ResponseFlowCallAdapter负责将Call<Response<ResponseBody>>、Call<Response<\[Bean\]>>转化为Flow<Response<ResponseBody>>和Flow<Response<\[Bean\]>>。

//R表示response body的类型，默认为okhttp3.ResponseBody,  
//有可能被Converter自动解析为其他类型如[Bean]  
class ResponseFlowCallAdapter<R>(private val responseBodyType: R) :  
    CallAdapter<R, Flow<Response<R>>> {  
    //由于我们只是想将Call转为Flow，无意插足ResponseBody的解析  
    //所以直接原样返回responseBodyType即可  
    override fun responseType() = responseBodyType as Type  
    //直接调用responseFlow(call)返回Flow<Response<R>>对象。  
    override fun adapt(call: Call<R>): Flow<Response<R>> = responseFlow(call)  
}  

responseFlow(call)方法的实现：

fun <T> responseFlow(call: Call<T>): Flow<Response<T>> = flow {  
    suspendCancellableCoroutine<Response<T>> { continuation ->  
        //协程取消时，调用call.cancel()取消call  
        continuation.invokeOnCancellation {  
            call.cancel()  
        }  
        try {  
            //执行call.execute()  
            val response = call.execute()  
            //恢复执行，并返回Response  
            continuation.resume(response)  
        } catch (e: Exception) {  
            //捕获异常，恢复执行，并返回异常  
            continuation.resumeWithException(e)  
        }  
    }.let { response ->  
        //通过flow发射Response  
        emit(response)  
    }  
}  

**AsyncBodyFlowCallAdapter && AsyncResponseFlowCallAdapter**

AsyncBodyFlowCallAdapter 和 AsyncResponseFlowCallAdapter是异步版的FlowCallAdapter，这里的异步指的是在实际调用Call时，调用的是call.enqueue方法，以AsyncBodyFlowCallAdapter为例与同步版做下对比：

fun <R> asyncBodyFlow(call: Call<R>): Flow<R> = flow {  
    try {  
        suspendCancellableCoroutine<R> { continuation ->  
            //协程取消时，调用Call.cancel()取消call  
            continuation.invokeOnCancellation {  
                call.cancel()  
            }  
            //调用call.enqueue()，在callback里恢复执行并返回结果  
            call.enqueue(object : Callback<R> {  
                override fun onResponse(call: Call<R>, response: Response<R>) {  
                    if (response.isSuccessful) {  
                        //http响应[200..300)，恢复执行并返回响应体  
                        continuation.resume(response.body()!!)  
                    } else {  
                        //其他http响应，恢复执行并抛出http异常  
                        continuation.resumeWithException(HttpException(response))  
                    }  
                }

                override fun onFailure(call: Call<R>, t: Throwable) {  
                    //其他捕获的异常，恢复执行并抛出该异常  
                    continuation.resumeWithException(t)  
                }  
            })  
        }.let { responseBody->  
            //通过flow发射响应体  
            emit(responseBody)  
        }  
    } catch (e: Exception) {  
        suspendCoroutineUninterceptedOrReturn<Nothing> { continuation ->  
            Dispatchers.Default.dispatch(continuation.context) {  
                //特殊case处理，确保抛出异常前挂起，感兴趣可参考https://github.com/Kotlin/kotlinx.coroutines/pull/1667#issuecomment-556106349  
                continuation.intercepted().resumeWithException(e)  
            }  
            COROUTINE_SUSPENDED  
        }  
    }  
}

### **定义FlowCallAdapterFactory** 

最后我们需要定义一个工厂类来提供FlowCallAdapter实例，工厂类需继承retrofit2.CallAdapter.Factory抽象类。

class FlowCallAdapterFactory private constructor(private val async: Boolean) :  
    CallAdapter.Factory() {  
    //returnType,代表api接口方法的返回值类型，annotations为该接口方法的注解  
    //根据参数返回该接口方法的CallAdapter  
    override fun get(  
        returnType: Type,  
        annotations: Array<out Annotation>,  
        retrofit: Retrofit,  
    ): CallAdapter<*, *>? {  
        //如果返回值原始类型不是Flow类型，直接返回null，表示不做处理  
        if (getRawType(returnType) != Flow::class.java) return null  
        //强制返回值类型为Flow<R>,而不是Flow  
        if (returnType !is ParameterizedType) {  
            throw IllegalStateException("the flow type must be parameterized as Flow<Foo>!")  
        }  
        //获取Flow的泛型参数  
        val flowableType = getParameterUpperBound(0, returnType)  
        //获取Flow的泛型参数的原始类型  
        val rawFlowableType = getRawType(flowableType)

        return if (rawFlowableType == Response::class.java) {  
            //Flow<T>中的T为retrofit2.Response，但不是泛型Response<R>模式  
            if (flowableType !is ParameterizedType) {  
                throw IllegalStateException("the response type must be parameterized as Response<Foo>!")  
            }  
            //选取Response的泛型参数作为ResponseBody，创建Flow<Response<R>>模式的FlowCallAdapter  
            val responseBodyType = getParameterUpperBound(0, flowableType)  
            createResponseFlowCallAdapter(async, responseBodyType)  
        } else {  
            //直接将Flow的泛型参数作为ResponseBody,创建Flow<R>模式的FlowCallAdapter  
            createBodyFlowCallAdapter(async, flowableType)  
        }  
    }

    companion object {  
        //获取工厂实例的方法  
        //async表示是异步调用Call还是同步调用Call，默认false，即同步调用，  
        //同步调用则由协程上下文决定Call.execute()的执行线程  
        //若为true，则协程只调用Call.enqueue()方法，网络请求在okhttp的线程池里执行  
        @JvmStatic  
        fun create(async: Boolean = false) = FlowCallAdapterFactory(async)  
    }  
}

最后奉上开源库地址，欢迎交流，喜欢的话请star支持一下吧！Github地址：

> https://github.com/vincent-series/sharp-retrofit

推荐阅读：

[我的新书，《第一行代码 第3版》已出版！](http://mp.weixin.qq.com/s?%5F%5Fbiz=MzA5MzI3NjE2MA==&mid=2650248955&idx=1&sn=0c5237154c4c8de2ca635f8a578aa701&chksm=88636794bf14ee823e8c11854b5c014e49a4af425c2947e7c62f3ce139062b5560b4c44e3d4f&scene=21#wechat%5Fredirect)  

[Android筑基，Kotlin扩展函数详解](http://mp.weixin.qq.com/s?%5F%5Fbiz=MzA5MzI3NjE2MA==&mid=2650263904&idx=1&sn=a4a7e02984a1761e60058466f62b90e7&chksm=8863200fbf14a91976c6d8efce0f1ff019ded7c2ed99e52739d5984ed0c29131817e901690d2&scene=21#wechat%5Fredirect)  

[我将自定义 ClassLoader 的坑都踩了一遍](http://mp.weixin.qq.com/s?%5F%5Fbiz=MzA5MzI3NjE2MA==&mid=2650263888&idx=1&sn=1f4f7cfb5659296f5530a72db872df28&chksm=8863203fbf14a9297b4ff41dcbb7c081475fc6d90097212340fcbf66fd445c409038cbce29a5&scene=21#wechat%5Fredirect)  

欢迎关注我的公众号

学习技术或投稿

![图片](https://proxy-prod.omnivore-image-cache.app/0x0,s4oUv0EiXcT20OmoYqZS2HEIbakAy7Mit2JoS19pTfQw/https://mmbiz.qpic.cn/mmbiz/wyice8kFQhf4Mm0CFWFnXy6KtFpy8UlvN0DOM3fqc64fjEj9tw23yYSqujQjSQoU1rC0vicL9Mf0X6EMR4gFluJw/640.png?wx_fmt=png)

长按上图，识别图中二维码即可关注

---

