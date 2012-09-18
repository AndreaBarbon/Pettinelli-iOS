//
//  PlayerProperties.h
//  Pettinelli
//
//  Created by Andrea Barbon on 17/09/12.
//  Copyright (c) 2012 fractalsoft srl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Player;

@interface PlayerProperties : UIViewController <UITextFieldDelegate>

@property(nonatomic, retain) IBOutlet UILabel *indexLabel;
@property(nonatomic, retain) IBOutlet UITextField *nameField;
@property(nonatomic, retain) IBOutlet UISwitch *playingSwitch;
@property(nonatomic, retain) IBOutlet UIButton *playingButton;

- (void)setPlayerProperties:(Player*)player;

@end
