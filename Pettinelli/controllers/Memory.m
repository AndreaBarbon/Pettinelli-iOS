//
//  Memory.m
//  Pettinelli
//
//  Created by Andrea Barbon on 31/08/12.
//  Copyright (c) 2012 fractalsoft srl. All rights reserved.
//

#import "Memory.h"
#import "Card.h"

@interface Memory ()

@end

@implementation Memory

@synthesize cards, photos;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#define MARGIN_LEFT 5
#define PADDING 1

- (void)viewDidLoad
{

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        margin_top = 100;
    } else {  
        margin_top = 70;
    }
    
    //Needs to be even
    CARD_NUM = 4;
    
    cards = [[NSMutableArray alloc] initWithCapacity:CARD_NUM*CARD_NUM];
    photos = [[NSMutableArray alloc] initWithCapacity:CARD_NUM*CARD_NUM];
    flipped_cards = [[NSMutableArray alloc] initWithCapacity:3];
    
    self.url=@"galleries.json";
    
    [super viewDidLoad];
    
    [self loadSounds];
    
    
}

- (IBAction)menu:(id)sender {
        
    switch (menu.selectedSegmentIndex) {
        case 0:
            CARD_NUM = 4;
            [self start];
            NSLog(@"Starting easy");
            break;

        case 1:
            CARD_NUM = 6;
            [self start];
            NSLog(@"Starting hard");
            break;            
        
        default:
            break;
    }
}


- (void)start {
    
    if (CARD_NUM == 4) {
        [menu setSelectedSegmentIndex:0];
    } else {
        [menu setSelectedSegmentIndex:1];
    }

    score = 0;
    [movesLabel setText:[NSString stringWithFormat:@"Punteggio: %d", score]];

    moves = 0;
    [movesLabel setText:[NSString stringWithFormat:@"Mosse: %d", moves]];

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_queue_t main_queue = dispatch_get_main_queue();
    dispatch_async(main_queue, ^{
        
        [self parseJSON];
        
    });
}

- (void)loadSounds {
    
    found_sound = [Abramo loadSound:@"found" format:@"mp3" volume:0.1];
    flip_sound = [Abramo loadSound:@"flip" format:@"mp3" volume:0.5];

}



- (void)buildCards {
    
    if (cards.count > 0) {
        for (Card *card in cards) {
            [card removeFromSuperview];
        }
        [cards removeAllObjects];
        [flipped_cards removeAllObjects];
    }
    
    int screen_width = [[UIScreen mainScreen] bounds].size.width;
    int screen_heigth = [[UIScreen mainScreen] bounds].size.height;
    
    int margin;
    if (screen_width<screen_heigth) {
        margin = MARGIN_LEFT;
    } else {
        margin = margin_top;
    }
    
    int screen_size = MIN(screen_heigth, screen_width);
    float card_size = (screen_size-(margin*2)-(CARD_NUM-1)*PADDING)/CARD_NUM;
    
    
    NSMutableArray *random = [[NSMutableArray alloc] initWithCapacity:CARD_NUM*CARD_NUM/2];
    photos = [Abramo shuffleArray:photos];

    
    for (int i=0; i<CARD_NUM*CARD_NUM/2; i++) {
        
        [random addObject:[photos objectAtIndex:i]];
        [random addObject:[photos objectAtIndex:i]];
    }
    
    random = [Abramo shuffleArray:random];

    for (int i=0; i<CARD_NUM; i++) {
        for (int j=0; j<CARD_NUM; j++) {
            
            Card *card;
            CGRect rect = CGRectMake(MARGIN_LEFT + i*(card_size+PADDING),margin_top + j*(card_size+PADDING), card_size, card_size);

            card = [[Card alloc] initWithFrame:rect url:[random objectAtIndex:(i+CARD_NUM*j)]];
            card.delegate = self;
            [cards addObject:card];
            
            [self.view addSubview:card];
            
        }
    }    
}

- (void)parseJSON {
    
    NSError *error;
    
    [photos removeAllObjects];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    DLog(@"%@", error);
    NSString *json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSArray *items_temp = [parser objectWithString:json_string error:&error];
    DLog(@"%@", error);
    self.items = [[NSMutableArray alloc] initWithCapacity:items_temp.count];
    
    NSLog(@"Downloaded %d items!", items_temp.count);
    
    for (NSDictionary *item in items_temp)
    {   
        if ([item objectForKey:@"model"] == nil) {
            self.items = [NSMutableArray arrayWithArray:items_temp];
            break;
        }
        [self.items addObject:[item objectForKey:@"model"]];
    }
    
    for (int i=0; i<self.items.count; i++)
    {        
        NSArray *photos_temp = [NSArray arrayWithArray:[[self.items objectAtIndex:i] objectForKey:@"photos"]];
        for (int j=0; j<photos_temp.count; j++) {
         
            NSString *size;
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                size=@"medium";
            } else {  
                size=@"thumb";                
            }
            
            NSString *s = [[[[photos_temp objectAtIndex:j] objectForKey:@"photo_file"] objectForKey:size] objectForKey:@"url"];
            [photos addObject:s];
        }
    }
    
    loading = NO;
    if (photos.count>=CARD_NUM*CARD_NUM/2) {
        NSLog(@"Building cards...");
        [self buildCards];
        
    } else {
        NSLog(@"Not enough cards: Only %d", photos.count);
    }
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];

        
}

- (void)cardFlipped:(Card *)card {
    
    DLog(@"FLIPPED!, %d", flipped_cards.count);
    
    [flip_sound play];
    
    moves ++;
    [movesLabel setText:[NSString stringWithFormat:@"Mosse: %d", moves]];
    
    if (flipped_cards.count==0) {
        [flipped_cards addObject:card];

    } else
        
    if (flipped_cards.count==1) {

        [flipped_cards addObject:card];
        DLog(@"2");
        if ([[[flipped_cards objectAtIndex:0] imageURL] isEqualToString:[[flipped_cards objectAtIndex:1] imageURL]]) {
            
            //Founded!
            
            score += 548;
            [scoreLabel setText:[NSString stringWithFormat:@"Punteggio: %d", score]];

            
            [[flipped_cards objectAtIndex:0] setFounded:YES];
            [[flipped_cards objectAtIndex:1] setFounded:YES];
            [found_sound play];
            [self checkForWinner];
        }
        
    } else
    
    if (flipped_cards.count==2) {
        [self flopAllCards];
        [flipped_cards addObject:card];

    }
    

}

- (void)checkForWinner {
    
    for (Card *card in cards) {
        if (!card.founded) {
            return;
        }
    }
    NSString *s = [[NSString alloc] initWithFormat:@"Complimenti!  \n\n 👍 😄 😊 😃 ☺ 😉 👍 \n \n Mosse: %d", moves];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Hai vinto!" message:s delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
    
    [menu setSelectedSegmentIndex:2];

}

- (void)cardFlopped:(Card *)card {
    
    DLog(@"FLOPPED!");
        
    [self flopAllCards];
    
}

- (void)flopAllCards {
    
    for (Card *old_card in flipped_cards) {
        if (!old_card.founded) [old_card flop];
    }
    
    [flipped_cards removeAllObjects];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
