//
//  OilStationScanVC.m
//  loveOil
//
//  Created by swift on 9/2/16.
//  Copyright © 2016 macbookair. All rights reserved.
//

#import "OilStationScanVC.h"

#import "ScanView.h"

#import "ScanResultVC.h"

@interface OilStationScanVC ()<ScanViewDelegate>

/**
 *  加载视图
 */


@property (nonatomic, strong) ScanView * scanView;


@end

@implementation OilStationScanVC

-(ScanView *)scanView
{
    if (!_scanView) {
        
        _scanView = [[ScanView alloc] initWithFrame:self.view.frame];
    }
    
    return _scanView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    self.title = @"扫描二维码";
    
    self.scanView.delegate = self;
    
    
    [self.view addSubview:self.scanView];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}


#pragma mark - ScanViewDelegate

-(void)getScanResult:(NSString *)scanResult
{

    
    ScanResultVC * sc = [[ScanResultVC alloc] init];
    
    sc.scResult = scanResult;
    
    [self.navigationController pushViewController:sc animated:YES];
}


-(void)doNotGetPermissionToCamera
{
    NSLog(@"此处提示用户到设置中打开访问相机权限");
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
