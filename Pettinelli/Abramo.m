//
//  Abramo.m
//  Pettinelli
//
//  Created by Andrea Barbon on 31/08/12.
//  Copyright (c) 2012 fractalsoft srl. All rights reserved.
//

#import "Abramo.h"

@implementation Abramo


+ (NSMutableArray*)shuffleArray:(NSMutableArray*)array {
    
    for(NSUInteger i = [array count]; i > 1; i--) {
        NSUInteger j = arc4random_uniform(i);
        [array exchangeObjectAtIndex:i-1 withObjectAtIndex:j];
    }
    
    return array;
}

+ (AVAudioPlayer*)loadSound:(NSString*)name format:(NSString*)format volume:(float)volume {
    
    NSString *soundPath =[[NSBundle mainBundle] pathForResource:name ofType:format];
    NSURL *soundURL = [NSURL fileURLWithPath:soundPath];
    
    AVAudioPlayer *sound = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:nil];
    
    sound.volume = volume;
    [sound prepareToPlay];
    
    if ([sound respondsToSelector:@selector(setEnableRate:)]) {
        sound.enableRate = YES;
        sound.rate = 1.8; 
    }
    
    return sound;
}


@end
