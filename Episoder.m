//
//  Episoder.m
//  phimb
//
//  Created by Apple on 6/22/15.
//  Copyright (c) 2015 com.haiphone. All rights reserved.
//

#import "Episoder.h"

@implementation Episoder
-(id)init{
    self = [super init];
    
    if(self){
        self.url = @"";
        self.status = 0;
    }
    return self;
}
-(id)initWithString:(NSString*)epiUrl{
    self = [super init];
    
    if(self){
        self.url = epiUrl;
        self.status = 0;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self callWebService:epiUrl];

        });
    }
    return self;
}
-(void)callWebService:(NSString *)WS_URL{
    
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:WS_URL]
                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                       timeoutInterval:60.0];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    NSLog(@"API URL %@",WS_URL);
    if (connection)
    {
        //receivedData = nil;
    }
    else
    {
        NSLog(@"Connection could not be established");
    }
    
}
#pragma mark - NSURLConnection delegate methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"***** Connection failed");
    int statusCode = [((NSHTTPURLResponse *)response) statusCode];
    if (statusCode == 404 || statusCode == 500)
    {
        self.status = 2;
        [connection cancel];  // stop connecting; no more delegate messages
        NSLog(@"didReceiveResponse statusCode with %i", statusCode);

        //        [self.moviePlayerController.view addSubview:alert];
    }else{
        self.status = 1;
    }
    //    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
    //    if (!receivedData)
    //        receivedData = [[NSMutableData alloc] initWithData:data];
    //    else
    //        [receivedData appendData:data];
    //[self pareJsonToData];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
    //receivedData=nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    //NSLog(@"***** Succeeded! Received %d bytes of data",[receivedData length]);
    // NSLog(@"***** AS UTF8:%@",[[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding]);
}
@end
