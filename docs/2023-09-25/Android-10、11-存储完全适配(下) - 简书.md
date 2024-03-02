---
id: 695e2bb4-6279-4855-ae09-6f88c9180546
---

# Android-10、11-存储完全适配(下) - 简书
#Omnivore

[Read on Omnivore](https://omnivore.app/me/android-10-11-18acb4846be)
[Read Original](https://www.jianshu.com/p/62824be8141e)

[![](https://proxy-prod.omnivore-image-cache.app/0x0,sShezXUkogEO_Mz5rhDxlPsyvPlsQn071oTcKBj3SAXE/https://upload.jianshu.io/users/upload_avatars/19073098/e8fff55d-a484-4b46-88dc-254e8e7852ed.jpeg?imageMogr2/auto-orient/strip|imageView2/1/w/96/h/96/format/webp)](https://www.jianshu.com/u/c3187f5a9eb1)

12021.10.26 13:01:18字数 3,610阅读 3,426

## 前言

存储适配系列文章：

> [Android-存储基础](https://www.jianshu.com/p/cf6111e497cf)  
> [Android-10、11-存储完全适配(上)](https://www.jianshu.com/p/3cbb7febbfa3)  
> [Android-10、11-存储完全适配(下)](https://www.jianshu.com/p/62824be8141e)  
> [Android-FileProvider-轻松掌握](https://www.jianshu.com/p/d71afdf9c90a)

上篇文章分析了Android 10.0版本前后存储访问方式的变更，本篇将着重分析如何来具体适配Android 10.0、11.0。  
通过本篇文章，你将了解到：

> 1、MediaStore 基本知识  
> 2、通过Uri读取和写入文件  
> 3、通过Uri 获取图片和插入相册  
> 4、Android 11.0 权限申请  
> 5、Android 10/11 存储适配建议

## 1、MediaStore 基本知识

再次回顾存储区域划分：

  
![](https://proxy-prod.omnivore-image-cache.app/0x0,shzoGXmS3ViYgaYJusXBsoeKJLqBiwNVfxyE-zFAXx6k/https://upload-images.jianshu.io/upload_images/19073098-3a920560250e217c.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

image.png

上篇已经分析得出结论，Android 10.0 存储访问方式变更地方在于：

> 自带外部存储-共享存储空间和自带外部存储-其它目录

以上两个地方不能通过路径直接访问文件，而是需要通过Uri访问。

## 共享存储空间

共享存储空间存放的是图片、视频、音频等文件，这些资源是公用的，所有App都能够访问它们。

  
![](https://proxy-prod.omnivore-image-cache.app/0x0,sMiIlzHInvOgJ9FGwICDkxtzAaquWJDhrvA0khKvg5po/https://upload-images.jianshu.io/upload_images/19073098-3febffa8e44a6e6f.png?imageMogr2/auto-orient/strip|imageView2/2/w/480/format/webp)

image.png

系统里有external.db数据库，该数据库里有files表，该表里存放着共享文件的诸多信息，如图片有宽高，经纬度、存放路径等，视频宽高、时长、存放路径等。而文件真正存放的地方在于共享存储空间。

**1、保存图片到相册**  
当App1保存图片到相册时，简单流程如下：

> 1、将路径信息写入数据库里，并获取Uri  
> 2、通过Uri构造输出流  
> 3、将该图片保存在/sdcard/Pictures/目录下

**2、从相册获取图片**  
当App2从相册获取图片时，简单流程如下：

> 1、先查询数据库，找到对应的图片Cursor  
> 2、从Cursor里构造Uri  
> 3、从Uri构造输入流读取图片

以上以图片为例简单分析了共享存储空间文件的写入与读取，实际上对于视频、音频步骤亦是如此。

## MediaStore作用

共享存储空间里存放着图片、视频、音频、下载的文件，App获取或者插入文件的时候怎么区分这些类型呢？  
这个时候就需要MediaStore，来看看MediaStore.java

  
![](https://proxy-prod.omnivore-image-cache.app/0x0,sEufyR4rzQyKwWhEYrE39QAVrczOuoUqFVjVY1Dn44nw/https://upload-images.jianshu.io/upload_images/19073098-22cc9b9a3015c714.png?imageMogr2/auto-orient/strip|imageView2/2/w/480/format/webp)

image.png

可以看出其内部有Audio、Images等内部类，这些内部类里记录着files表的各个字段名，通过构造这些参数就可以插入相应的字段值以及获取对应的字段值。  
MediaStore 实际上就是相当于给各个字段起了别名，我们编码的时候更容易记住与使用：

```stylus
//列举一些字段：
//图片类型
MediaStore.Images.Media.MIME_TYPE
//音频时长
MediaStore.Audio.Media.DURATION
//视频时长
MediaStore.Video.Media.DURATION
//等等，还有很多

```

### MediaStore和Uri联系

![](https://proxy-prod.omnivore-image-cache.app/0x0,s7HG14ytGeKu0L0pFNHhCVhNVMWD6J-tDObE0fJHUkNc/https://upload-images.jianshu.io/upload_images/19073098-c5fe81d83176dbcd.png?imageMogr2/auto-orient/strip|imageView2/2/w/480/format/webp)

image.png

比如想要查询共享存储空间里的图片文件：

```yaml
Cursor cursor = contentResolver.query(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, null, null, null, null);

```

MediaStore.Images.Media.EXTERNAL\_CONTENT\_URI 意思是指定查询文件的类型是图片，并构造成Uri对象，Uri实现了Parcelable，能够在进程间传递。  
接收方(另一个进程收到后)，匹配Uri，解析出对应的字段，进行具体的操作。  
当然，MediaStore是系统提供的方便操作共享存储空间的类，若是自己写ContentProvider，则也可以自定义类似MediaStore的类用来标记自己的数据库表的字段。

## 2、通过Uri读取和写入文件

既然不能通过路径直接访问文件，那么来看看如何通过Uri访问文件。在上篇文章里提到过：**Uri可以通过MediaStore或者SAF获取。**(此处需要注意的是：虽然也可以通过文件路径直接构造Uri，但是此种方式构造的Uri是没有权限访问文件的)  
先来看看通过SAF获取Uri。

## 从Uri读取文件

现在/sdcard/目录下存在一个文件名为：mytest.txt。

  
![](https://proxy-prod.omnivore-image-cache.app/0x0,sljRkRaGY041vPJrLoPNp-INR8lLzfvWaJl3USWMy-LQ/https://upload-images.jianshu.io/upload_images/19073098-14431be6cb8972dd.png?imageMogr2/auto-orient/strip|imageView2/2/w/480/format/webp)

image.png

该文件内容是：

  
![](https://proxy-prod.omnivore-image-cache.app/0x0,sNsfghPcy0cTjuemQB4AmrJgFeAurkRveZS1fIbp8-8U/https://upload-images.jianshu.io/upload_images/19073098-beacd630d58c06d7.png?imageMogr2/auto-orient/strip|imageView2/2/w/480/format/webp)

image.png

传统的直接读取mytest.txt方法：

```reasonml
    //从文件读取
    private void readFile(String filePath) {
        if (TextUtils.isEmpty(filePath))
            return;

        try {
            File file = new File(filePath);
            FileInputStream fileInputStream = new FileInputStream(file);
            BufferedInputStream bis = new BufferedInputStream(fileInputStream);
            byte[] readContent = new byte[1024];
            int readLen = 0;
            while (readLen != -1) {
                readLen = bis.read(readContent, 0, readContent.length);
                if (readLen > 0) {
                    String content = new String(readContent);
                    Log.d("test", "read content:" + content.substring(0, readLen));
                }
            }
            fileInputStream.close();
        } catch (Exception e) {

        }
    }

```

开启分区存储功能后，这种方法是不可取的，会报权限错误。  
而mytest.txt不属于共享存储空间的文件，是属于其它目录的，因此不能通过MediaStore获取，只能通过SAF获取，如下：

```reasonml
    private void startSAF() {
        Intent intent = new Intent(Intent.ACTION_OPEN_DOCUMENT);
        intent.addCategory(Intent.CATEGORY_OPENABLE);
        //指定选择文本类型的文件
        intent.setType("text/plain");
        startActivityForResult(intent, 100);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        if (requestCode == 100) {
            //选中返回的文件信息封装在Uri里
            Uri uri = data.getData();
            openUriForRead(uri);
        }
    }

```

拿到Uri后，用来构造输入流读取文件。

```reasonml
    private void openUriForRead(Uri uri) {
        if (uri == null)
            return;

        try {
            //获取输入流
            InputStream inputStream = getContentResolver().openInputStream(uri);
            byte[] readContent = new byte[1024];
            int len = 0;
            do {
                //读文件
                len = inputStream.read(readContent);
                if (len != -1) {
                    Log.d("test", "read content:" + new String(readContent).substring(0, len));
                }
            } while (len != -1);
            inputStream.close();
        } catch (Exception e) {
            Log.d("test", e.getLocalizedMessage());
        }
    }

```

最终输出：

  
![](https://proxy-prod.omnivore-image-cache.app/0x0,siwLsm8a6jUhB26hPtcYKcfMHyA79n-0_b7O-cHfGZO8/https://upload-images.jianshu.io/upload_images/19073098-2d29801e9d2b5c8d.png?imageMogr2/auto-orient/strip|imageView2/2/w/480/format/webp)

image.png

由此可以看出，mytest.txt属于"其它目录"下的文件，因此需要通过SAF访问，SAF返回Uri，通过Uri构造InputStream即可读取文件。

## 从Uri写入文件

继续来看看写的过程，现在需要往mytest.txt写入内容。  
同样的，还是需要通过SAF拿到Uri，拿到Uri后构造输出流：

```reasonml
    private void openUriForWrite(Uri uri) {
        if (uri == null) {
            return;
        }

        try {
            //从uri构造输出流
            OutputStream outputStream = getContentResolver().openOutputStream(uri);
            //待写入的内容
            String content = "hello world I'm from SAF\n";
            //写入文件
            outputStream.write(content.getBytes());
            outputStream.flush();
            outputStream.close();
        } catch (Exception e) {
            Log.d("test", e.getLocalizedMessage());
        }
    }

```

最后来看看文件是否写入成功，通过SAF再次读取mytest.txt，发现正好是之前写入的内容，说明写入成功。

## 3、通过Uri 获取图片和插入相册

上面列举出了其它目录下文件的读写，方法是通过SAF拿到Uri。  
SAF好处是：

> 系统提供了文件选择器，调用者只需要指定想要读写的文件类型，比如文本类型、图片类型、视频类型等，选择器就会过滤出相应文件以供选择。接入方便，选择简单。

想想另一种场景：

> 想要自己实现相册选择器，那么就需要获得共享存储空间下的文件信息。此种场景下使用SAF是无法做到的。

因此问题的关键是：**如何批量获得共享存储空间下图片/视频的信息？**  
答案是：ContentResolver+ContentProvider+MediaStore(ContentProvider对于调用者是透明的)。  
以图片为例，分析插入与查询方式。

## 插入相册

来看看图片的插入过程：

```reasonml
    //fileName为需要保存到相册的图片名
    private void insert2Album(InputStream inputStream, String fileName) {
        if (inputStream == null)
            return;

        ContentValues contentValues = new ContentValues();
        contentValues.put(MediaStore.Images.ImageColumns.DISPLAY_NAME, fileName);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            //RELATIVE_PATH 字段表示相对路径-------->(1)
            contentValues.put(MediaStore.Images.ImageColumns.RELATIVE_PATH, Environment.DIRECTORY_PICTURES);
        } else {
            String dstPath = Environment.getExternalStorageDirectory() + File.separator + Environment.DIRECTORY_PICTURES
                    + File.separator + fileName;
            //DATA字段在Android 10.0 之后已经废弃
            contentValues.put(MediaStore.Images.ImageColumns.DATA, dstPath);
        }

        //插入相册------->(2)
        Uri uri = getContentResolver().insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, contentValues);

        //写入文件------->(3)
        write2File(uri, inputStream);
    }

```

重点说明三个点：  
**(1)**  
Android 10.0之前，MediaStore.Images.ImageColumns.DATA 字段记录的是图片的绝对路径，而Android 10.0(含)之后，DATA 被废弃，取而代之的是使用MediaStore.Images.ImageColumns.RELATIVE\_PATH，表示相对路径。比如指定RELATIVE\_PATH为Environment.DIRECTORY\_PICTURES，表示之后的图片将会放到Environment.DIRECTORY\_PICTURES目录下。

**(2)**  
调用ContentResolver里的方法插入相册。  
MediaStore.Images.Media.EXTERNAL\_CONTENT\_URI 指的是插入图片表。  
ContentValues 以Map的形式记录了待写入的字段值。  
插入后返回Uri。

**(3)**  
以上两步仅仅只是往数据库里增加一条记录，该记录指向的新文件是空的，需要将图片写入到新文件。  
而新文件位于/sdcard/Pictures/目录下，该目录是不能直接通过路径访问的，因此需要通过第二步返回的Uri进行访问。

```arduino
    //uri 关联着待写入的文件
    //inputStream 表示原始的文件流
    private void write2File(Uri uri, InputStream inputStream) {
        if (uri == null || inputStream == null)
            return;

        try {
            //从Uri构造输出流
            OutputStream outputStream = getContentResolver().openOutputStream(uri);

            byte[] in = new byte[1024];
            int len = 0;

            do {
                //从输入流里读取数据
                len = inputStream.read(in);
                if (len != -1) {
                    outputStream.write(in, 0, len);
                    outputStream.flush();
                }
            } while (len != -1);

            inputStream.close();
            outputStream.close();

        } catch (Exception e) {
            Log.d("test", e.getLocalizedMessage());
        }
    }

```

可以看出，目标文件关联的Uri有了，还需要原始的输入文件。

测试上述的插入方法：

```reasonml
    private void testInsert() {

        String picName = "mypic.jpg";
        try {
            File externalFilesDir = getExternalFilesDir(null);
            File file = new File(externalFilesDir, picName);
            FileInputStream fis = new FileInputStream(file);
            insert2Album(fis, picName);
        } catch (Exception e) {
            Log.d("test", e.getLocalizedMessage());
        }
    }

```

其中，原始文件(图片)存放于自带外部存储-App私有目录，如下：

  
![](https://proxy-prod.omnivore-image-cache.app/0x0,suXts4N2cSJhLS-29YgnR2r-ds4qLDtPk_lQsvKB6jjQ/https://upload-images.jianshu.io/upload_images/19073098-9b3c18da5745d232.png?imageMogr2/auto-orient/strip|imageView2/2/w/480/format/webp)

image.png

需要注意的是：

> 1、读取原始文件需要权限，上述例子里的原始文件存放在自带外部存储-App私有目录，因此本App可以使用路径直接读取  
> 2、对于其他目录则依然需要构造Uri读取，如通过SAF获取Uri

## 获取图片

同样的，想要从系统相册中获取图片，也需要通过Uri访问。

```reasonml
    private void queryImageFromAlbum() {
        Cursor cursor = getContentResolver().query(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, null,
                null, null, null);

        if (cursor != null) {
            while (cursor.moveToNext()) {
                //获取唯一的id
                long id = cursor.getLong(cursor.getColumnIndexOrThrow(MediaStore.MediaColumns._ID));
                //通过id构造Uri
                Uri uri = ContentUris.withAppendedId(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, id);
                //解析uri
                decodeUriForBitmap(uri);
            }
        }
    }

    private void decodeUriForBitmap(Uri uri) {
        if (uri == null)
            return;

        try {
            //构造输入流
            InputStream inputStream = getContentResolver().openInputStream(uri);
            //解析Bitmap
            Bitmap bitmap = BitmapFactory.decodeStream(inputStream);
            if (bitmap != null)
                Log.d("test", "bitmap width-width:" + bitmap.getWidth() + "-" + bitmap.getHeight());
        } catch (Exception e) {
            Log.d("test", e.getLocalizedMessage());
        }
    }

```

与插入相册过程类似，同样需要拿到Uri，再构造输入流，从输入流读取文件(图片内容)。

以上，通过Uri 获取图片和插入相册分析完毕，共享存储空间的其他文件类型如视频、音频、下载文件也是同样的流程。  
需要说明的是上述的ContentResolver .insert(xx)/ContentResolver.query(xx) 的参数取值还可以更丰富，但不是本篇重点，因此忽略了，实际使用过程中具体情况具体分析。

## 4、Android 11.0 权限申请

通过Uri访问文件似乎已经满足了Android 10.0适配要求，但是仔细想想还是有不足之处：

> 1、共享存储空间只能通过MediaStore访问，以前流行的访问方式是直接通过路径访问。比如自己做的相册管理器，先遍历相册拿到图片/视频的路径，然后再解析成Bitmap展示，现在需要先拿到Uri，再解析成Bitmap，多少有些不方便。此外，也许你依赖的第三方库是直接通过路径访问文件的，而三方库又没有及时更新适配分区存储，可能就会导致用不了相应的功能。  
> 2、SAF虽然能够访问其它目录的文件，但是每次都需要跳转到新的页面去选择，当想要批量展示文件的时候，比如自己做的文件管理器，就需要列出当前目录下有哪些目录/文件，这个时候需要有权限遍历/sdcard/目录。显然，SAF并不能胜任此工作。

Android 11.0考虑到上面的问题，因此做了新的优化。

## 共享存储空间-媒体文件访问变更

媒体文件可以通过路径直接访问：

```reasonml
    private void getImagePath(Context context) {
        ContentResolver contentResolver = context.getContentResolver();
        Cursor cursor = contentResolver.query(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, null, null, null, null);
        while (cursor.moveToNext()) {

            try {
                //取出路径
                String path = cursor.getString(cursor.getColumnIndex(MediaStore.Images.ImageColumns.DATA));
                Bitmap bitmap = BitmapFactory.decodeFile(path);
            } catch (Exception e) {
                Log.d("test", e.getLocalizedMessage());
            }
            break;
        }
    }

```

可以看出，之前在Android 10.0上被禁用的访问方式，在Android 11.0上又被允许了，这就解决了上面的第一个问题。  
_需要注意的是：此种方式只允许读文件，写文件依然不行_

Google 官方指导意见是：

> 虽然可以通过路径直接访问媒体文件，但是这些操作最终是被重定向到MediaStore API的，重定向过程可能会损耗一些性能，并且直接通过路径访问不一定比MediaStore API 访问快。  
> 总之建议非必要的话不要直接使用路径访问。

## 访问所有文件

假若App开启了分区存储功能，当App运行在Android 10.0的设备上时，是没法遍历/sdcard/目录的。而在Android 11.0上运行时是可以遍历的，需要进行如下几个步骤。

### 1、声明管理权限

在AndroidManifest.xml添加权限声明

```applescript
<uses-permission android:name="android.permission.MANAGE_EXTERNAL_STORAGE" />

```

### 2、动态申请所有文件访问权限

```reasonml
    private void testAllFiles() {
        //运行设备>=Android 11.0
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            //检查是否已经有权限
            if (!Environment.isExternalStorageManager()) {
                //跳转新页面申请权限
                startActivityForResult(new Intent(Settings.ACTION_MANAGE_ALL_FILES_ACCESS_PERMISSION), 101);
            }
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        //申请权限结果
        if (requestCode == 101) {
            if (Environment.isExternalStorageManager()) {
                Toast.makeText(MainActivity.this, "访问所有文件权限申请成功", Toast.LENGTH_SHORT).show();

                 //遍历目录
                showAllFiles();
            }
        }
    }

```

此处申请权限不是以对话框的形式提示用户，而是跳转到新的页面，说明该权限的管理更严格。

### 3、遍历目录、读写文件

拥有权限后，就可以进行相应的操作了。

```reasonml
    private void showAllFiles() {
        File file = Environment.getExternalStorageDirectory();
        File[] list = file.listFiles();
        for (int i = 0; i < list.length; i++) {
            String name = list[i].getName();
            Log.d("test", "fileName:" + name);
        }
    }

```

文件管理器效果图类似如下：

  
![](https://proxy-prod.omnivore-image-cache.app/0x0,sJxUkekMxI-HVzcsT6Vska34sIUW9jsm1yaHNyedZEiA/https://upload-images.jianshu.io/upload_images/19073098-87c48471efd0640d.png?imageMogr2/auto-orient/strip|imageView2/2/w/544/format/webp)

image.png

当然读写文件也不在话下了，比如往/sdcard/目录下写入文件：

```reasonml
    private void testPublicFile() {
        File rootFile = Environment.getExternalStorageDirectory();
        try {
            File file = new File(rootFile, "mytest.txt");
            FileOutputStream fos = new FileOutputStream(file);
            String content = "hello world\n";
            fos.write(content.getBytes());
            fos.flush();
            fos.close();
        } catch (Exception e) {
            Log.d("test", e.getLocalizedMessage());
        }
    }

```

ACTION\_MANAGE\_ALL\_FILES\_ACCESS\_PERMISSION 这个权限的名字看起来很唬人，感觉就像是能够操作所有文件的样子，这不就是打破了分区存储的规则了吗？其实不然：

> 即使拥有了该权限，依然不能访问内部存储和外部存储-App私有目录

需要说明的是：

> 1、Environment.isExternalStorageManager()、Build.VERSION\_CODES.R 等需要编译版本>=30才能编译通过。  
> 2、Google 提示当使用MANAGE\_EXTERNAL\_STORAGE 申请权限时，并且targetSdkVersion>=30，此种情况下App被禁止上架Google Play的，限制时间最早到2021年。因此，在此时间之前若是申请了MANAGE\_EXTERNAL\_STORAGE权限，最好不要升级targetSdkVersion到30以上。

## 5、Android 10/11 存储适配建议

好了，通过分析Android 10/11存储适配方式，了解到了不同的系统需要如何进行适配，此时就需要一个统一的适配方案了。

## 适配核心

分区存储是核心，App自身产生的文件应该存放在自己的目录下：

> /sdcard/Android/data/packagename/ 和/data/data/packagename/

这两个目录本App无需申请访问权限即可申请，其它App无法访问本App的目录。

## 适配共享存储

共享存储空间里的文件需要通过Uri构造输入输出流访问，Uri获取方式有两种：MediaStore和SAF。

## 适配其它目录

在Android 11上需要申请访问所有文件的权限。

## 具体做法

### 第一步

在AndroidManifest.xml里添加如下字段：  
权限声明：

```applescript
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.MANAGE_EXTERNAL_STORAGE" />

```

在<application/>标签下添加如下字段：

```avrasm
android:requestLegacyExternalStorage="true"

```

### 第二步

如果需要访问共享存储空间，则判断运行设备版本是否大于等于Android6.0，若是则需要申请WRITE\_EXTERNAL\_STORAGE 权限。拿到权限后，通过Uri访问共享存储空间里的文件。  
如果需要访问其它目录，则通过SAF访问

### 第三步

如果想要做文件管理器、病毒扫描管理器等功能。则判断运行设备版本是否大于等于Android 6.0，若是先需要申请普通的存储权。若运行设备版本为Android 10.0，则可以直接通过路径访问/sdcard/目录下文件(因为禁用了分区存储)；若运行设备版本为Android 11.0，则需要申请MANAGE\_EXTERNAL\_STORAGE 权限。

以上是Android 存储权限适配的全部内容。

本篇基于Android 10.0 11.0 。 Android 10.0真机、Android 11.0模拟器  
[测试代码](https://links.jianshu.com/go?to=https%3A%2F%2Fgithub.com%2Ffishforest%2FAndroidDemo%2Ftree%2Fmain%2Fapp%2Fsrc%2Fmain%2Fjava%2Fcom%2Fexample%2Fandroiddemo%2Fstoragepermission)

**下个系列文章：线程&锁相关知识。**

## 您若喜欢，请点赞、关注，您的鼓励是我前进的动力

## 持续更新中，和我一起步步为营系统、深入学习Android

最后编辑于 

：2021.10.29 23:47:47

更多精彩内容，就在简书APP

![](https://proxy-prod.omnivore-image-cache.app/0x0,ssZHWbgO_k0I357c8G6PpFVv8dLafmqrELL88wvzAvkg/https://upload.jianshu.io/images/js-qrc.png)

"小礼物走一走，来简书关注我"

还没有人赞赏，支持一下

[![  ](https://proxy-prod.omnivore-image-cache.app/0x0,sHzSJelSAx9eQgylra4V3pmhWucKwieLCg5wwa4gKda0/https://upload.jianshu.io/users/upload_avatars/19073098/e8fff55d-a484-4b46-88dc-254e8e7852ed.jpeg?imageMogr2/auto-orient/strip|imageView2/1/w/100/h/100/format/webp)](https://www.jianshu.com/u/c3187f5a9eb1)

[小鱼人爱编程](https://www.jianshu.com/u/c3187f5a9eb1 "小鱼人爱编程")[![  ](https://proxy-prod.omnivore-image-cache.app/0x0,sIPowcq6NZWmBsxZajPExXxjPLjS738WlwLylpEb-2U8/https://upload.jianshu.io/user_badge/19c2bea4-c7f7-467f-a032-4fed9acbc55d)](https://www.jianshu.com/mobile/creator)源码面前无秘密，大前端知识持续输出中...<br>github:<a href="https:...

总资产67共写了30.5W字获得361个赞共835个粉丝

* 序言：七十年代末，一起剥皮案震惊了整个滨河市，随后出现的几起案子，更是在滨河造成了极大的恐慌，老刑警刘岩，带你破解...
* 序言：滨河连续发生了三起死亡事件，死亡现场离奇诡异，居然都是意外死亡，警方通过查阅死者的电脑和手机，发现死者居然都...
* 文/潘晓璐 我一进店门，熙熙楼的掌柜王于贵愁眉苦脸地迎上来，“玉大人，你说我怎么就摊上这事。” “怎么了？”我有些...
* 文/不坏的土叔 我叫张陵，是天一观的道长。 经常有香客问我，道长，这世上最难降的妖魔是什么？ 我笑而不...
* 正文 为了忘掉前任，我火速办了婚礼，结果婚礼上，老公的妹妹穿的比我还像新娘。我一直安慰自己，他们只是感情好，可当我...  
[![](https://proxy-prod.omnivore-image-cache.app/0x0,sWzbpenrkgtY2_WJ-wX8LlOh1f9kI_5M1dMSLPV7bPxo/https://upload.jianshu.io/users/upload_avatars/4790772/388e473c-fe2f-40e0-9301-e357ae8f1b41.jpeg?imageMogr2/auto-orient/strip|imageView2/1/w/48/h/48/format/webp)茶点故事](https://www.jianshu.com/u/0f438ff0a55f)阅读 22,088评论 0赞 144
* 文/花漫 我一把揭开白布。 她就那样静静地躺着，像睡着了一般。 火红的嫁衣衬着肌肤如雪。 梳的纹丝不乱的头发上，一...
* 那天，我揣着相机与录音，去河边找鬼。 笑死，一个胖子当着我的面吹牛，可吹牛的内容都是我干的。 我是一名探鬼主播，决...
* 文/苍兰香墨 我猛地睁开眼，长吁一口气：“原来是场噩梦啊……” “哼！你这毒妇竟也来了？” 一声冷哼从身侧响起，我...
* 想象着我的养父在大火中拼命挣扎，窒息，最后皮肤化为焦炭。我心中就已经是抑制不住地欢快，这就叫做以其人之道，还治其人...
* 序言：老挝万荣一对情侣失踪，失踪者是张志新（化名）和其女友刘颖，没想到半个月后，有当地人在树林里发现了一具尸体，经...
* 正文 独居荒郊野岭守林人离奇死亡，尸身上长有42处带血的脓包…… 初始之章·张勋 以下内容为张勋视角 年9月15日...  
[![](https://proxy-prod.omnivore-image-cache.app/0x0,sWzbpenrkgtY2_WJ-wX8LlOh1f9kI_5M1dMSLPV7bPxo/https://upload.jianshu.io/users/upload_avatars/4790772/388e473c-fe2f-40e0-9301-e357ae8f1b41.jpeg?imageMogr2/auto-orient/strip|imageView2/1/w/48/h/48/format/webp)茶点故事](https://www.jianshu.com/u/0f438ff0a55f)阅读 10,900评论 1赞 126
* 正文 我和宋清朗相恋三年，在试婚纱的时候发现自己被绿了。 大学时的朋友给我发了我未婚夫和他白月光在一起吃饭的照片。...  
[![](https://proxy-prod.omnivore-image-cache.app/0x0,sWzbpenrkgtY2_WJ-wX8LlOh1f9kI_5M1dMSLPV7bPxo/https://upload.jianshu.io/users/upload_avatars/4790772/388e473c-fe2f-40e0-9301-e357ae8f1b41.jpeg?imageMogr2/auto-orient/strip|imageView2/1/w/48/h/48/format/webp)茶点故事](https://www.jianshu.com/u/0f438ff0a55f)阅读 11,710评论 0赞 129
* 白月光回国，霸总把我这个替身辞退。还一脸阴沉的警告我。\[不要出现在思思面前， 不然我有一百种方法让你生不如死。\]我...
* 序言：一个原本活蹦乱跳的男人离奇死亡，死状恐怖，灵堂内的尸体忽然破棺而出，到底是诈尸还是另有隐情，我是刑警宁泽，带...
* 正文 年R本政府宣布，位于F岛的核电站，受9级特大地震影响，放射性物质发生泄漏。R本人自食恶果不足惜，却给世界环境...  
[![](https://proxy-prod.omnivore-image-cache.app/0x0,sWzbpenrkgtY2_WJ-wX8LlOh1f9kI_5M1dMSLPV7bPxo/https://upload.jianshu.io/users/upload_avatars/4790772/388e473c-fe2f-40e0-9301-e357ae8f1b41.jpeg?imageMogr2/auto-orient/strip|imageView2/1/w/48/h/48/format/webp)茶点故事](https://www.jianshu.com/u/0f438ff0a55f)阅读 12,452评论 3赞 124
* 文/蒙蒙 一、第九天 我趴在偏房一处隐蔽的房顶上张望。 院中可真热闹，春花似锦、人声如沸。这庄子的主人今日做“春日...
* 文/苍兰香墨 我抬头看了看天上的太阳。三九已至，却和暖如春，着一层夹袄步出监牢的瞬间，已是汗流浃背。 一阵脚步声响...
* 我被黑心中介骗来泰国打工， 没想到刚下飞机就差点儿被人妖公主榨干…… 1\. 我叫王不留，地道东北人。 一个月前我还...
* 正文 我出身青楼，却偏偏与公主长得像，于是被迫代替她去往敌国和亲。 传闻我的和亲对象是个残疾皇子，可洞房花烛夜当晚...  
[![](https://proxy-prod.omnivore-image-cache.app/0x0,sWzbpenrkgtY2_WJ-wX8LlOh1f9kI_5M1dMSLPV7bPxo/https://upload.jianshu.io/users/upload_avatars/4790772/388e473c-fe2f-40e0-9301-e357ae8f1b41.jpeg?imageMogr2/auto-orient/strip|imageView2/1/w/48/h/48/format/webp)茶点故事](https://www.jianshu.com/u/0f438ff0a55f)阅读 13,563评论 2赞 130

### 被以下专题收入，发现更多相似内容

### 推荐阅读[更多精彩内容](https://www.jianshu.com/)

* 前言 存储适配系列文章： Android-存储基础\[https://www.jianshu.com/p/cf611...
* Android 10（API 级别 29）引入了多项功能和行为变更，目的是更好地保护用户的隐私权。其中最重要的变化...
* 本文档基于谷歌Android 11 Developer Preview 4（DP4）版本的变更输出，后续Beta版...
* 作者：fishforest 链接：https://www.jianshu.com/p/d5573e312bb8 先...
* 今天青石的票圈出镜率最高的，莫过于张艺谋的新片终于定档了。 一张满溢着水墨风的海报一次次的出现在票圈里，也就是老谋...  
[![](https://proxy-prod.omnivore-image-cache.app/0x0,sbSGAju2Uv2xOwawpQKYNuPxiAgP-XrR_t8_g40A6Oag/https://cdn2.jianshu.io/assets/default_avatar/2-9636b13945b9ccf345bc98d0d81074eb.jpg)青石电影](https://www.jianshu.com/u/aa52975c0a31)阅读 10,090评论 1赞 3

---

