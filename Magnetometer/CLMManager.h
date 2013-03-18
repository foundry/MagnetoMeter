//
//  CLMManager.h
//  Magnet-O-Meter
//
//  Created by foundry on 09/03/2013.
//  Copyright (c) 2013 foundry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>
#import <CoreLocation/CoreLocation.h>

@interface CLMManager : NSObject

@property (nonatomic, strong) CMMotionManager* motionManager;
@property (nonatomic, strong) CLLocationManager* locationManager;

+ (CLMManager*) sharedManager;

@end
