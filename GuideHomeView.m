//
//  GuideHomeView.m
//  phimb
//
//  Created by macbook on 8/1/16.
//  Copyright © 2016 com.haiphone. All rights reserved.
//

#import "GuideHomeView.h"
@interface GuideHomeView()
@property (strong, nonatomic)UIImageView *imvTouch;
@property (strong, nonatomic)UIImageView *imvRight;
@property (strong, nonatomic)UILabel *lbTouch;
@property (strong, nonatomic)UILabel *lbRight;


@end
@implementation GuideHomeView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //        <#statements#>
        UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0];
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        //
     
        
        //
        self.imvTouch = [[UIImageView alloc] initWithFrame:CGRectMake(10, 30, 20, 20)];
        self.imvTouch.contentMode = UIViewContentModeScaleAspectFit;
        self.imvTouch.image = [UIImage imageNamed:@"ic_touch"];
        [self addSubview:self.imvTouch];
        self.lbTouch = [[UILabel alloc] initWithFrame:CGRectMake(40, 20, self.frame.size.width/2, 40)];
        self.lbTouch.textColor = [UIColor whiteColor];
        self.lbTouch.text = @"Touch to \n open menu";
        self.lbTouch.font = font;
        self.lbTouch.numberOfLines = 0;
        self.lbTouch.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:self.lbTouch];
        //
        self.imvRight = [[UIImageView alloc] initWithFrame:CGRectMake(10, self.frame.size.height/2 - 15, 60,50)];
        self.imvRight.contentMode = UIViewContentModeScaleAspectFit;
        self.imvRight.image = [UIImage imageNamed:@"ic_right"];
        [self addSubview:self.imvRight];
        
        self.lbRight = [[UILabel alloc] initWithFrame:CGRectMake(10, self.frame.size.height/2 + 20  , self.frame.size.width/2, 50)];
        self.lbRight.font = font;
        self.lbRight.textAlignment = NSTextAlignmentLeft;
        self.lbRight.textColor = [UIColor whiteColor];
        self.lbRight.text = @"Swipe right to\n open menu";
        self.lbRight.numberOfLines = 0;
        self.lbRight.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:self.lbRight];
    }
    return self;
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"guidehome"];
    [self removeFromSuperview];
}

@end