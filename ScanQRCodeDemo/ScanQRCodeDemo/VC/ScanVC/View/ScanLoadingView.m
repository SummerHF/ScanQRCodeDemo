//
//  LoadingView.m
//  loveOil
//
//  Created by swift on 9/2/16.
//  Copyright © 2016 macbookair. All rights reserved.
//

#import "ScanLoadingView.h"

@interface ScanLoadingView ()

@property (nonatomic, strong) UILabel  * promptLable;

@property (nonatomic, strong) UIActivityIndicatorView * indicatorView;

@end



@implementation ScanLoadingView

-(UILabel *)promptLable
{
    if (!_promptLable) {
        
        _promptLable = [[UILabel alloc] init];
        
        [_promptLable setText:self.prompt color:WHITECOLOR fontSize:Default_Font_Small_Size];
    }
    
    return _promptLable;
}


-(UIActivityIndicatorView *)indicatorView
{
    if (!_indicatorView ) {
        
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        
    }
    return _indicatorView;
}



-(instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title
{
    if (self = [super initWithFrame:frame]) {
        
        self.prompt = title;
            
        [self addAllsubViews];
    }
    
    return self;
}


-(void)addAllsubViews
{

    [self addSubview:self.indicatorView];
    
    [self addSubview:self.promptLable];
    
    
    self.indicatorView.centerX = self.centerX;
    
    self.indicatorView.y = self.y;
    
  
    
    self.promptLable.centerX = self.centerX;
    
    self.promptLable.y = CGRectGetMaxY(self.indicatorView.frame)+20;

    
    //1.菊花旋转
    
    [self.indicatorView startAnimating];
}

@end
