//
//  ScanView.h
//  loveOil
//
//  Created by macbookair on 9/3/16.
//  Copyright © 2016 macbookair. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AVFoundation/AVFoundation.h>


@protocol ScanViewDelegate <NSObject>

/**
 *  未获得访问相机授权
 */

-(void)doNotGetPermissionToCamera;

/**
 *  扫码结果
 *
 *  @param scanResult 扫描结果
 */
-(void)getScanResult:(NSString *)scanResult;

@end

@interface ScanView : UIView

/**
 *  代理属性
 */
@property (nonatomic, weak) id<ScanViewDelegate> delegate;

@end
