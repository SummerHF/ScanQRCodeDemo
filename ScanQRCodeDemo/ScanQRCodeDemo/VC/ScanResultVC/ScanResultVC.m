//
//  ScanResultVC.m
//  ScanQRCodeDemo
//
//  Created by macbookair on 9/3/16.
//  Copyright © 2016 macbookair. All rights reserved.
//

#import "ScanResultVC.h"

@interface ScanResultVC ()


@property (weak, nonatomic) IBOutlet UITextView *scanResultTextView;

@end

@implementation ScanResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.scanResultTextView.text = self.scResult;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(popToRootVC)];
}


-(void)popToRootVC
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
