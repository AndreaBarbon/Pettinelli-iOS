//
//  WebBrowserController.h
//  Pettinelli
//
//  Created by Andrea Barbon on 05/10/12.
//  Copyright (c) 2012 fractalsoft srl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebBrowserController : UIViewController <UIWebViewDelegate>


@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) UIViewController *delegate;

@end
