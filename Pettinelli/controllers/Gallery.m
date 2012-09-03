//
//  Gallery.m
//  Pettinelli
//
//  Created by Andrea Barbon on 31/08/12.
//  Copyright (c) 2012 fractalsoft srl. All rights reserved.
//

#import "Gallery.h"

@interface Gallery ()

@end

@implementation Gallery

@synthesize images;

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
    
    screen_width = [[UIScreen mainScreen] bounds].size.width;

    [sv setContentSize:CGSizeMake(screen_width*images.count, screen_width)];
    
    int i = 0;
    
    for (NSDictionary *image in images) {
        
        CGRect rect = CGRectMake(i*screen_width, 0, screen_width, screen_width);
        UIImageView *iv = [[UIImageView alloc] initWithFrame:rect];
        [iv setImageWithURL:[NSURL URLWithString:[[[image objectForKey:@"photo_file"] objectForKey:@"medium"] objectForKey:@"url"]]];
        NSLog(@"%@", [[[image objectForKey:@"photo_file"] objectForKey:@"medium"] objectForKey:@"url"]);
        i++;
        [sv addSubview:iv];
    }
    
    [pageControl setNumberOfPages:images.count];

    [MBProgressHUD hideHUDForView:self.view animated:YES];

}


#pragma mark -
#pragma mark scrollView delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    int i = (int)((scrollView.contentOffset.x)/(screen_width-1));
    [pageControl setCurrentPage:i];
    
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

@end
