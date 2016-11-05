//
//  EssenceService.m
//  essence-test-ios
//
//  Created by Chris Ragobeer on 2016-11-05.
//  Copyright © 2016 Essence. All rights reserved.
//

#import "EssenceService.h"
#import "Constants.h"
#import <UIKit/UIKit.h>

#define website @"https://api-server.essenceprototyping.com:999/"

@implementation EssenceService


+(EssenceService *) sharedInstance
{
    static EssenceService *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[EssenceService alloc] init];
    });
    return _sharedInstance;
}

@synthesize parsedData;

- (id)initWithObjectName:(NSString *)className
{
    self = [super init];
    if (self) {
        objectName = className;
    }
    return self;
}

-(void)uploadBase64ImageWithCompletionBlock:(NSString *)encodedString :(void(^)(NSData *dataObject, NSError *error)) completionBlock {
    
    NSString *post =[NSString stringWithFormat:@"name=%s&data=%@","imagePhoto",encodedString];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"https://api-server.essenceprototyping.com:999/photos/upload"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      completionBlock(data,error);
                                  }];
    [task resume];
}

-(void) fetchPhotoBase64DataWithCompletionBlock:(NSString *)photoID :(void(^)(NSData *dataObject, NSError *error)) completionBlock {
    
    NSString *b = [@"https://api-server.essenceprototyping.com:999/photos/get/" stringByAppendingString:photoID];
    NSURL *dataURL = [NSURL URLWithString:b];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:dataURL];
    [request setValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                       completionBlock (data, error);
                                  }];
    [task resume];

}

-(void) fetchPhotoListWithCompletionBlock:(void(^)(NSArray *photoArray, NSError *error)) completionBlock;
{

    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    defaultConfigObject.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
    NSURLSession *delegateFreeSession = [NSURLSession sessionWithConfiguration: defaultConfigObject
                                                                      delegate: nil
                                                                 delegateQueue: [NSOperationQueue mainQueue]];

    NSURL *dataURL = [NSURL URLWithString:ESSENCE_PHOTO_DATA_URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:dataURL];
    
    [[delegateFreeSession dataTaskWithRequest:request
                            completionHandler:^(NSData *data, NSURLResponse *response,
                                                NSError *error)
      {
          NSLog(@"Got response %@ with error %@.\n", response, error);
          
          if(data!=nil){
              NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
              completionBlock (dataArray, error);

          }else {
            completionBlock (nil, error);  
          }
    
      }
      ]resume];
}
@end
