//
//  CircleLayer.m
//  MagnetoMeter
//
//  Created by jonathan on 16/03/2013.
//  Copyright (c) 2013 foundry. All rights reserved.
//

#import "CircleLayer.h"

@implementation CircleLayer

@dynamic  radius;


+(BOOL)needsDisplayForKey:(NSString *)key
{
    NSLog (@" %@",NSStringFromSelector(_cmd));

    if ([key isEqualToString:@"radius"]) {
        return YES;
    } else {
        return [super needsDisplayForKey:key];
    }
}


- (id) initWithLayer:(id)layer {
    NSLog (@" %@",NSStringFromSelector(_cmd));

    if (self = [super initWithLayer:layer]) {
        if ([layer isKindOfClass:[CircleLayer class]]) {
            CircleLayer* other = (CircleLayer*) layer;
            self.radius = other.radius;
            self.strokeWidth = other.strokeWidth;
        }
    }
    return self;
}


- (void)drawInContext:(CGContextRef)context {
    NSLog (@" %@",NSStringFromSelector(_cmd));
    self.strokeWidth = 1.0f;
    NSLog(@"Drawing layer, strokeWidth is %f, radius is %f", self.strokeWidth, self.radius);
    CGPoint centerPoint = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2);
    /* Path the circle */
    CGContextAddArc(context, centerPoint.x, centerPoint.y, self.radius, 0.0, 2*M_PI, 0);
    CGContextClosePath(context);
    
    /* And fill it */
    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
    CGContextFillPath(context);
    
    /* Path the circle again */
    CGContextAddArc(context, centerPoint.x, centerPoint.y, self.radius, 0.0, 2*M_PI, 0);
    CGContextClosePath(context);
    
    /* Stroke the path */
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    CGContextSetLineWidth(context, self.strokeWidth);
    CGContextStrokePath(context);
}


@end
