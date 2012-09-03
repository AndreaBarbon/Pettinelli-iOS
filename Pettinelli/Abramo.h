//
//  Abramo.h
//  Pettinelli
//
//  Created by Andrea Barbon on 31/08/12.
//  Copyright (c) 2012 fractalsoft srl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Abramo : NSObject {

}

+ (NSMutableArray*)shuffleArray:(NSMutableArray*)array;
+ (AVAudioPlayer*)loadSound:(NSString*)name format:(NSString*)format volume:(float)volume;

@end
