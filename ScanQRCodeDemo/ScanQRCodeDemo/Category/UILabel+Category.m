//
//  UILabel+Category.m
//  loveOil
//
//  Created by swift on 7/29/16.
//  Copyright © 2016 macbookair. All rights reserved.
//

#import "UILabel+Category.h"

@implementation UILabel (Category)


-(void)setText:(NSString *)text color:(UIColor *)color fontSize:(CGFloat)fontSize
{
    
    
    self.text = text;
    
    self.textAlignment = NSTextAlignmentCenter;
    
    if (color != nil) {
        
        self.textColor = color;
    }
    
    else
    {
        self.textColor = BLACKCOLOR;
    }
 
    
    self.font = UIFONT(fontSize);
    

    
    [self sizeToFit];
    
}




@end
