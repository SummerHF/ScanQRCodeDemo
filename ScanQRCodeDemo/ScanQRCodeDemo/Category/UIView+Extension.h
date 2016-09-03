//
//  UIView+Extension.h
//  loveOil
//
//  Created by swift on 7/27/16.
//  Copyright © 2016 macbookair. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)



#pragma mark - 尺寸相关

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;



#pragma mark - 设置圆角相关

/**
 *  设置圆角属性
 */
- (void)setCircleStyle;


/**
 *  设置带有圆角值
 *
 *  @param corner 圆角的大小
 */
- (void)setCornerStyle:(CGFloat)corner;

/**
 *  设置边框颜色
 *
 *  @param color 边框的颜色
 */
- (void)setBoundColor:(UIColor *)color;


/**
 *  设置边框的宽度
 *
 *  @param width 边框的宽度
 */
- (void)setBoundWidth:(CGFloat)width;

/**
 *  生成圆角+边框+边框颜色
 *
 *  @param value 圆角值大小
 *  @param color 边框颜色
 *  @param width 边框的宽度
 */
- (void)setCornerValue:(CGFloat)value boundColor:(UIColor *)color boundWidth:(CGFloat)width;

@end
