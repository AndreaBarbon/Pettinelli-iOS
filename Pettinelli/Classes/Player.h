//
//  Player.h
//  Pettinelli
//
//  Created by Andrea Barbon on 16/09/12.
//  Copyright (c) 2012 fractalsoft srl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Player : NSObject

@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSMutableArray *cards;

@property(nonatomic) int score;
@property(nonatomic) int index;
@property(nonatomic) int moves;
@property(nonatomic) int moves_left;

-(void)addBonusMove;
-(void)addMove;

@end
