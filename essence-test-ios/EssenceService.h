//
//  EssenceService.h
//  essence-test-ios
//
//  Created by Chris Ragobeer on 2016-11-05.
//  Copyright © 2016 Essence. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EssenceService : NSObject <NSURLSessionDelegate,NSURLSessionTaskDelegate, NSURLSessionDataDelegate>
{
    NSDictionary *parsedData;
    NSMutableData *receivedData;
    NSString *objectName;
}
+(EssenceService *)sharedInstance;
-(void)uploadBase64ImageWithCompletionBlock:(NSData *)imageData withEncodedString:(NSString *)encodedString :(void(^)(NSData *dataObject,NSURLResponse *response, NSError *error)) completionBlock;

-(void)upload2Base64ImageWithCompletionBlock:(NSString *)base64EncodedString :(void(^)(NSData *dataObject,NSURLResponse *response, NSError *error)) completionBlock;

-(void) fetchPhotoListWithCompletionBlock:(void(^)(NSArray *photoArray, NSError *error)) completionBlock;
-(void) fetchPhotoBase64DataWithCompletionBlock:(NSString *)photoID :(void(^)(NSData *dataObject,NSURLResponse *response, NSError *error)) completionBlock;

@property (nonatomic, readonly) NSDictionary *parsedData;

- (id)initWithObjectName:(NSString *)name;

@end
