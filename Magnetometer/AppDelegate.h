//
//  AppDelegate.h
//  BackgroundTracker2
//
//  Created by foundry on 02/03/2013.
//  Copyright (c) 2013 foundry. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate>

    //@property (nonatomic,assign) CGFloat samplingFrequency;
@property (nonatomic, strong) NSURL* bufferFileURL;

@property (strong, nonatomic) UIWindow *window;

@end
