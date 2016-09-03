//
//  UILabel+Category.h
//  loveOil
//
//  Created by swift on 7/29/16.
//  Copyright © 2016 macbookair. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Category)

/**
 *  设置UILabl的方法
 *
 *  @param text     文字
 *  @param color    颜色
 *  @param fontSize 字体大小
 *
 *  @return UILable实例
 */
-(void)setText:(NSString *)text color:(UIColor *)color fontSize:(CGFloat)fontSize;




@end
