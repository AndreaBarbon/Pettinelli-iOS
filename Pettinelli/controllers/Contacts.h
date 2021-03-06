//
//  Contacts.h
//  Pettinelli
//
//  Created by Andrea Barbon on 03/09/12.
//  Copyright (c) 2012 fractalsoft srl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MessageUI/MessageUI.h>
#import "PettinelliViewController.h"

@class MyAnnotation;

@interface Contacts : PettinelliViewController <MKMapViewDelegate, MFMailComposeViewControllerDelegate> {
    
    IBOutlet MKMapView *map;
    IBOutlet UIView *infoView;
    MyAnnotation* myAnnotation1;
}

- (IBAction)address:(id)sender; 
- (IBAction)call:(id)sender;
- (IBAction)mail:(id)sender;
- (IBAction)web:(id)sender;
- (IBAction)fb:(id)sender;
- (IBAction)youtube:(id)sender;

@end
