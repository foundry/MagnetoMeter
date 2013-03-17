//
//  AppDelegate.m
//  BackgroundTracker2
//
//  Created by foundry on 02/03/2013.
//  Copyright (c) 2013 foundry. All rights reserved.
//

#import "AppDelegate.h"
#import "CLMManager.h"
#import "InverseProgressView.h"
#import "ForwardProgressView.h"
#import "UIImage+FillColor.h"

@interface AppDelegate() 


@end
@implementation AppDelegate 

-            (BOOL)application:(UIApplication *)application
 didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    CGFloat strongTone = 0.90;
      CGFloat weakTone = 0.50;
    UIColor* backColor = [UIColor colorWithWhite:strongTone
                                           alpha:1.0];
    UIColor* foreColor = [UIColor colorWithRed:strongTone
                                         green:weakTone
                                          blue:weakTone
                                         alpha:1.0];
    
  
    UIImage* backImage = [UIImage fillImgOfSize:(CGSize){10,10}
                                      withColor:backColor];
    UIImage* foreImage   = [UIImage fillImgOfSize:(CGSize){10,10}
                                        withColor:foreColor];


    [application setStatusBarStyle:UIStatusBarStyleBlackOpaque];
        // [[UIProgressView appearance] setProgressViewStyle:UIProgressViewStyleBar];
        [[UIProgressView appearance] setProgressImage:foreImage];
         [[UIProgressView appearance] setTrackImage:backImage];
    
        //[[InverseProgressView appearance] setProgressImage:whiteImage];
        // [[InverseProgressView appearance] setTrackImage:redImage];
    [[UISlider appearance] setMinimumTrackTintColor:foreColor];

    return YES;
}


- (NSURL*) bufferFileURL
{
    if (!_bufferFileURL) {
        NSFileManager* fileManager = [NSFileManager defaultManager];
        NSError* error = [[NSError alloc] init];
        NSURL* docsURL = [fileManager URLForDirectory:NSDocumentDirectory
                                          inDomain:NSUserDomainMask
                                 appropriateForURL:nil
                                            create:YES
                                              error:&error];
        if (!docsURL) {
            NSLog(@"error %@",error);

        } else {
            NSLog(@"no error");

        }
        
        _bufferFileURL = [docsURL URLByAppendingPathComponent:@"savedBuffer"];
    }
    return _bufferFileURL;
}



- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
