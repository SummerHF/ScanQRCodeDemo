//
//  PermissionManager.h
//  loveOil
//
//  Created by swift on 8/11/16.
//  Copyright © 2016 macbookair. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^success)();

typedef void(^failure)();

@interface PermissionManager : NSObject

/**
 *  统一管理授权相关的实例
 *
 *  @return 实例
 */
+(instancetype)manager;



/**
 *  获得相机的权限
 *  内部统一处理授权失败时的情况
 *  @param successBlock 成功的回调
 */
-(void)getCameraPermisson:(success)successBlock;

/**
 *  获得相机访问权限
 *
 *  @param successBlock 成功的回调
 *  @param failureBlock 失败的回调
 */
-(void)getCameraPermissonSuccessBlock:(success)successBlock failureBlock:(failure)failureBlock;

@end
