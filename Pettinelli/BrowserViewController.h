//
//  BrowserViewController.h
//  Pettinelli
//
//  Created by Andrea Barbon on 28/08/12.
//  Copyright (c) 2012 fractalsoft srl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrowserViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    
    NSDateFormatter *df;
    NSDateFormatter *dfHuman;
}

@property(nonatomic, retain) IBOutlet UITableView *tv;
@property(nonatomic, retain) NSString *url;
@property(nonatomic, retain) NSMutableArray *items;

@end
