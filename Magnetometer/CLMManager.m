//
//  CLMManager.m
//  Magnet-O-Meter
//
//  Created by foundry on 09/03/2013.
//  Copyright (c) 2013 foundry. All rights reserved.
//

#import "CLMManager.h"


@interface CLMManager()<CLLocationManagerDelegate>






@end

@implementation CLMManager

#pragma mark - CLLocation Manager delegates

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"moved from %@ to %@",oldLocation, newLocation);
    
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"received Core Location Error %@",error);
    [self.locationManager stopUpdatingLocation];
    
}

#pragma mark - CMMotion and CLLocation shared managers

- (CMMotionManager*) motionManager
{
    if (!_motionManager) {
        _motionManager = [[CMMotionManager alloc] init];
    }
    return _motionManager;
}

- (CLLocationManager*) locationManager
{
    if (!_locationManager) {
    _locationManager = [[CLLocationManager alloc] init];
    }
    return _locationManager;
}

#pragma mark - CLLocation start/stop

#pragma mark - sharedManager creation

- (id) init
{
    if (self = [super init]) {
            //[self  copyDatabaseFromBundle];
    }
    return self;
}




+ (CLMManager*) sharedManager
{
    static CLMManager* sharedManager = nil;
    if (!sharedManager) {
        sharedManager = [[super allocWithZone:nil] init];
    }
    return sharedManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedManager];
}

    //re Singletons see latest discussion at
    //http://stackoverflow.com/questions/15463761/objective-c-singleton-pattern-in-ios-5



@end
