//
//  BrowserViewController.m
//  Pettinelli
//
//  Created by Andrea Barbon on 28/08/12.
//  Copyright (c) 2012 fractalsoft srl. All rights reserved.
//

#import "BrowserViewController.h"
#import "SBJson.h"
#import <SDWebImage/UIImageView+WebCache.h>

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
    
    df = [[NSDateFormatter alloc] init];            [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    dfHuman = [[NSDateFormatter alloc] init];       [dfHuman setDateFormat:@"EEEE dd/MM/yyyy"];
    NSLocale *loc = [[NSLocale alloc] initWithLocaleIdentifier:@"it"];

    dfHuman.locale = loc;

        
    if (url==nil) url = @"http://localhost:3000/posts.json";
    
    [self parseJSON];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (FALSE) {
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;        
        return 0;
        
    } else {
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        //[MBProgressHUD hideHUDForView:self.view animated:TRUE];
        return [items count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int r = indexPath.row;
	static NSString *CellIdentifier = @"cell";
	UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        /*
        NSString *nib;
        float fontSize;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            
            nib = @"BlogCell_iPad";
            fontSize = 26.0;
            
        }else{  
            nib = @"BlogCell";
            fontSize = 12.0;
            
        }
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:nib owner:self options:nil];
		cell = [topLevelObjects objectAtIndex:0];
        */
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
    }
    
    NSString *s;

    s = [dfHuman stringFromDate:[df dateFromString:[[items objectAtIndex:r] objectForKey:@"date"]]];
    [cell.detailTextLabel setText:s];    

    s = [[items objectAtIndex:r] objectForKey:@"title"];
    [cell.textLabel setText:s];

    s = [[[[items objectAtIndex:r] objectForKey:@"image"] objectForKey:@"thumb"] objectForKey:@"url"];

    [cell.imageView setImageWithURL:[NSURL URLWithString:s]
               placeholderImage:[UIImage imageNamed:@"Letter.png"]];
    
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

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{    
//    int r = indexPath.row;    
//    
//    
//    [self.navigationController pushViewController:postViewController animated:YES];
//    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
//    
//    
//}


#pragma mark -
#pragma mark JSON

- (void)parseJSON {
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    
    NSArray *posts_temp = [parser objectWithString:json_string error:nil];
    items = [[NSMutableArray alloc] initWithCapacity:posts_temp.count];
    
    for (NSDictionary *post in posts_temp)
    {
        [items addObject:[post objectForKey:@"model"]];
    }
    
    for (NSDictionary *post in items)
    {
        NSLog(@"%@ - %@", [post objectForKey:@"author"], [post objectForKey:@"title"]);
    }
    
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
