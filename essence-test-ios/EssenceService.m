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


-(void)upload2Base64ImageWithCompletionBlock:(NSString *)base64EncodedString :(void(^)(NSData *dataObject,NSURLResponse *response, NSError *error)) completionBlock {
    
    // NSString *boundary = [self generateBoundaryString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"https://api-server.essenceprototyping.com:999/photos/upload"]];
    [request setHTTPMethod:@"POST"];
    
    NSString *contentType = [NSString stringWithFormat:@"application/json"];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
  
    NSError *error;
    NSDictionary *dict = @{@"name":@"uploadedImage",@"data":base64EncodedString};

    NSLog(@"Parameters %@",dict);
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    [request setHTTPBody:postData];

    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      
                                      NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                      NSLog(@"response status code: %ld", (long)[httpResponse statusCode]);
                                      
                                      NSLog(@"%@",httpResponse.allHeaderFields);
                                      //  NSLog(@"%@",response.statusCode)
                                      
                                      completionBlock(data,response,error);
                                  }];
    [task resume];

    
    
    
}

-(void)uploadBase64ImageWithCompletionBlock:(NSData *)imageData withEncodedString:(NSString *)encodedString :(void(^)(NSData *dataObject,NSURLResponse *response, NSError *error)) completionBlock {

    NSString *boundary = [self generateBoundaryString];
   
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"https://api-server.essenceprototyping.com:999/photos/upload"]];
    [request setHTTPMethod:@"POST"];
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    // add params (all params are strings)
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@\r\n\r\n", @"FromCameraRoll5"] dataUsingEncoding:NSUTF8StringEncoding]];

    
    // add image data
    if(imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@; filename=imageName.png\r\n", @"data"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/png\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",encodedString] dataUsingEncoding:NSUTF8StringEncoding ]];
        
        //  [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      
                                      NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                      NSLog(@"response status code: %ld", (long)[httpResponse statusCode]);
                                      
                                      NSLog(@"%@",httpResponse.allHeaderFields);
                                    //  NSLog(@"%@",response.statusCode)
                                      
                                      completionBlock(data,response,error);
                                  }];
    [task resume];
}

- (NSString *)generateBoundaryString
{
    return [NSString stringWithFormat:@"Boundary-%@", [[NSUUID UUID] UUIDString]];
}

-(void) fetchPhotoBase64DataWithCompletionBlock:(NSString *)photoID :(void(^)(NSData *dataObject, NSURLResponse *response, NSError *error)) completionBlock {
    
    NSString *b = [@"https://api-server.essenceprototyping.com:999/photos/get/" stringByAppendingString:photoID];
    NSURL *dataURL = [NSURL URLWithString:b];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:dataURL];
    [request setValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                       completionBlock (data, response, error);
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
