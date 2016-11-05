//
//  EssencePicture.h
//  essence-test-ios
//
//  Created by Chris Ragobeer on 2016-11-05.
//  Copyright © 2016 Essence. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EssencePicture : NSObject
    
    @property (nonatomic, copy) NSString *pictureId;
    @property (nonatomic, copy) NSString *name;
    @property (nonatomic, copy) NSString *base64picture;
    @property (nonatomic, copy) NSString *url;


@end
