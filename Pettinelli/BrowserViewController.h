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
#import "PettinelliViewController.h"



@interface BrowserViewController : PettinelliViewController <UITableViewDataSource, UITableViewDelegate, NSURLConnectionDelegate, SDWebImageManagerDelegate> {
    
    NSMutableData *data;
    BOOL loading;
    BOOL no_reloading;
    BOOL connected;
    NSString *imageSize;
    
    NSURLConnection *connectionJSON;
    
}

@property(nonatomic, retain) IBOutlet UITableView *tv;
@property(nonatomic, retain) NSString *url;
@property(nonatomic, retain) NSMutableArray *items;
@property(nonatomic) BOOL shouldStartLater;
@property(nonatomic) BOOL firstTime;

#pragma mark -
#pragma mark TOOLS

- (IBAction)reload;
- (void)sendRequest;
- (Cell*)newCustomCell;
- (void)checkReachability;

@end

