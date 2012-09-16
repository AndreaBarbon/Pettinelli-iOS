//
//  Record.h
//  Pettinelli
//
//  Created by Andrea Barbon on 13/09/12.
//  Copyright (c) 2012 fractalsoft srl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Record : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) NSNumber * moves;

@end
