//
//  Circle.m
//  MagnetoMeter
//
//  Created by jonathan on 16/03/2013.
//  Copyright (c) 2013 foundry. All rights reserved.
//

#import "Circle.h"
#import "CircleLayer.h"

@interface Circle()
@property (nonatomic, strong) CircleLayer* circleLayer;

@end

@implementation Circle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setOpaque:NO];
        [self setBackgroundColor:[UIColor clearColor]];
        self.circleLayer = [[CircleLayer alloc] init];
        [self.layer addSublayer:self.circleLayer];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setOpaque:NO];
        [self setBackgroundColor:[UIColor clearColor]];
        self.circleLayer = [[CircleLayer alloc] init];
        [self.layer addSublayer:self.circleLayer];
    }
    return self;
}

- (void) animateRadius:(CGFloat)scale
{

    if (scale != self.scale){

        NSLog (@"animating radius to scale %f",scale);
        CABasicAnimation* anim =   [CABasicAnimation animationWithKeyPath:@"radius"];
        anim.duration = 0.2;
        anim.fromValue = [NSNumber numberWithFloat:self.scale*self.bounds.size.width/2];
        NSLog (@"fromValue %@",anim.fromValue);
        anim.toValue =  [NSNumber numberWithFloat:scale*self.bounds.size.width/2];
        NSLog (@"toValue %@",anim.toValue);
        anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        [self.circleLayer addAnimation:anim forKey:nil];
        self.scale = scale;
        self.circleLayer.radius = [anim.toValue intValue];
    }
}

#define MAX_DIAMETER 0.98
- (void)drawRect1:(CGRect)rect
{
    CGRect circleBounds = self.bounds;
    CGFloat maxDiameter = self.bounds.size.width*MAX_DIAMETER;
    CGFloat scaleDiameter = self.scale*maxDiameter;
    circleBounds.size = (CGSize){scaleDiameter,scaleDiameter};
    CGFloat originX = (self.bounds.size.width - scaleDiameter)/2;
    circleBounds.origin = (CGPoint){originX,originX};
    UIColor* fillColor; UIColor* strokeColor;
    if (self.fillColor) fillColor = self.fillColor;
    else fillColor = [UIColor colorWithRed:0.9 green:0.8 blue:0.8 alpha:0.1];
    if (self.pathColor) strokeColor = self.pathColor;
    else strokeColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f];
    UIBezierPath* circle = [UIBezierPath bezierPathWithOvalInRect:circleBounds];
    [circle setLineWidth:0.5f];
    [strokeColor set];
    [circle stroke];
    [fillColor set];
    [circle fill];

}



@end
