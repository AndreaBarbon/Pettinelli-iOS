//
//  AppDelegate.h
//  Pettinelli
//
//  Created by Andrea Barbon on 28/08/12.
//  Copyright (c) 2012 fractalsoft srl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVAudioPlayer.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "MBProgressHUD.h"


#define HOST @"http://pettinelli.herokuapp.com"
//#define HOST @"http://169.254.82.155:3000"
//#define HOST @"http://localhost:3000"

#ifdef FRACTAL_DEBUG
#define DLog(fmt, ...) DLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...);
#endif


@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) IBOutlet UIWindow *window;
@property (strong, nonatomic) IBOutlet UITabBarController *tabBarController;


@end


