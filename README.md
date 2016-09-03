![ always trust your self ](http://upload-images.jianshu.io/upload_images/1622863-5f0a2b4905864532.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)



# MyZone 
* [My blog](http://summerhf.github.io/)
* [My csdn url ](http://blog.csdn.net/zhuhaifei391565521)


##  先看效果图

![效果演示](http://upload-images.jianshu.io/upload_images/1622863-6dee7855a8ac27e7.gif?imageMogr2/auto-orient/strip)

> 录制gif好蛋疼,不是很流畅,扫描区域的动画效果(由小变大)没有体现出来.有兴趣的可以研究下源码.😢😢😢😢



## notice

>注意关于生成二维码的,因为不是本篇文章的重点,所以不多提.项目中有一个生成二维码的`UIImage+GenerateQRCode`的分类,几乎涵盖了常见的二维码样式.直接拖过去用就可以了,提供如下方法

```
/**
 *  根据具体的内容生成二维码 //例如网址
 *
 *  @param contens 内容
 *
 *  @return 二维码图片
 */

+(nullable UIImage *)generateQRCodeViaContents:(nonnull NSString * )contens;

/**
 *  根据内容 和 尺寸生成相应的二维码
 *
 *  @param contens    内容
 *  @param QRCodeSize 正方形/只需要指定一个值即可
 *
 *  @return 二维码图片
 */

+(nullable UIImage *)generateQRCodeViaContents:(nonnull NSString *)contens withQRCodeSize:(CGFloat)QRCodeSize;

/**
 *  根据内容 尺寸 和 颜色生成二维码
 *
 *  @param contens    内容
 *  @param QRCodeSize 正方形/只需要指定一个值即可
 *  @param red
 *  @param green
 *  @param blue
 *  颜色不可以太接近白色
 *  @return   二维码图片
 */

+(nullable UIImage *)generateQRCodeViaContents:(nonnull NSString *)contens withQRCodeSize:(CGFloat)QRCodeSize forColorRed:(CGFloat)red colorGreen:(CGFloat)green colorBlue:(CGFloat)blue;

/**
 *  根据内容 尺寸 和 颜色 以及中心图片生成
 *  @param contens    内容
 *  @param QRCodeSize 正方形/只需要指定
 *  @param centerIMG  中心图片
 *  @return 二维码图片
 *  @param red        
 *  @param green      
 *  @param blue
 *
 *  @return 二维码图片
 */

+(nullable UIImage *)generateQRCodeViaContents:(nonnull NSString *)contens withQRCodeSize:(CGFloat)QRCodeSize withCenterImg:(nonnull UIImage *)centerIMG forColorRed:(CGFloat)red colorGreen:(CGFloat)green colorBlue:(CGFloat)blue;
```
## 项目目录结构

![Screen Shot 2016-09-03 at 9.48.21 PM.png](http://upload-images.jianshu.io/upload_images/1622863-79b6131912db14c9.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

> 因为是个小demo,所以就随便分了下文件夹,重点放在ScanVC就可以了.

* 其中最重要的就是scanView了,看看他都有哪些属性

```
/**
 *  扫描区域
 */
@property (nonatomic, strong) UIImageView * scView;

/**
 *  动画视图--扫描线
 */
@property (nonatomic, strong) UIImageView * animatorView;

/**
 *  创建设备会话对象
 */
@property (nonatomic, strong) AVCaptureSession * session;

/**
 *  预览视图
 */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer * previewLayer;

/**
 *  获取摄像设备
 */
@property (nonatomic, strong) AVCaptureDevice * captureDevice;

/**
 *  输入流
 */
@property (nonatomic, strong) AVCaptureDeviceInput * captureInput;

/**
 *  输出流
 */
@property (nonatomic, strong) AVCaptureMetadataOutput * medataOutPut;

/**
 *  中间视图MaskView
 */
@property (nonatomic, strong) UIView * tempCenterMaskView;

/**
 *  对准二维码,进行扫码
 */
@property (nonatomic, strong) UILabel * indicatorLable;

/**
 *  菊花视图
 */
@property (nonatomic, strong) ScanLoadingView * loadingView;
```

> 上述视图大部分通过`懒加载`方式进行加载,但是注意`AVCaptureSession`属性如果通过懒加载的方式，结果就是二维码怎么也扫不出来，我至今也不明白为啥不行,有知道的朋友麻烦不吝赐教了😊😊. 因为比较简单,如果需要自定义样式的话,按图索骥自行替换就可.



## ScanView的主要代码

* 初始化部分

``` 
#pragma mark - initialize

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        
      //1.访问权限判断
        
        [self getPermissonToAccseeVidio];
        
    }
    
    return self;
}
```

> 首先当然是`访问权限`的判断了,用户`同意授权`以及`不同意授权`所对应的事件要清晰

* 授权部分代码

```
/**
 *  访问权限判断
 */

-(void)getPermissonToAccseeVidio
{
    
    @weakify(self)
    
    //1.成功与否 都回到主线程更新ui操作
    
    [[PermissionManager manager] getCameraPermissonSuccessBlock:^{
        
        kDISPATCH_MAIN_THREAD(^{
           
            @strongify(self)
            
             [self successGetPermisson];
        });
        
    } failureBlock:^{
        
        kDISPATCH_MAIN_THREAD(^{
            
            @strongify(self)
            
            [self failureGetPermisson];
        });
        
    }];
    
}

```
> 通过单例的方式,管理整个项目的授权相关,并通过`block`回调的方式来做出对应的处理


* 成功获得授权

```
/*
 *  成功获得访问权限
 */
-(void)successGetPermisson
{
    //1.添加扫描视图
    
    
    [self addScanView];
    
    
    //2.初始化session
    
    [self initSessionAbout];
    
    
    //3.添加遮罩效果
    
    [self addMaskView:self.scView];
    
    //4.添加扫描线
    
    [self addScanLine];
    
    //5.开始动画效果
    
    [self startScanAnimate];
}
```
* 未获得授权

```
/**
 *  未成功获得权限
 */
-(void)failureGetPermisson
{
    if ([self.delegate respondsToSelector:@selector(doNotGetPermissionToCamera)]) {
        
        [self.delegate doNotGetPermissionToCamera];
    }
}
```
> 此处通过代理回调给控制器,弹出时图,诱导用户给予权限

* 扫描结果的处理

```
#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    //1.播放系统提示音
    
    [SoundManager playSystemSound];
    
    if (metadataObjects.count>0) {
        
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects firstObject];
        
       @weakify(self)
        
        kDISPATCH_MAIN_THREAD(^{
           
            @strongify(self)
            
            //2.停止扫描
            [self stopScan];
    
            //3.显示菊花
            [self showLoadingView];
            
        });
    
#warning 一般在此处发送网络请求 此处做延时处理
        //3.发送网络请求
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            @strongify(self)
            //4.移除菊花
            
            [self dismissLoadingView];
            
            if ([self.delegate respondsToSelector:@selector(getScanResult:)]) {
                
                [self.delegate getScanResult:metadataObject.stringValue];
            }
            
        });
   
       
    }
}
```

* 关于扫描后播放的提示音,可自行定制

```
+(void)playSystemSound
{

   // 1007 是短信提示音
    SystemSoundID soundID = 1007;
    
    AudioServicesPlaySystemSound(soundID);
}

```
> 很详细,此处就不再赘述了.详情见代码


##notice
>1.以上代码仅供参考,如果有任何你觉得不对的地方，都可以联系我,我会第一时间回复，谢谢.
>qq:`391565521`  email:`zhuhaifei_ios@163.com`

>持续完善中，敬请期待.......
