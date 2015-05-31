//
//  Arrow.m
//  Magnet-O-Meter
//
//  Created by foundry on 15/03/2013.
//  Copyright (c) 2013 foundry. All rights reserved.
//

#import "Arrow.h"

const CGFloat kMyViewWidth = 240.0;
const CGFloat kMyViewHeight = 240.0;

@implementation Arrow

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setOpaque:NO];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setOpaque:NO];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}


- (CGSize)sizeThatFits:(CGSize)size
{
    return CGSizeMake(kMyViewWidth, kMyViewHeight);
}

- (void)drawRect:(CGRect)rect
{
    CGRect imageBounds = CGRectMake(0.0f, 0.0f, kMyViewWidth, kMyViewHeight);
    CGRect bounds = [self bounds];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect drawRect;
    CGFloat resolution;

    UIColor *color;
    CGFloat alignStroke;
    CGFloat stroke;
    CGMutablePathRef path;
    CGPoint point;
    resolution = 0.5f * (bounds.size.width / imageBounds.size.width + bounds.size.height / imageBounds.size.height);
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, bounds.origin.x, bounds.origin.y);
    CGContextScaleCTM(context, (bounds.size.width / imageBounds.size.width), (bounds.size.height / imageBounds.size.height));
    drawRect = imageBounds;
    drawRect.origin.x = roundf(resolution * drawRect.origin.x) / resolution;
    drawRect.origin.y = roundf(resolution * drawRect.origin.y) / resolution;
    drawRect.size.width = roundf(resolution * drawRect.size.width) / resolution;
    drawRect.size.height = roundf(resolution * drawRect.size.height) / resolution;

    stroke = 1.0f;
    stroke *= resolution;
    if (stroke < 1.0f) {
        stroke = ceilf(stroke);
    } else {
        stroke = roundf(stroke);
    }

    stroke /= resolution;

    alignStroke = fmodf(0.5f * stroke * resolution, 1.0f);
    path = CGPathCreateMutable();
    point = CGPointMake(drawRect.size.width/2, 0);
    point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
    point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
    CGPathMoveToPoint(path, NULL, point.x, point.y);
    point = CGPointMake(drawRect.size.width, drawRect.size.height);
    point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
    point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
    CGPathAddLineToPoint(path, NULL, point.x, point.y);
    
    point = CGPointMake(drawRect.size.width/2, drawRect.size.height/2);
    point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
    point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
    CGPathAddLineToPoint(path, NULL, point.x, point.y);
    
    point = CGPointMake(0, drawRect.size.height);
    point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
    point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
    CGPathAddLineToPoint(path, NULL, point.x, point.y);
    
    point = CGPointMake(drawRect.size.width/2, 0);
    point.x = (roundf(resolution * point.x + alignStroke) - alignStroke) / resolution;
    point.y = (roundf(resolution * point.y + alignStroke) - alignStroke) / resolution;
    CGPathAddLineToPoint(path, NULL, point.x, point.y);
    
    if (self.fillColor) color = self.fillColor;
    else color = [UIColor colorWithRed:0.6 green:0.0 blue:0.0 alpha:1.0];
    [color setFill];
    CGContextAddPath(context, path);
    CGContextFillPath(context);
    
    if (self.pathColor) color = self.pathColor;
    else color = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f];
   
    [color setStroke];
    CGContextSetLineWidth(context, alignStroke);
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextAddPath(context, path);
    CGContextStrokePath(context);
    CGPathRelease(path);
    
}


@end
