//
//  LoadingView.h
//  loveOil
//
//  Created by swift on 9/2/16.
//  Copyright © 2016 macbookair. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScanLoadingView : UIView


/**
 *  加载提示词
 */
@property (nonatomic, strong) NSString * prompt;

/**
 *  
 *
 *  @param frame 尺寸
 *  @param title 标题
 *
 *  @return
 */
-(instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title;


@end
