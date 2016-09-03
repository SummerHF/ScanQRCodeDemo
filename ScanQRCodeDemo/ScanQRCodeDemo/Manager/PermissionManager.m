//
//  PermissionManager.m
//  loveOil
//
//  Created by swift on 8/11/16.
//  Copyright © 2016 macbookair. All rights reserved.
//

#import "PermissionManager.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

@implementation PermissionManager

#pragma mark - manager

+(instancetype)manager
{
    
    static PermissionManager * manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[PermissionManager alloc] init];
    
    });
    
    return manager;
}

#pragma mark - 获得相机的访问权限

-(void)getCameraPermisson:(success)successBlock
{
    
    //1.ios7之前默认拥有权限
    
    if(IS_IOS_VERSION >= 7.0)
    {
        
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        
        if (authStatus == AVAuthorizationStatusDenied)
        {

            return;
        }
    }
   

    successBlock();
    
    
}

-(void)getCameraPermissonSuccessBlock:(success)successBlock failureBlock:(failure)failureBlock
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    switch (authStatus) {
            //1.未决定
        case AVAuthorizationStatusNotDetermined:
        {
            //2.申请权限
            
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                
                if (granted) {
                    
                    successBlock();
                }
                else
                {
                    failureBlock();
                }
                
            }];
            
            break;
        }
            
            //3.授权失败
        case AVAuthorizationStatusDenied:
            
            failureBlock();
            
            break;
            
            //4.成功授权
            
        case AVAuthorizationStatusAuthorized:
            
            successBlock();
            
            break;
            
        default:
            break;
    }
}

@end
