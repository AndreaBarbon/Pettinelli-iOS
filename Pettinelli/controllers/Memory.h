//
//  Memory.h
//  Pettinelli
//
//  Created by Andrea Barbon on 31/08/12.
//  Copyright (c) 2012 fractalsoft srl. All rights reserved.
//

#import "BrowserViewController.h"
#import "Card.h"
@class Player;

@interface Memory : BrowserViewController <CardProtocol> {
    
    NSMutableArray *flipped_cards;
    NSMutableArray *players;

    IBOutlet UISegmentedControl *menu;
    IBOutlet UILabel *playerLabel;
    IBOutlet UILabel *scoreLabel;

    int CARD_NUM;
    int imagesReady;
    NSString *currentImageUrl;
    
    AVAudioPlayer *found_sound;
    AVAudioPlayer *flip_sound;
    int moves;
    int score;
    int margin_top;
    
    Player *current_player;
    
    NSURLConnection *connectionImage;

}

@property(nonatomic, retain) NSMutableArray *cards;
@property(nonatomic, retain) NSMutableArray *photos;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
