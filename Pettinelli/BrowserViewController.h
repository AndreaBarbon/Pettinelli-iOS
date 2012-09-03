//
//  BrowserViewController.h
//  Pettinelli
//
//  Created by Andrea Barbon on 28/08/12.
//  Copyright (c) 2012 fractalsoft srl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SBJson.h"
#import "Cell.h"



@interface BrowserViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSURLConnectionDelegate, SDWebImageManagerDelegate> {
    
    NSMutableData *data;
    BOOL loading;
    BOOL no_reloading;

    NSDateFormatter *df;
    NSDateFormatter *dfHuman;
}

@property(nonatomic, retain) IBOutlet UITableView *tv;
@property(nonatomic, retain) NSString *url;
@property(nonatomic, retain) NSMutableArray *items;

#pragma mark -
#pragma mark TOOLS

- (void)loadSound:(NSString*)name format:(NSString*)format reference:(AVAudioPlayer*)sound;
- (NSString*)humanDate:(NSString*)raw;

@end

