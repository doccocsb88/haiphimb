//
//  FBLoginDialogViewController.m
//  phimb
//
//  Created by Apple on 6/8/15.
//  Copyright (c) 2015 com.haiphone. All rights reserved.
//

#import "FBLoginDialogViewController.h"

@interface FBLoginDialogViewController ()

@end

@implementation FBLoginDialogViewController
-(id)initWithFrame:(CGRect)frame{
    self = [super init];
    if(self){
        self.view.frame = frame;
        self.view.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
