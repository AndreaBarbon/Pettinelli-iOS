//
//  NewGame.m
//  Pettinelli
//
//  Created by Andrea Barbon on 17/09/12.
//  Copyright (c) 2012 fractalsoft srl. All rights reserved.
//

#import "NewGame.h"
#import "PlayerProperties.h"
#import "Player.h"

@interface NewGame ()

@end

@implementation NewGame

@synthesize delegate, properties, difficulty;

- (IBAction)startGame:(id)sender {
        
    NSMutableArray *nonPlayingPlayers = [[NSMutableArray alloc] initWithCapacity:delegate.players.count];
    NSMutableArray *playingPlayers = [[NSMutableArray alloc] initWithCapacity:delegate.players.count];
    
    for (int i=0; i<delegate.players.count; i++) {
        
        Player *player = [delegate.players objectAtIndex:i];
        player.name = [[properties objectAtIndex:i] nameField].text;
        player.playing = [[properties objectAtIndex:i] playingSwitch].on;
        
        if (player.playing) {
            
            [playingPlayers addObject:player];
                        
        } else {
            
            [nonPlayingPlayers addObject:player];
        }
    }
    
    [delegate.players removeAllObjects];
    [delegate.players addObjectsFromArray:playingPlayers];
    [delegate.players addObjectsFromArray:nonPlayingPlayers];
    
    int i = 0;
    for (Player *player in delegate.players) {
        
        player.index = [NSNumber numberWithInt:i];
        NSLog(@"Name: %@,  index = %d",  player.name, player.index.intValue);
        i++;
        
    }
    
    
    switch (difficulty.selectedSegmentIndex) {
        case 0:
            [delegate startGameWithCardNumber:4];
            break;
            
        case 1:
            [delegate startGameWithCardNumber:6];
            break;
        
        case 2:
            [delegate startGameWithCardNumber:8];
            break;
            
        default:
            break;
    }    
}

- (IBAction)undo:(id)sender {
    
    [delegate undoGame];
}

- (id)initWithDelegate:(id)del
{
    self = [super init];
    if (self) {
        self.delegate = del;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    properties = [[NSMutableArray alloc] initWithCapacity:delegate.players.count];
//      float w = [[UIScreen mainScreen] bounds].size.width;

    
    for (int i=0; i<4; i++) {
        PlayerProperties *prop = [[PlayerProperties alloc] init];

        
        [self.view addSubview:prop.view];
        float h = prop.view.bounds.size.height;
        float topMargin = 110.0;
        prop.view.center = CGPointMake(prop.view.center.x, topMargin + i*h);
        
        
        
        Player *player = [delegate.players objectAtIndex:i];
        player.index = [NSNumber numberWithInt:i];
        [prop setPlayerProperties:player];


        [properties addObject:prop];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

@end
