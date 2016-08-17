//
//  SplashViewController.m
//  phimb
//
//  Created by macbook on 8/1/16.
//  Copyright © 2016 com.haiphone. All rights reserved.
//

#import "SplashViewController.h"

@interface SplashViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnStart;
//@property (strong, nona)
@end

@implementation SplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNeedsStatusBarAppearanceUpdate];
   
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(openMainView) userInfo:nil repeats:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
-(void)openMainView{
    [self.btnStart sendActionsForControlEvents:UIControlEventTouchUpInside];
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
