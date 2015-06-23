//
//  SplashViewController.m
//  phimb
//
//  Created by Apple on 6/18/15.
//  Copyright (c) 2015 com.haiphone. All rights reserved.
//

#import "SplashViewController.h"
#import "ImageHelper.h"
#import <AudioToolbox/AudioToolbox.h>
@interface SplashViewController ()
{
    CGFloat boxW;
    NSMutableArray *dataArr;
    SystemSoundID mBeep;

    
}
@end

@implementation SplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dataArr = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view.
    CGFloat ratio = 319.f/367.f;
    CGFloat marginTop = self.view.frame.size.height/2;
    boxW = (self.view.frame.size.width)/10;
    NSString *strFILMBO = @"-PHIMBỘ-";
    //
//    UIImageView *imgLogo1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"flash2.png"]];
//    imgLogo1.transform = CGAffineTransformMakeRotation(.34906585);
//
//    imgLogo1.frame = CGRectMake(boxW*3, 100, boxW*2, boxW/2);
//    imgLogo1.contentMode = UIViewContentModeScaleAspectFit;
//    [self.view addSubview:imgLogo1];
    //f5dfc2
//    [UIColor co]
    self.view.backgroundColor = [UIColor colorWithRed:245 / 255.0 green:223 / 255.0 blue:194 / 255.0 alpha:1];
    UIImageView *imgLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"flash3.png"]];
    imgLogo.frame = CGRectMake(boxW+boxW*3, marginTop - boxW*3, boxW*2, boxW*2);
    imgLogo.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imgLogo];
    for(int i = 0; i < 8; i ++){
        UIView *lb = [[UIView alloc] initWithFrame:CGRectMake(boxW+boxW*i, marginTop, boxW, boxW/ratio)];
        lb.alpha = 0.f;
        UIImageView *img  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_flash.png"]];
        img.frame = CGRectMake(0, 0, boxW, boxW/ratio);
        img.contentMode = UIViewContentModeScaleAspectFit;
        [lb addSubview:img];
        //
        
        UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, boxW, boxW/ratio)];
        text.font = [UIFont systemFontOfSize:boxW/2];
        text.text = [strFILMBO substringWithRange:NSMakeRange(i, 1)];
        text.textColor = [UIColor blackColor];
        text.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:lb];
        [lb addSubview:text];
//        [dataArr addObject:lb];
        [UIView animateKeyframesWithDuration:1.f delay:0.3*i options:UIViewKeyframeAnimationOptionBeginFromCurrentState animations:^{
            lb.alpha = 1.f;
        } completion:^(BOOL finished){}];
    }
//    [self playSound];

    [NSTimer scheduledTimerWithTimeInterval:5.f target:self selector:@selector(showTabViewController) userInfo:nil repeats:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)showTabViewController{
    [self.btnFake sendActionsForControlEvents:UIControlEventTouchUpInside];

}
-(void)playSound{
    NSString* path = [[NSBundle mainBundle]
                      pathForResource:@"tichsound" ofType:@"aiff"];
    NSURL* url = [NSURL fileURLWithPath:path];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &mBeep);
    
    // Play the sound
    AudioServicesPlaySystemSound(mBeep);
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
