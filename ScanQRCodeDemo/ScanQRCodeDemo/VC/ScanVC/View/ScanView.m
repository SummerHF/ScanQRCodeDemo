//
//  ScanView.m
//  loveOil
//
//  Created by macbookair on 9/3/16.
//  Copyright © 2016 macbookair. All rights reserved.
//

#import "ScanView.h"

#import "ScanLoadingView.h"

@interface ScanView ()<AVCaptureMetadataOutputObjectsDelegate>

/**
 *  扫描区域
 */
@property (nonatomic, strong) UIImageView * scView;

/**
 *  动画视图--扫描线
 */
@property (nonatomic, strong) UIImageView * animatorView;


/**
 *  创建设备会话对象
 */
@property (nonatomic, strong) AVCaptureSession * session;

/**
 *  预览视图
 */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer * previewLayer;


/**
 *  获取摄像设备
 */
@property (nonatomic, strong) AVCaptureDevice * captureDevice;

/**
 *  输入流
 */
@property (nonatomic, strong) AVCaptureDeviceInput * captureInput;

/**
 *  输出流
 */
@property (nonatomic, strong) AVCaptureMetadataOutput * medataOutPut;

/**
 *  中间视图MaskView
 */
@property (nonatomic, strong) UIView * tempCenterMaskView;

/**
 *  对准二维码,进行扫码
 */
@property (nonatomic, strong) UILabel * indicatorLable;

/**
 *  菊花视图
 */
@property (nonatomic, strong) ScanLoadingView * loadingView;



@end


@implementation ScanView

static CGFloat durationTime = 2;

#pragma mark - lazy method

-(UIImageView *)scView
{
    if (!_scView) {
        
        //1.默认的背景图片
        
        _scView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scan_view"]];
        
#warning 尺寸最好根据机型适配下-此处就不做了
        
        _scView.size = CGSizeMake(200, 200);
        
        _scView.center = self.center;
        
        _scView.backgroundColor = CLEARCOLOR;
        
    }
    
    return _scView;
}

-(UIImageView *)animatorView
{
    if (!_animatorView) {
        
        _animatorView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scan_line"]];
        
        
        [self addSubview:_animatorView];
    }
    
    return _animatorView;
}

/**
 *  输出预览区域
 *
 *
 */
-(AVCaptureVideoPreviewLayer *)previewLayer
{
    if (!_previewLayer) {
        
        _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
        
        //1. 扫码预览视图的大小
        
        _previewLayer.frame = self.bounds;
        
        _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        
        _previewLayer.backgroundColor = BLACKCOLOR.CGColor;
        
    }
    
    return _previewLayer;
}


/**
 *
 * 捕获设备
 */
-(AVCaptureDevice *)captureDevice
{
    if (!_captureDevice) {
        
        _captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        //闪光灯
        
        if ([_captureDevice hasFlash] && [_captureDevice hasTorch]) {
            
            [_captureDevice lockForConfiguration:nil];
            
            if ([_captureDevice isFlashModeSupported:AVCaptureFlashModeAuto]) {
                
                [_captureDevice setFlashMode:AVCaptureFlashModeAuto];
            }
            
            if ([_captureDevice isTorchModeSupported:AVCaptureTorchModeAuto]) {
                
                [_captureDevice setTorchMode:AVCaptureTorchModeAuto];
            }
            
            [_captureDevice unlockForConfiguration];
        }
        
    }
    
    return _captureDevice;
}


/**
 *
 *
 *  输入源
 */
-(AVCaptureDeviceInput *)captureInput
{
    if (!_captureInput) {
        
        
        NSError * error = nil;
        
        _captureInput = [AVCaptureDeviceInput deviceInputWithDevice:self.captureDevice error:&error];
        
        NSAssert(!error, @"请到真机上调试");
    }
    
    return _captureInput;
}

/**
 *  输出源
 *
 */
-(AVCaptureMetadataOutput *)medataOutPut
{
    if (!_medataOutPut) {
        
        _medataOutPut = [[AVCaptureMetadataOutput alloc] init];
        
        [_medataOutPut setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
    }
    
    return _medataOutPut;
}

/**
 *
 * 文字
 */

-(UILabel *)indicatorLable
{
    if (!_indicatorLable) {
        
        _indicatorLable = [[UILabel alloc] init];
        
        [_indicatorLable setText:@"对准二维码,进行扫码" color:WHITECOLOR fontSize:Default_Font_Small_Size];
    }
    
    return _indicatorLable;
}



#pragma mark - initialize

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        
      //1.访问权限判断
        
        [self getPermissonToAccseeVidio];
        
    }
    
    
    return self;
}


#pragma mark - sub method

/**
 *  访问权限判断
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

/**
 *  成功获得访问权限
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

/**
 *  未成功获得权限
 */
-(void)failureGetPermisson
{
    if ([self.delegate respondsToSelector:@selector(doNotGetPermissionToCamera)]) {
        
        [self.delegate doNotGetPermissionToCamera];
    }
}

-(void)addScanView
{
    
    [self addSubview:self.scView];

}

/**
 *  初始化session
 */
-(void)initSessionAbout
{
   
    //1.初始化session
    
    self.session = [[AVCaptureSession alloc] init];
    
    self.session.sessionPreset = AVCaptureSessionPresetHigh;
    
    //2.初始化捕获设备并加入session
    
    if (self.captureInput) {
        
        //1.添加输入源
        
        [_session addInput:self.captureInput];
        
        
        if (self.medataOutPut) {
            
            //2.添加输出源
            
           [_session addOutput:self.medataOutPut];
            
            //3.设置扫码类型(更具需要自定制)
            
            self.medataOutPut.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
        }
    
        
        //3.预览视图
    
        [self.layer insertSublayer:self.previewLayer above:0];
        
        [self bringSubviewToFront:self.scView];
        
        
        //4.设置扫码区域
        
        [self.medataOutPut setRectOfInterest:[self setRectWithScView:self.scView.frame]];
        
        //5.开始session

        [_session startRunning];
        
    }

}

/**
 *  设置自动聚焦区域
 *
 *  @param scView 扫码区域
 */
-(CGRect)setRectWithScView:(CGRect)scViewRect
{
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    CGFloat x = (height - CGRectGetHeight(scViewRect))/2/height;
    CGFloat y = (width - CGRectGetWidth(scViewRect))/2/width;
    
    CGFloat w = CGRectGetHeight(scViewRect)/height;
    CGFloat h = CGRectGetWidth(scViewRect)/width;
    
    return CGRectMake(x, y, w, h);
    
}

/**
 *  添加遮罩
 *
 *  @param scView 扫码区域
 */
-(void)addMaskView:(UIView *)scView
{
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    CGFloat x = scView.x;
    CGFloat y = scView.y;
    
    CGFloat w = scView.width;
    CGFloat h = scView.height;
    
    //1.扫码区域四周的maskView
    
    [self addSubViews:CGRectMake(0, 0, width, y)];
    [self addSubViews:CGRectMake(0, y + h, width, height - y)];
    [self addSubViews:CGRectMake(0, y, x, h)];
    [self addSubViews:CGRectMake(x + w, y, x, h)];
    
    //2.中间区域的tempMaskView
    
    self.tempCenterMaskView = [[UIView alloc] initWithFrame:CGRectMake(x, y, w, h)];
    
    self.tempCenterMaskView.backgroundColor = [UIColor blackColor];
    
    self.tempCenterMaskView.alpha = 0.6;
    
    [self addSubview:self.tempCenterMaskView];
}

/**
 *
 * 扫码区域四周的maskView
 */
-(void)addSubViews:(CGRect)frame
{
    CGFloat alpha = 0.6;
    UIView *view = [[UIView alloc]initWithFrame:frame];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = alpha;
    [self addSubview:view];
}

-(void)addScanLine
{
    //1.扫描线
    
    [self addSubview:self.indicatorLable];
    
    self.indicatorLable.centerX = self.scView.centerX;
    
    self.indicatorLable.y = CGRectGetMaxY(self.scView.frame)+25;
}

/**
 *  开始扫码动画
 */
-(void)startScanAnimate
{
    
    self.scView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    self.indicatorLable.transform = CGAffineTransformMakeScale(0.01, 0.01);
    //1.扫描区域视图动画效果--视图缩放
    
    @weakify(self)
    
    
    [UIView animateWithDuration:0.5 animations:^{
        
        @strongify(self)
        
        self.tempCenterMaskView.alpha = 0.0;
        
        self.scView.transform = CGAffineTransformIdentity;
        
        self.indicatorLable.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
        
        @strongify(self)
        
        [self.tempCenterMaskView removeFromSuperview];
        
        //2.扫描区域中心线---上下动画效果
        [self centerLineAnimate];
        
    }];
    
    
    
}

-(void)centerLineAnimate
{
    CGFloat x = CGRectGetMinX(self.scView.frame);
    CGFloat y = CGRectGetMinY(self.scView.frame);
    CGFloat w = CGRectGetWidth(self.scView.frame);
    CGFloat h = CGRectGetHeight(self.scView.frame);
    
    CGRect startFrame = CGRectMake(x, y, w, 2);
    CGRect endFrame = CGRectMake(x, y + h - 2, w, 2);
    
    self.animatorView.frame = startFrame;
    
    @weakify(self)
    
    [UIView animateWithDuration:durationTime animations:^{
        
        @strongify(self)
        
        self.animatorView.frame = endFrame;
        
    } completion:^(BOOL finished) {
        
        @strongify(self)
        
        [self centerLineAnimate];
    }];
    
}

/**
 *  开始扫描
 */
- (void)startScan{
    
    self.animatorView.hidden = NO;
    
    [self.session startRunning];
}

/**
 *  停止扫描
 */

- (void)stopScan{
    
     self.animatorView.hidden = YES;
    
     [self.session stopRunning];
}

/**
 *  加载菊花时图
 */
-(void)showLoadingView
{

    self.loadingView = [[ScanLoadingView alloc] initWithFrame:CGRectMake(0, 0, 100, 100) andTitle:@"加载中"];
    
    [KEY_WINDOW addSubview:self.loadingView];
    
    self.loadingView.center = KEY_WINDOW.center;
    
}

/**
 *  移除菊花时图
 */
-(void)dismissLoadingView
{
    [self.loadingView removeFromSuperview];
    
    self.loadingView = nil;
}


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


-(void)dealloc
{
    NSLog(@"看一下是否有循环引用");
}


@end
