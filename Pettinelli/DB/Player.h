//
//  Player.h
//  Pettinelli
//
//  Created by Andrea Barbon on 18/09/12.
//  Copyright (c) 2012 fractalsoft srl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Record;

@interface Player : NSManagedObject


@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSMutableArray *cards;

@property(nonatomic) int score;
@property(nonatomic) int moves;
@property(nonatomic) int moves_left;

@property(nonatomic) BOOL playing;

@property (nonatomic, retain) NSNumber * victories;
@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) NSSet *records;
@property (nonatomic, retain) NSDate *date;

-(void)addBonusMove;
-(void)addMove;

@end


@interface Player (CoreDataGeneratedAccessors)

- (void)addRecordsObject:(Record *)value;
- (void)removeRecordsObject:(Record *)value;
- (void)addRecords:(NSSet *)values;
- (void)removeRecords:(NSSet *)values;

@end
