//
//  PettinelliViewController.h
//  Pettinelli
//
//  Created by Andrea Barbon on 13/09/12.
//  Copyright (c) 2012 fractalsoft srl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PettinelliViewController : UIViewController {
    
    NSDateFormatter *df;
    NSDateFormatter *dfHuman;
}

- (void)loadSound:(NSString*)name format:(NSString*)format reference:(AVAudioPlayer*)sound;
- (NSString*)humanDate:(NSString*)raw;

@end
