//
//  Circle.h
//  MagnetoMeter
//
//  Created by foundry on 16/03/2013.
//  Copyright (c) 2013 foundry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Circle : UIView
@property (nonatomic, assign) CGFloat scale;  // 0 to 1
@property (nonatomic, strong) UIColor* fillColor;
@property (nonatomic, strong) UIColor* pathColor;

- (void) animateRadius:(CGFloat)scale;

@end
