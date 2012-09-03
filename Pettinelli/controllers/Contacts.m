//
//  Contacts.m
//  Pettinelli
//
//  Created by Andrea Barbon on 03/09/12.
//  Copyright (c) 2012 fractalsoft srl. All rights reserved.
//

#import "Contacts.h"
#import "MyAnnotation.h"

#define EMAIL @"info@pettinellisportcenter.it"
#define TEL @"041 985000"

@interface Contacts ()

@end

@implementation Contacts



- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setLocations];
    // Do any additional setup after loading the view from its nib.
}

- (void)setLocations {
    
    [map removeAnnotation:myAnnotation1];
    
    CLLocationCoordinate2D theCoordinate1;
    theCoordinate1.latitude = 45.491254;
    theCoordinate1.longitude = 12.24319;
    
	myAnnotation1=[[MyAnnotation alloc] init];
    
	myAnnotation1.coordinate=theCoordinate1;
	myAnnotation1.title=@"Pettinelli Sport Centrer";
	myAnnotation1.subtitle=@"Mestre";
    
	[map addAnnotation:myAnnotation1];
    
    
    
    if([map.annotations count] == 0)
        return;
    
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    for(MyAnnotation* annotation in map.annotations)
    {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
    
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    //region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1;
    //region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1;
    
    region.span.latitudeDelta = 0.01;
    region.span.longitudeDelta = 0.01;
    
    region = [map regionThatFits:region];
    [map setRegion:region animated:YES];
    
}

#pragma mark -
#pragma mark Actions

- (void)operURL:(NSString*)url {
    
}

- (IBAction)fb:(id)sender {
}
- (IBAction)web:(id)sender {
}
- (IBAction)youtube:(id)sender {
}    

- (IBAction)address:(id)sender {
    
    [self setLocations];
}

- (IBAction)call:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", TEL]]];
    
}

- (IBAction)mail:(id)sender {
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    [picker setToRecipients:[NSArray arrayWithObject:EMAIL]];
    
    picker.navigationBar.tintColor = [UIColor colorWithRed:26.0/255.0 green:123.0/255.0 blue:248.0/255.0 alpha:1];
    
    [self presentModalViewController:picker animated:YES];
    
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{ 
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultSent:
            break;
        case MFMailComposeResultFailed:
            break;
            
        default:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email" message:@"Sending Failed - Unknown Error :-("
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];

        }
            
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
