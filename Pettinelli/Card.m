//
//  Card.m
//  Pettinelli
//
//  Created by Andrea Barbon on 31/08/12.
//  Copyright (c) 2012 fractalsoft srl. All rights reserved.
//

#import "Card.h"

@implementation Card
@synthesize imageURL, flipped, delegate, founded;

- (id)initWithFrame:(CGRect)frame url:(NSString*)url
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        imageURL = [[NSString alloc] initWithString:url];
        [self setup];
    }
    return self;
}

- (void) awakeFromNib
{
    [super awakeFromNib];
    [self setup];

}

- (void)setup {

    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Letter.png"]];
    imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Letter.png"]];
    [imageView2 setImageWithURL:[NSURL URLWithString:imageURL]];
    imageView.frame = self.bounds;
    imageView2.frame = self.bounds;

    [self addSubview:imageView];
    [self addSubview:imageView2];

    [imageView2 setHidden:YES];

    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(flip)];
    tap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tap];
    
}

- (void)loadSound:(NSString*)name format:(NSString*)format reference:(AVAudioPlayer*)sound {
    
    NSString *soundPath =[[NSBundle mainBundle] pathForResource:name ofType:format];
    NSURL *soundURL = [NSURL fileURLWithPath:soundPath];
    sound = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:nil];
    sound.volume = 0.3;
    [sound prepareToPlay];
    
    if ([sound respondsToSelector:@selector(setEnableRate:)]) {
        sound.enableRate = YES;
        sound.rate = 1.5; 
    }
}

- (void)flop {
    
    flipped = NO;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:YES];

    [imageView setHidden:NO];
    [imageView2 setHidden:YES];
    
    [UIView commitAnimations];

}

- (void)flip {
    
    if (!founded) {
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationDuration:0.75];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:YES];
        
        if (flipped) {
            flipped = NO;
            [imageView setHidden:NO];
            [imageView2 setHidden:YES];
            [delegate cardFlopped:self];
        } else {
            flipped = YES;
            [imageView setHidden:YES];
            [imageView2 setHidden:NO];
            [delegate cardFlipped:self];
        }
        
        [UIView commitAnimations];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
