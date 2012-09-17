//
//  Card.h
//  Pettinelli
//
//  Created by Andrea Barbon on 31/08/12.
//  Copyright (c) 2012 fractalsoft srl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>

@class Card;

@protocol CardProtocol

- (void)cardFlipped:    (Card*)card;
- (void)cardFlopped:    (Card*)card;
- (BOOL)canFlipCard:    (Card*)card;

@end



@interface Card : UIView <UIGestureRecognizerDelegate, NSURLConnectionDelegate> {
    IBOutlet UIView *border;
    IBOutlet UIView *background;  
    IBOutlet UIImageView *imageView; 
    IBOutlet UIImageView *imageView2; 

}

@property (nonatomic, assign) id<CardProtocol> delegate;

@property(nonatomic,retain) NSString *imageURL;
@property(nonatomic,retain) NSMutableData *data;
@property(nonatomic) BOOL flipped;
@property(nonatomic) BOOL founded;

- (void)flop;
- (id)initWithFrame:(CGRect)frame delegate:(id)del;
- (void)setCardImage:(UIImage*)image url:(NSString*)url;


@end
