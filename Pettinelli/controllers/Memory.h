//
//  Memory.h
//  Pettinelli
//
//  Created by Andrea Barbon on 31/08/12.
//  Copyright (c) 2012 fractalsoft srl. All rights reserved.
//

#import "BrowserViewController.h"
#import "Card.h"
#import "NewGame.h"
@class Player, NewGame;

@interface Memory : BrowserViewController <CardProtocol, NewGameProtocol> {
    
    NSMutableArray *flipped_cards;

    IBOutlet UISegmentedControl *menu;
    IBOutlet UILabel *playerLabel;
    IBOutlet UILabel *scoreLabel;
    IBOutlet UIView *board;
    
    NewGame *newGameController;

    int CARD_NUM;
    int imagesReady;
    NSString *currentImageUrl;
    
    AVAudioPlayer *found_sound;
    AVAudioPlayer *flip_sound;
    int moves;
    int score;
    int margin_top;
    int margin_left;
    
    Player *current_player;
    
    NSURLConnection *connectionImage;

}

@property(nonatomic, retain) NSMutableArray *players;
@property(nonatomic, retain) NSMutableArray *cards;
@property(nonatomic, retain) NSMutableArray *photos;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)menu:(id)sender;

@end
