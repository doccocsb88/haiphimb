//
//  GuidePlayerView.m
//  phimb
//
//  Created by macbook on 8/1/16.
//  Copyright © 2016 com.haiphone. All rights reserved.
//

#import "GuidePlayerView.h"
@interface GuidePlayerView()
@property (strong, nonatomic) UIImageView *imvTouch;
@property (strong, nonatomic) UIImageView *imvDown;
@property (strong, nonatomic) UIImageView *imvLeftRight;
@property (strong, nonatomic) UILabel *lbTouch;
@property (strong, nonatomic) UILabel *lbDown;
@property (strong, nonatomic) UILabel *lbLeftRight;
@end
@implementation GuidePlayerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
//        <#statements#>
        UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0];

        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        //
        self.imvDown = [[UIImageView alloc] initWithFrame:CGRectMake(self.viewForLastBaselineLayout.frame.size.width/2 - 30/2, 20, 50, 60)];
        self.imvDown.contentMode = UIViewContentModeScaleAspectFit;
        self.imvDown.image = [UIImage imageNamed:@"ic_down"];
        [self addSubview:self.imvDown];
        self.lbDown = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2 + 30, 20, self.frame.size.width/2 - 50, 40)];
        self.lbDown.textColor = [UIColor whiteColor];
        self.lbDown.text = @"Swipe down to \nmove player down";
        self.lbDown.font = font;
        self.lbDown.numberOfLines = 0;
        self.lbDown.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:self.lbDown];
        
        //
        self.imvTouch = [[UIImageView alloc] initWithFrame:CGRectMake(10, 30, 20, 20)];
        self.imvTouch.contentMode = UIViewContentModeScaleAspectFit;
        self.imvTouch.image = [UIImage imageNamed:@"ic_touch"];
        [self addSubview:self.imvTouch];
        self.lbTouch = [[UILabel alloc] initWithFrame:CGRectMake(40, 20, self.frame.size.width/2 - 100, 40)];
        self.lbTouch.textColor = [UIColor whiteColor];
        self.lbTouch.text = @"Touch to \nminimized player";
        self.lbTouch.font = font;
        self.lbTouch.numberOfLines = 0;
        self.lbTouch.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:self.lbTouch];
        //
        self.imvLeftRight = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 60, self.frame.size.height - 180, 120,120)];
        self.imvLeftRight.contentMode = UIViewContentModeScaleAspectFit;
        self.imvLeftRight.image = [UIImage imageNamed:@"ic_left_right"];
        [self addSubview:self.imvLeftRight];
        
        self.lbLeftRight = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/4, self.frame.size.height - 100  , self.frame.size.width/2, 50)];
        self.lbLeftRight.font = font;
        self.lbLeftRight.textAlignment = NSTextAlignmentCenter;
        self.lbLeftRight.textColor = [UIColor whiteColor];
        self.lbLeftRight.text = @"Swipe left or swipe right \n to change tab";
        self.lbLeftRight.numberOfLines = 0;
        self.lbLeftRight.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:self.lbLeftRight];
    }
    return self;
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"guideplayer"];
    [self removeFromSuperview];
}

@end
