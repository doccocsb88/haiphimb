//
//  TabCommentView.h
//  SlideMenu
//
//  Created by Apple on 6/4/15.
//  Copyright (c) 2015 Aryan Ghassemi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CommentViewDelegate <NSObject>
@required
-(void)showLoginView;
-(void)closeLoginView;
@end
@interface TabCommentView : UIView
@property (strong, nonatomic) UIWebView *webview;

@property (strong,nonatomic) id<CommentViewDelegate> webDelegate;
-(id)initWithFrameX:(CGRect)frame;
-(void)requestFilmComment : (NSInteger )filmId;
@end
