//
//  Galleries.m
//  Pettinelli
//
//  Created by Andrea Barbon on 29/08/12.
//  Copyright (c) 2012 fractalsoft srl. All rights reserved.
//

#import "Galleries.h"

@interface Galleries ()

@end

@implementation Galleries

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
    self.url = [NSString stringWithFormat:@"%@/galleries.json", HOST];

    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
