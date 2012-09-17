//
//  Memory.m
//  Pettinelli
//
//  Created by Andrea Barbon on 31/08/12.
//  Copyright (c) 2012 fractalsoft srl. All rights reserved.
//

#import "Memory.h"
#import "Card.h"
#import "Image.h"
#import "Record.h"
#import "Player.h"

@interface Memory ()

@end

@implementation Memory
@synthesize managedObjectContext;

@synthesize cards, photos;


#define MARGIN_LEFT 5
#define PADDING 1

- (void)viewDidLoad
{

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        margin_top = 140;
    else
        margin_top = 100;
    
    
    CARD_NUM = 4;   //Needs to be even
    
    cards =         [[NSMutableArray alloc] initWithCapacity:CARD_NUM*CARD_NUM];
    photos =        [[NSMutableArray alloc] initWithCapacity:CARD_NUM*CARD_NUM];
    flipped_cards = [[NSMutableArray alloc] initWithCapacity:3];
    players =       [[NSMutableArray alloc] initWithCapacity:4];
    
    self.url=@"galleries.json";     [super viewDidLoad];    [self loadSounds];
    
    
    for (int i=0; i<1; i++) {
        
        Player *player = [[Player alloc] init];
        player.name = [NSString stringWithFormat:@"Giocatore %d", i+1];
        player.index = i;
        [players addObject:player];
    }
    
//    Player *player2 = [[Player alloc] init];
//    player2.name = @"Giocatore 2";
//    player2.index = 1;
//    [players addObject:player2];
    
    
}

- (void)handleOfflineSituation {
    
    DLog(@"I'm offline, and I'm a memory");
    photos = nil;
    photos = [[NSMutableArray alloc] initWithArray:[self fetchImages]];
    
    if (photos.count>=CARD_NUM*CARD_NUM/2) {
        [self buildCardsOffline];
        
    } else {
        NSLog(@"Not enough cards: Only %d", photos.count);
    }
    
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
    
    [self reload];
}

- (void)loadSounds {
    
    found_sound = [Abramo loadSound:@"found" format:@"mp3" volume:1];
    flip_sound = [Abramo loadSound:@"flip" format:@"mp3" volume:2];

}

- (void)clean {
    
    for (Player *player in players) {
        player.moves = 1;
        player.score = 0;
        player.moves_left = 0;
        [player.cards removeAllObjects];
    }
    
    current_player = [players objectAtIndex:0];
    [current_player addMove];
        
    if (CARD_NUM == 4) {
        [menu setSelectedSegmentIndex:0];
    } else {
        [menu setSelectedSegmentIndex:1];
    }
    
    score = 0;
    [scoreLabel setText:[NSString stringWithFormat:@"Punteggio: %d", current_player.score]];
    [playerLabel setText:current_player.name];
    
    if (cards.count > 0) {

        for (Card *card in cards) {
            [card removeFromSuperview];
        }
        [cards removeAllObjects];
        [flipped_cards removeAllObjects];
    }
    
}

- (void)buildCards {
    
    NSLog(@"Building cards...");
      
    //Clean
    [self clean];
        
    //Compute the size
    float card_size = [self computeCardSize];
    
    //Shuffle the photos
    [self shufflePhotos];
    
    for (int i=0; i<CARD_NUM; i++) {
        for (int j=0; j<CARD_NUM; j++) {
            
            CGRect rect = CGRectMake(MARGIN_LEFT + i*(card_size+PADDING),margin_top + j*(card_size+PADDING), card_size, card_size);
            
            Card *card = [[Card alloc] initWithFrame:rect delegate:self];
            
            [cards addObject:card];
        }
    }
    
    NSLog(@"Now let's download the images");
    
    imagesReady = -1;
    [self nextImage];

}

- (void)buildCardsOffline {
    
    NSLog(@"Building cards...");
    
    //Clean
    [self clean];
    
    //Compute the size
    float card_size = [self computeCardSize];
    
    //Shuffle the photos
    [self shufflePhotos];
    
    for (int i=0; i<CARD_NUM; i++) {
        for (int j=0; j<CARD_NUM; j++) {
            
            CGRect rect = CGRectMake(MARGIN_LEFT + i*(card_size+PADDING),margin_top + j*(card_size+PADDING), card_size, card_size);
            
            NSString *url   = [[photos objectAtIndex:(i+CARD_NUM*j)] name];
            UIImage *image  = [UIImage imageWithData:[[photos objectAtIndex:(i+CARD_NUM*j)] data]];
            
            Card *card = [[Card alloc] initWithFrame:rect delegate:self];
            [card setCardImage:image url:url];
            [cards addObject:card];
        }
    }
    
    NSLog(@"Now let's draw the cards");
    
    [self drawCards];
    
}

- (void)shufflePhotos {
    
    photos = [Abramo shuffleArray:photos];

    NSMutableArray *random = [[NSMutableArray alloc] initWithCapacity:CARD_NUM*CARD_NUM/2];
    
    for (int i=0; i<CARD_NUM*CARD_NUM/2; i++) {
        
        [random addObject:[photos objectAtIndex:i]];
        [random addObject:[photos objectAtIndex:i]];
    }
    
    photos = [Abramo shuffleArray:random];
}

- (float)computeCardSize {
    
    int screen_width = [[UIScreen mainScreen] bounds].size.width;
    int screen_heigth = [[UIScreen mainScreen] bounds].size.height;
    
    int margin;
    if (screen_width<screen_heigth) {
        margin = MARGIN_LEFT;
    } else {
        margin = margin_top;
    }
    
    int screen_size = MIN(screen_heigth, screen_width);
    return (screen_size-(margin*2)-(CARD_NUM-1)*PADDING)/CARD_NUM;
}


- (void)drawCards {
    
    for (Card *card in cards) {

        [self.view addSubview:card];
    }
    
    loading = NO;
    [MBProgressHUD hideHUDForView:self.view animated:YES];
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
    
    if (photos.count>=CARD_NUM*CARD_NUM/2) {
        [self performSelectorOnMainThread:@selector(buildCards) withObject:nil waitUntilDone:YES];
        
    } else {
        NSLog(@"Not enough cards: Only %d", photos.count);
    }        
}


- (void)checkForWinner {
    
    for (Card *card in cards) {
        if (!card.founded) {
            return;
        }
    }
    NSString *s = [[NSString alloc] initWithFormat:@"Hai vinto! \n\n 👍 😄 😊 😃 ☺ 😉 👍 \n \n Punteggio: %d \n Mosse: %d", current_player.score, current_player.moves];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:current_player.name message:s delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
    
    [menu setSelectedSegmentIndex:2];

}

- (void)flopAllCards {
    
    for (Card *old_card in flipped_cards) {
        if (!old_card.founded) [old_card flop];
    }
    
    [flipped_cards removeAllObjects];

}

- (void)nextImage {
    
    imagesReady ++;
    
    if (imagesReady>1) {
        
        NSString *url = [photos objectAtIndex:imagesReady-1];
        if (![self isThereTheImageNamed:url]) {
            
            [self addImageWithName:url data:data];
        }
    }
    
    
    if (imagesReady == CARD_NUM*CARD_NUM) {
        
        NSLog(@"All the images downloaded!");
        
        [self drawCards];

    } else {
        
        data = nil;
        data = [[NSMutableData alloc] init];
        currentImageUrl = [photos objectAtIndex:imagesReady];
        
        if ([self isThereTheImageNamed:currentImageUrl]) {
            
            NSLog(@"It was there!");
            UIImage *image = [UIImage imageWithData:[self dataForImageNamed:currentImageUrl]];
            [(Card*)[cards objectAtIndex:imagesReady] setCardImage:image url:currentImageUrl];
            [self nextImage];
            
        } else {
            
            NSLog(@"Downloading new image: %@", currentImageUrl);
            
            NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:currentImageUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:2.0];
            
            connectionImage = [NSURLConnection connectionWithRequest:request delegate:self];
        }
    }
    
}


#pragma mark Card Delegate

- (void)cardFlipped:(Card *)card {
    
    DLog(@"FLIPPED! \n CARD URL: \n, %@ \n\n", card.imageURL);
    
    NSLog(@"Moves left: %d", current_player.moves_left);
    
    [flip_sound play];
    
    moves ++;
    
    if (flipped_cards.count==2) {
        [self flopAllCards];

    } else
    
    if (flipped_cards.count==0) {
        [flipped_cards addObject:card];
        
    } else
        
    if (flipped_cards.count==1) {
        
        [flipped_cards addObject:card];
        DLog(@"2");
        if ([[[flipped_cards objectAtIndex:0] imageURL] isEqualToString:[[flipped_cards objectAtIndex:1] imageURL]]) {
            
            // ******** 😄 😊 😃 Founded! 😄 😊 😃 *******
            
            //Give credit to the player
            [current_player.cards addObject:[flipped_cards objectAtIndex:0]];
            [current_player addBonusMove];
            current_player.score ++;

            [[flipped_cards objectAtIndex:0] setFounded:YES];
            [[flipped_cards objectAtIndex:1] setFounded:YES];
            [found_sound play];
            [self checkForWinner];
            [self flopAllCards];
        }
                
    }
    
    current_player.moves_left --;
    
    if (current_player.moves_left==0) {
        
        //Set a move on the old player
        current_player.moves ++;
        
        //and create a new one (if needed)r
        int i = (current_player.index + 1)%players.count;
        current_player = [players objectAtIndex:i];
        [current_player addMove];
        NSLog(@"%@'s turn now!", current_player.name);
        [flip_sound play];
    }
    
    [playerLabel setText:current_player.name];
    [scoreLabel setText:[NSString stringWithFormat:@"Punteggio: %d, Mosse: %d", current_player.score, current_player.moves]];

    
}

- (void)cardFlopped:(Card *)card {
    
    DLog(@"FLOPPED!");
        
    [self flopAllCards];
    
}

- (BOOL)canFlipCard:(Card *)card {
    
    switch (flipped_cards.count) {
            
        case 1:     return !card.flipped;
            break;
            
        case 2:     return card.flipped;
            break;
            
        default:    return YES;
            break;
    }
}


#pragma mark -
#pragma mark NSURLConnection delegate

- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
    
	if (theConnection==connectionImage) {
        
        DLog(@"Got one image!");
        [[cards objectAtIndex:imagesReady] setCardImage:[UIImage imageWithData:data] url:currentImageUrl];
        [self nextImage];
        
    } else {

        NSLog(@"Json downloaded, now let's parse it");
        [NSThread detachNewThreadSelector:@selector(parseJSON) toTarget:self withObject:nil];
    }
	
}

#pragma mark CoreData 

- (void)addImageWithName:(NSString*)name data:(NSData*)imgdata {
    
	NSManagedObjectContext *context = [self managedObjectContext];
    
    Image *image = [NSEntityDescription
                    insertNewObjectForEntityForName:@"Image" 
                    inManagedObjectContext:context];
    
    image.name = name;
    image.data = imgdata;
    
	//Effettuiamo il salvataggio gestendo eventuali errori
	NSError *error;
	if (![context save:&error]) {
		NSLog(@"Errore durante il salvataggio: %@", [error localizedDescription]);
	} else {
        NSLog(@"Created image named: %@", name);
    }
}

- (BOOL)isThereTheImageNamed:(NSString*)name {
    
    NSManagedObjectContext *context = [self managedObjectContext];

    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Image" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    // The request looks for this a group with the supplied name
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", name];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSUInteger count = [managedObjectContext countForFetchRequest:request error:&error];

    
    if (!error){
        return count;
    }
    else
        return NO;
}

- (NSData*)dataForImageNamed:(NSString*)name {
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Image" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    // The request looks for this a group with the supplied name
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", name];
    [request setPredicate:predicate];
    [request setFetchLimit:1];
    
    NSError *error = nil;
    Image *image = [[managedObjectContext executeFetchRequest:request error:&error] lastObject];
    
    return image.data;
    
}

- (NSArray*)fetchImages {
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Image" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    
    NSArray *array = [context executeFetchRequest:request error:&error];
    
    if ([array count] == 0) {
        NSLog(@"Error = %@", error);
    }
    
    return array;
}

- (NSArray*)fetchRecords {
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Record" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"score" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    
    NSArray *array = [context executeFetchRequest:request error:&error];
    
    if ([array count] == 0) {
        NSLog(@"Error = %@", error);
    }
    
    return array;
}

- (Record*)newRecord {
    
    return [NSEntityDescription
            insertNewObjectForEntityForName:@"Record" 
            inManagedObjectContext:self.managedObjectContext];
}







@end
