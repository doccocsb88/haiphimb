//
//  ServiceConnector.h
//  SlideMenu
//
//  Created by Apple on 5/31/15.
//  Copyright (c) 2015 Aryan Ghassemi. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol ServiceConnectorDelegate <NSObject>
-(void)requestReturnedData:(NSData*)data;
@end
@interface ServiceConnector : NSObject <NSURLConnectionDelegate,NSURLConnectionDataDelegate>
@property (strong,nonatomic) id <ServiceConnectorDelegate> delegate;
-(void)getTest;
-(void)postTest;
@end



