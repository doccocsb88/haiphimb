//
//  FilmInfoDetails.h
//  SlideMenu
//
//  Created by Apple on 6/1/15.
//  Copyright (c) 2015 Aryan Ghassemi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilmInfoDetails : NSObject
//[id] => 858
//[name] => Gửi Người Dấu Yêu
//[subname] =>
//[img] => https://lh3.googleusercontent.com/-pwbmbQOgFsc/VWhxgXo7z9I/AAAAAAAAATg/wR-2XaaWi-0/s420/11.jpg
//[img_landscpae] => https://lh3.googleusercontent.com/-MMzOx1BQFW0/VWhwoz9mO1I/AAAAAAAAATY/iEQXkpx9QqQ/s550/276.jpg
//[movie_links]
//[cate] => Tình Cảm, Hài Hước
//[country] => Hàn Quốc
//[total] => 16
//[star] => Choi Seol Ri as Goo Jae Hee Min Ho as Kang Tae Joon Lee Hyun Woo as Cha Eun Kyul Kim Ji Won as Seol Han Na Suh Joon Young as Ha Seung Ri Kang Ha Neul as Joo Ji Chul Hwang Kwang Hee as Song Jong Min
//[director] => Updating....
//[desc] => Gửi Người Dấu Yêu
//[movie_links_server] => Array
@property (nonatomic) NSInteger _id;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *subname;
@property (strong, nonatomic) NSString *img;
@property (strong, nonatomic) NSString *img_landscpae;
//@property (strong, nonatomic) NSArray *movie_links;
@property (strong, nonatomic) NSString *cate;
@property (strong, nonatomic) NSString *country;
@property (nonatomic) NSInteger total;
@property (strong, nonatomic) NSString *star;
@property (strong, nonatomic) NSString *director;
@property (strong, nonatomic) NSString *desc;
//@property (strong,nonatomic) NSDictionary *movie_links_server;
-(id)initWithData: (NSDictionary *)filmData;
@end
