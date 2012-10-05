//
//  Player.m
//  Pettinelli
//
//  Created by Andrea Barbon on 18/09/12.
//  Copyright (c) 2012 fractalsoft srl. All rights reserved.
//

#import "Player.h"
#import "Record.h"


@implementation Player

@dynamic index;
@dynamic name;
@dynamic victories;
@dynamic records;
@dynamic date;


@synthesize playing, score, moves;

@synthesize cards, moves_left;

- (id)init {
    
    self = [super init];
    
    cards = [[NSMutableArray alloc] init];
    
    return self;
}

-(void)addBonusMove {
    
    moves_left += 2;
}

-(void)addMove {
    
    moves_left += 3;
}


@end
