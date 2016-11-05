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
-(void)uploadBase64ImageWithCompletionBlock:(NSString *)encodedString :(void(^)(NSData *dataObject, NSError *error)) completionBlock;
-(void) fetchPhotoListWithCompletionBlock:(void(^)(NSArray *photoArray, NSError *error)) completionBlock;
-(void) fetchPhotoBase64DataWithCompletionBlock:(NSString *)photoID :(void(^)(NSData *dataObject, NSError *error)) completionBlock;

@property (nonatomic, readonly) NSDictionary *parsedData;

- (id)initWithObjectName:(NSString *)name;

@end
