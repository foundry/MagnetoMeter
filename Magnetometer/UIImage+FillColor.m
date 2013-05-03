//
//  UIImage+FillColor.m
//  Magnet-O-Meter
//
//  Created by foundry on 15/03/2013.
//  Copyright (c) 2013 foundry. All rights reserved.
//

#import "UIImage+FillColor.h"

@implementation UIImage (FillColor)

    //  https://livingwithcode.wordpress.com/2013/02/19/graphics-tutorial-1-creating-an-uiimage-of-a-certain-color/

+ (UIImage*) fillImgOfSize:(CGSize)img_size
                 withColor:(UIColor*)img_color
{
    return [self fillImgOfSize:img_size
                     withColor:img_color
                  cornerRadius:0.0];
}

+ (UIImage*) fillImgOfSize:(CGSize)img_size
                 withColor:(UIColor*)img_color
              cornerRadius:(CGFloat)cornerRadius
{
    
    /* begin the graphic context */
    UIGraphicsBeginImageContext(img_size);
    
    /* set the color */
    [img_color set];
    
    /* fill the rect */
    CGRect rect = (CGRectMake(0, 0, img_size.width, img_size.height));
    UIBezierPath* path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
    [path fill];
   // UIRectFill(rect);
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    /* return the value */
    return scaledImage;
}


@end
