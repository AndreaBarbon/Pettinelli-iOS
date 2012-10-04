//
//  BrowserViewController.m
//  Pettinelli
//
//  Created by Andrea Barbon on 28/08/12.
//  Copyright (c) 2012 fractalsoft srl. All rights reserved.
//

#import "BrowserViewController.h"
#import "Post.h"

@interface BrowserViewController ()

@end

@implementation BrowserViewController

@synthesize tv, url, items;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    firstTime = YES;
    [tv reloadData];
    
    if (!no_reloading) {
        
        //Create the Reload button    
        UIBarButtonItem *flipButton = [[UIBarButtonItem alloc] 
                                       initWithTitle:@"Aggiorna"                                            
                                       style:UIBarButtonItemStyleBordered 
                                       target:self 
                                       action:@selector(reload)];
        
        flipButton.image = [UIImage imageNamed:@"refresh_icon.png"];
        
        self.navigationItem.rightBarButtonItem = flipButton;
    }
        
    [self checkReachability];
}

- (void)checkReachability {
    
    if (url!=nil) {
        
        url = [NSString stringWithFormat:@"%@/%@", HOST, url];
        
        // allocate a reachability object
        Reachability* reach = [Reachability reachabilityWithHostname:HOST];
        
        // set the blocks
        reach.reachableBlock = ^(Reachability*reach)
        {
            NSLog(@"REACHABLE!");
            dispatch_async(dispatch_get_main_queue(), ^{
                
                connected = YES;
                if (firstTime) {
                    
                    [self reload];
                    firstTime = NO;
                }
            });
        };
        
        reach.unreachableBlock = ^(Reachability*reach)
        {
            NSLog(@"UNREACHABLE!");
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                connected = NO;
                if (firstTime) {
                    
                    [self handleOfflineSituation];
                    firstTime = NO;
                }
            });
        };
        
        [reach startNotifier];
    }
}

- (void)handleOfflineSituation {
    
    NSLog(@"I'm offline!");
    [MBProgressHUD hideHUDForView:self.view animated:TRUE];

}

- (void)sendRequest {
    
    data = nil;
    data = [[NSMutableData alloc] init];
    
    DLog(@"Connecting to: %@", url);
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
	connectionJSON = [NSURLConnection connectionWithRequest:request delegate:self];
}

#pragma mark - Table view data source

- (IBAction)reload {
        
    if (!loading) {
    
        NSLog(@"Reload!");

        [items removeAllObjects];
        items = nil;
        loading = YES;
        [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
                
        if (connected) {
            [self sendRequest];
        } else {
            [self handleOfflineSituation];
        }
        
        [tv reloadData];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (loading || firstTime) {
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        return 0;
    } else {
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        return 1;        
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (loading) {
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        return 0;
        
    } else {
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        return [items count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int r = indexPath.row;
	static NSString *CellIdentifier = @"Cell";
	Cell *cell = (Cell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        NSString *nib;
        float fontSize;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            
            nib = @"Cell_iPad";
            fontSize = 26.0;
            
        }else{  
            nib = @"Cell";
            fontSize = 12.0;
            
        }
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:nib owner:self options:nil];
		cell = [topLevelObjects objectAtIndex:0];
    
    }
    
    NSString *s;

    s = [self humanDate:[[items objectAtIndex:r] objectForKey:@"date"]];
    [cell.detailLabel setText:s];

    s = [[items objectAtIndex:r] objectForKey:@"title"];
    [cell.titleLabel setText:s];

    s = [[[[items objectAtIndex:r] objectForKey:@"image"] objectForKey:@"thumb"] objectForKey:@"url"];

    [cell.imageView setImageWithURL:[NSURL URLWithString:s]
               placeholderImage:[UIImage imageNamed:@"Pettinelli.png"]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        
        return 180;
        
    }else{  
        return 80;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    int r = indexPath.row;
    
    Post *post = [[Post alloc] init];
    post.title = [[items objectAtIndex:r] objectForKey:@"title"];
    post.body = [[items objectAtIndex:r] objectForKey:@"body"];
    post.date = [self humanDate:[[items objectAtIndex:r] objectForKey:@"date"]];
    post.navigationItem.title = post.date;
    post.image = [[[[items objectAtIndex:r] objectForKey:@"image"] objectForKey:@"medium"] objectForKey:@"url"];
    
    [self.navigationController pushViewController:post animated:YES];
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
    
}


#pragma mark -
#pragma mark JSON

- (void)parseJSON {
    
    DLog(@"Parsing JSON");
    
    NSError *error;
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    DLog(@"%@", error);
    NSString *json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSArray *items_temp = [parser objectWithString:json_string error:&error];
    DLog(@"%@", error);
    items = [[NSMutableArray alloc] initWithCapacity:items_temp.count];
    
    DLog(@"Downloaded %d items!", items_temp.count);
        
    for (NSDictionary *item in items_temp)
    {   
        if ([item objectForKey:@"model"] == nil) {
            items = [NSMutableArray arrayWithArray:items_temp];
            break;
        }
        [items addObject:[item objectForKey:@"model"]];
    }
    
    for (NSDictionary *item in items)
    {
        DLog(@"%@ - %@", [item objectForKey:@"author"], [item objectForKey:@"title"]);
    }
    
    loading = NO;
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    [tv reloadData];
    
}


#pragma mark -
#pragma mark NSURLConnection delegate

- (void)connection:(NSURLConnection *)connection_ didFailWithError:(NSError *)error{
    
    NSLog(@"Connection error");
    connected = NO;
    [NSThread sleepForTimeInterval:1];
    loading = NO;
    [MBProgressHUD hideHUDForView:self.view animated:YES];

}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{  
	[data setLength:0];
    connected = YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data_{ 
	[data appendData:data_];
	
}

- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
    
	[NSThread detachNewThreadSelector:@selector(parseJSON) toTarget:self withObject:nil];
	
}


@end
