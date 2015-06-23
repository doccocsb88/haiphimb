//
//  CenterHolderViewController.m
//  phimb
//
//  Created by Apple on 6/16/15.
//  Copyright (c) 2015 com.haiphone. All rights reserved.
//

#import "CenterHolderViewController.h"

@interface CenterHolderViewController ()

@end

@implementation CenterHolderViewController
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
-(void)loadListFilm:(NSInteger)index{
}

-(void)genreSelected:(Genre *)genre{

}
-(void)initHeader{
}
-(id)initWithTag:(NSInteger)tag{
    self =[super init];
    
    return self;
}
-(void)setImageAtIndex:(NSInteger)index image:(UIImage *)img{

}
-(void)setDelegate:(id<CenterHolderDelegate>)delegate{
}
-(void)setLeftButtonTag:(int)tag{
}
-(void)setRightButtonTag:(int)tag{
}
-(void)callWebService{
}
@end
