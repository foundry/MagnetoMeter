//
//  MotionViewController.h
//  BackgroundTracker2
//
//  Created by foundry on 02/03/2013.
//  Copyright (c) 2013 foundry. All rights reserved.
//
//superclass for all the motion controllerViews

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import <CoreLocation/CoreLocation.h>
    //#import "CDStore.h"

#define SAMPLING_FREQUENCY @"samplingFrequency"
#define PUSH_TRACKING @"pushTracking"
#define MOTION @"motion"
#define HEADING @"heading"
#define LOCATION @"location"



@interface MotionViewController : UIViewController
@property (nonatomic, strong) CMMotionManager* motionManager;
@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, strong,readonly) NSOperationQueue* sampleQueue;
@property (nonatomic, strong,readonly) NSOperationQueue* mainQueue;
@property (nonatomic, strong,readonly) NSOperationQueue* currentQueue;

@property (strong, nonatomic) NSUserDefaults* defaults;
@property (nonatomic,assign) CGFloat samplingFrequency;
@property (nonatomic, assign) BOOL pushTracking;

@property (nonatomic, strong) NSURL* bufferFile;

@property (nonatomic, strong) NSTimer* sampleMotionTimer;
@property (nonatomic, strong) NSTimer* updateViewsTimer;
@property (nonatomic, strong) NSTimer* motionTimer;

- (void)stopMotion;

+ (CGFloat) degreesToRadians:(CGFloat) degrees;
+ (CGFloat) radiansToDegrees:(CGFloat) radians;

@end
