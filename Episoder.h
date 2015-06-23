//
//  Episoder.h
//  phimb
//
//  Created by Apple on 6/22/15.
//  Copyright (c) 2015 com.haiphone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Episoder : NSObject <NSURLConnectionDataDelegate>
@property (strong,nonatomic) NSString *url;
@property (assign,nonatomic) NSInteger status;
-(id)initWithString:(NSString*)epiUrl;
@end
