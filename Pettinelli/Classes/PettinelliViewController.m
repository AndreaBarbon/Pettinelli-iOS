//
//  PettinelliViewController.m
//  Pettinelli
//
//  Created by Andrea Barbon on 13/09/12.
//  Copyright (c) 2012 fractalsoft srl. All rights reserved.
//

#import "PettinelliViewController.h"

@interface PettinelliViewController ()

@end

@implementation PettinelliViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    df = [[NSDateFormatter alloc] init];            [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    dfHuman = [[NSDateFormatter alloc] init];       [dfHuman setDateFormat:@"dd/MM/yyyy"];
    NSLocale *loc = [[NSLocale alloc] initWithLocaleIdentifier:@"it"];
    
    dfHuman.locale = loc;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        return (YES);   
    } else {  
        return (interfaceOrientation == UIInterfaceOrientationPortrait);   
    }
}


#pragma mark -
#pragma mark TOOLS

- (NSString*)humanDate:(NSString*)raw {
    
    return [dfHuman stringFromDate:[df dateFromString:raw]];
    
}

- (void)loadSound:(NSString*)name format:(NSString*)format reference:(AVAudioPlayer*)sound {
    
    NSString *soundPath =[[NSBundle mainBundle] pathForResource:name ofType:format];
    NSURL *soundURL = [NSURL fileURLWithPath:soundPath];
    sound = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:nil];
    sound.volume = 0.3;
    [sound prepareToPlay];
    
    if ([sound respondsToSelector:@selector(setEnableRate:)]) {
        sound.enableRate = YES;
        sound.rate = 1.5; 
    }
}


@end
