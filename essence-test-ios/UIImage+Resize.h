//
//  Resize.h
//  essence-test-ios
//
//  Created by Chris Ragobeer on 2016-11-06.
//  Copyright © 2016 Essence. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Resize)


+ (UIImage *)resizeImage:(UIImage*)image;
+ (UIImage*)imageWithImage:(UIImage*)image andWidth:(CGFloat)width andHeight:(CGFloat)height;

@end
