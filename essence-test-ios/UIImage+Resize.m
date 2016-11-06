//
//  Resize.m
//  essence-test-ios
//
//  Created by Chris Ragobeer on 2016-11-06.
//  Copyright © 2016 Essence. All rights reserved.
//

#import "UIImage+Resize.h"

@implementation UIImage (Resize)


+ (UIImage *)resizeImage:(UIImage*)image{
    
    NSData *finalData = nil;
    NSData *unscaledData = UIImagePNGRepresentation(image);
    
    if (unscaledData.length > 50000.0f ) {
        //if image size is greater than 5KB dividing its height and width maintaining proportions
        UIImage *scaledImage = [self imageWithImage:image andWidth:image.size.width/2 andHeight:image.size.height/2];
        finalData = UIImagePNGRepresentation(scaledImage);
        NSLog(@"%lu", (unsigned long)finalData.length);
        if (finalData.length > 50000.0f  ) {
            [self resizeImage:scaledImage];
        }else {
            return scaledImage;
        }
    }
    return image;
}


+ (UIImage*)imageWithImage:(UIImage*)image andWidth:(CGFloat)width andHeight:(CGFloat)height
{
    UIGraphicsBeginImageContext( CGSizeMake(width, height));
    [image drawInRect:CGRectMake(0,0,width,height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext() ;
    return newImage;
}

@end
