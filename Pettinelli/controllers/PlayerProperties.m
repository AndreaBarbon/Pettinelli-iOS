//
//  PlayerProperties.m
//  Pettinelli
//
//  Created by Andrea Barbon on 17/09/12.
//  Copyright (c) 2012 fractalsoft srl. All rights reserved.
//

#import "PlayerProperties.h"
#import "Player.h"

@interface PlayerProperties ()

@end

@implementation PlayerProperties

@synthesize nameField, indexLabel, playingSwitch;

- (void)setPlayerProperties:(Player*)player {
    
    indexLabel.text = [NSString stringWithFormat:@"%d", [player.index intValue]+1];
    nameField.text = player.name;
    nameField.placeholder = player.name;
    playingSwitch.on = player.playing;
    
    NSLog(@"Player name: %@", player.name);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([textField.text isEqualToString:@""]) {
        textField.text = textField.placeholder;
    }
    
    [textField resignFirstResponder];
    return NO;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    if ([textField.text isEqualToString:@""]) {
        textField.text = textField.placeholder;
    }
    return YES;
}

@end
