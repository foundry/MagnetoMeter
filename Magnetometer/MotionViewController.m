//
//  MotionViewController.m
//  BackgroundTracker2
//
//  Created by foundry on 02/03/2013.
//  Copyright (c) 2013 foundry. All rights reserved.
//

#import "MotionViewController.h"
#import "CLMManager.h"


@interface MotionViewController ()<CLLocationManagerDelegate>
@property (nonatomic, strong, readwrite) NSOperationQueue* sampleQueue;
@property (nonatomic, strong, readwrite) NSOperationQueue* mainQueue;
@property (nonatomic, strong, readwrite) NSOperationQueue* currentQueue;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttonCollection;

@end

@implementation MotionViewController

#define DEFAULT_SAMPLING_FREQUENCY 1.0/60.0

@synthesize samplingFrequency = _samplingFrequency;

- (CGFloat) samplingFrequency
{
    if (!_samplingFrequency) {
        if ([[[self.defaults dictionaryRepresentation] allKeys] containsObject:SAMPLING_FREQUENCY]) {
            _samplingFrequency = [[self.defaults objectForKey:SAMPLING_FREQUENCY] floatValue];
        } else {
            _samplingFrequency = DEFAULT_SAMPLING_FREQUENCY;
        }
    } else  {
        [self.defaults setFloat:_samplingFrequency forKey:SAMPLING_FREQUENCY];
    }
    return _samplingFrequency;
}

- (void) setSamplingFrequency:(CGFloat)samplingFrequency
{
    _samplingFrequency = samplingFrequency;
    [self.defaults setFloat:_samplingFrequency forKey:SAMPLING_FREQUENCY];
}

- (CMMotionManager*) motionManager
{
    if (!_motionManager) {
        _motionManager = [[CLMManager sharedManager] motionManager];
    }
    return _motionManager;
}

- (CLLocationManager*) locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLMManager sharedManager] locationManager];
        _locationManager.delegate = self;

    }
    return _locationManager;
}

#pragma mark - app stuff

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    NSLog(@"%@ %@",self,NSStringFromSelector(_cmd));
    NSLog (@"allocating sampleQueue ");
    self.sampleQueue = [[NSOperationQueue alloc] init];
    self.mainQueue = [NSOperationQueue mainQueue];
    self.currentQueue = [NSOperationQueue currentQueue];
    [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated
{
    NSLog(@"%@ %@",self,NSStringFromSelector(_cmd));

    [super viewWillAppear:animated];
    self.defaults = [NSUserDefaults standardUserDefaults];

    if ([[[self.defaults dictionaryRepresentation] allKeys] containsObject:PUSH_TRACKING]) {
        self.pushTracking = [self.defaults boolForKey:PUSH_TRACKING];
    } else {
        self.pushTracking = NO;
        [self.defaults setBool:NO forKey:PUSH_TRACKING];
    }
    NSLog(@"self.pushTracking %d",self.pushTracking);
    for (UIButton* button in self.buttonCollection) {
    }
    
    if (self.pushTracking) {
        [self pushMotion];
    } else {
        [self pullMotion];
    }


}

- (void) viewWillDisappear:(BOOL)animated
{
    [self.defaults synchronize];
    [self stopMotion];

}

- (void) initialiseDefaults
{
    NSLog(@"%@ %@",self,NSStringFromSelector(_cmd));
 
}

- (void)didReceiveMemoryWarning
{
    NSLog(@"%@ %@",self,NSStringFromSelector(_cmd));

    [super didReceiveMemoryWarning];
}


- (void)pushMotion
{
    NSLog(@" %@",NSStringFromSelector(_cmd));
    NSLog (@"sampleFreq %.2f",self.samplingFrequency);
    [self.motionTimer invalidate];
    self.motionTimer = nil;
    [self.sampleQueue  setMaxConcurrentOperationCount:1];
   
    self.updateViewsTimer =
    [NSTimer scheduledTimerWithTimeInterval:1/60.0
                                     target:self
                                   selector:@selector(timerMotion:)
                                   userInfo:nil
                                    repeats:YES];
    
       
    [self pushMotionAdditions];
}

- (void)  pullMotion
{
    NSLog(@" %@",NSStringFromSelector(_cmd));
    NSLog (@"samplingFreq %f",self.samplingFrequency);
    NSLog (@"samples per second %i",(int)(1/self.samplingFrequency));
        
    self.updateViewsTimer =
    [NSTimer scheduledTimerWithTimeInterval:1/60.0
                                     target:self
                                   selector:@selector(timerMotion:)
                                   userInfo:nil
                                    repeats:YES];
    
    
       
    [self pullMotionAdditions];
    
}

- (void) stopMotion {
    NSLog(@" %@",NSStringFromSelector(_cmd));
    [self.motionManager stopDeviceMotionUpdates];
    [self.motionManager stopAccelerometerUpdates];
    [self.motionManager stopGyroUpdates];
    [self.motionManager stopMagnetometerUpdates];
    [self.locationManager stopUpdatingHeading];
    [self.motionTimer invalidate];
    self.motionTimer = nil;
    [self.updateViewsTimer invalidate];
    self.updateViewsTimer = nil;
    [self.sampleMotionTimer invalidate];
    self.sampleMotionTimer = nil;
}

- (void) timerMotion:(NSTimer*)timer
{

    [self updateMotionViews];
}

#pragma mark - logging
- (void) logLocation
{


}


- (void) logDiff

{
    CMDeviceMotion* motion = self.motionManager.deviceMotion;
    CLHeading* heading = self.locationManager.heading;
    
    NSLog (@"xdiff %.2f",heading.x - motion.magneticField.field.x);
    NSLog (@"xdiff %.2f",heading.y - motion.magneticField.field.y);
    NSLog (@"xdiff %.2f",heading.z - motion.magneticField.field.z);
    NSLog (@"       magneticField.field.x %.2f y %.2f z %.2f",
           motion.magneticField.field.x,motion.magneticField.field.y,motion.magneticField.field.z);
    NSLog (@"heading %@",heading);

}
- (void) logMotion

{
    NSLog(@"%@ %@",self,NSStringFromSelector(_cmd));

}


- (void) logMotion:(CMDeviceMotion*)motion

{
    NSLog(@"%@ %@",self,NSStringFromSelector(_cmd));
}

#pragma mark CLLocationManager delegate methods

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
        //  NSLog(@"%@ %@",self,NSStringFromSelector(_cmd));
        //[self logLocation];
}

- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager {
    return YES;
}

#pragma mark - emptry methods for subclasses to override
- (void) pullMotionAdditions{}
- (void) pushMotionAdditions{}
- (void) updateMotionViews{};

+ (CGFloat) degreesToRadians:(CGFloat) degrees {return degrees * M_PI / 180;};
+ (CGFloat) radiansToDegrees:(CGFloat) radians {return radians * 180/M_PI;};
@end
