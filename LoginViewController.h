//
//  LoginViewController.h
//  phimb
//
//  Created by Apple on 6/5/15.
//  Copyright (c) 2015 com.haiphone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate>
@property (weak,nonatomic) IBOutlet UITextField *tfUsername;
@property (weak,nonatomic) IBOutlet UITextField *tfPassword;
@property (weak,nonatomic) IBOutlet UIButton *btnLogin;
@property (weak,nonatomic) IBOutlet UIButton *btnBack;
@end
