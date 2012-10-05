//
//  WebBrowserController.m
//  Pettinelli
//
//  Created by Andrea Barbon on 05/10/12.
//  Copyright (c) 2012 fractalsoft srl. All rights reserved.
//

#import "WebBrowserController.h"

@interface WebBrowserController ()

@end

@implementation WebBrowserController

@synthesize webView, delegate;

- (IBAction)back:(id)sender {
    
    if (webView.canGoBack) {
        
        [webView goBack];
        
    } else {
        
        [self close:self];
    }
}

- (IBAction)close:(id)sender {
    
    [delegate dismissModalViewControllerAnimated:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


@end
