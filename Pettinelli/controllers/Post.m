//
//  Post.m
//  Pettinelli
//
//  Created by Andrea Barbon on 30/08/12.
//  Copyright (c) 2012 fractalsoft srl. All rights reserved.
//

#import "Post.h"

@interface Post ()

@end

@implementation Post

@synthesize title, image, body;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    no_reloading = YES;
    
    [super viewDidLoad];
    
    webView.delegate = self;
    webView.scrollView.showsHorizontalScrollIndicator = NO;
    
    [titleLabel setText:title];
 
    [self pushContentIn];    
    
    [sv setContentSize:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height + 800)];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];

}

- (void)pushContentIn {
    
    [webView removeFromSuperview];
    webView = nil;
    webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    webView.delegate = self;
    [self.view addSubview:webView];
    
    NSError *error;
    NSString *filePath;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        filePath = [[NSBundle mainBundle] pathForResource:@"post iPad" ofType:@"txt"];
    } else {
        filePath = [[NSBundle mainBundle] pathForResource:@"post" ofType:@"txt"];
    }
    
    
    NSString *s =  [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    
    NSString *HTML = [NSString stringWithFormat:@"<body><h2>%@</h2><div class=\"image-div\"><img src=\"%@\"></img></div><p>%@</p></body>", title, image, body];
    
    
    s = [NSString stringWithFormat:@"<head><style>%@</style></head>%@", s, HTML];
    
    
    [webView loadHTMLString:s baseURL:[NSURL URLWithString:@""]];
    webView.scalesPageToFit = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma WebView delegate

- (BOOL)webView:(UIWebView *)webView_ shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    
    NSString *s = [request.URL absoluteString];
    
    NSLog(@"Request: %@", s);
    
    if (s.length == 0) {

        self.navigationItem.title = self.date;
        self.navigationItem.rightBarButtonItem = nil;

    } else {
        
        webView.scalesPageToFit = YES;

        self.navigationItem.title = @"Web";
        
        //Create the Reload button
        UIBarButtonItem *flipButton = [[UIBarButtonItem alloc]
                                       initWithTitle:@"Indietro"
                                       style:UIBarButtonItemStyleBordered
                                       target:self
                                       action:@selector(back)];
                
        self.navigationItem.rightBarButtonItem = flipButton;
        

    }
    
    return YES;
}

- (void)back {
    
    if (webView.canGoBack) {

        [webView goBack];

    } else {
        
        webView.scalesPageToFit = NO;
        [self pushContentIn];
        self.navigationItem.title = self.date;
        self.navigationItem.rightBarButtonItem = nil;

    }
}


@end
