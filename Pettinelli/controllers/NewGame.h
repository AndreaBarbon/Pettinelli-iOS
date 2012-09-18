//
//  NewGame.h
//  Pettinelli
//
//  Created by Andrea Barbon on 17/09/12.
//  Copyright (c) 2012 fractalsoft srl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PettinelliViewController.h"

@protocol NewGameProtocol

- (void)startGameWithCardNumber:(int)n;
- (void)undoGame;

@property(nonatomic, retain) NSMutableArray *players;

@end

@class PlayerProperties, PettinelliViewController;

@interface NewGame : PettinelliViewController

@property (nonatomic, assign) id<NewGameProtocol> delegate;
@property (nonatomic, retain) NSMutableArray *properties;
@property (nonatomic, retain) IBOutlet UISegmentedControl *difficulty;

- (IBAction)startGame:(id)sender;
- (IBAction)undo:(id)sender;
- (id)initWithDelegate:(id)del;

@end
