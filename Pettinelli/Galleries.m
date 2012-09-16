//
//  Galleries.m
//  Pettinelli
//
//  Created by Andrea Barbon on 29/08/12.
//  Copyright (c) 2012 fractalsoft srl. All rights reserved.
//

#import "Galleries.h"
#import "Gallery.h"

@interface Galleries ()

@end

@implementation Galleries

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
    self.url = @"galleries.json";

    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int r = indexPath.row;
    static NSString *CellIdentifier = @"Cell";
	Cell *cell = (Cell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    DLog(@"Creating cell %d", r);

    
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
    
    s = [self humanDate:[[self.items objectAtIndex:r] objectForKey:@"date"]];
    [cell.detailLabel setText:s];
    
    s = [[self.items objectAtIndex:r] objectForKey:@"title"];
    [cell.titleLabel setText:s];
    
    @try {
        s = [[[[[[self.items objectAtIndex:r] objectForKey:@"photos"] objectAtIndex:0] objectForKey:@"photo_file"] objectForKey:@"thumb"] objectForKey:@"url"];
    }
    
    @catch (NSException *exception) {
        [cell.imageView setImage:[UIImage imageNamed:@"Pettinelli.png"]];
        return cell;

    }
    @finally {
        [cell.imageView setImageWithURL:[NSURL URLWithString:s]
                       placeholderImage:[UIImage imageNamed:@"Pettinelli.png"]];
    }
    
    DLog(@"Done with cell %d", r);

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    int r = indexPath.row;
    
    Gallery *gallery = [[Gallery alloc] init];
    gallery.title = [[self.items objectAtIndex:r] objectForKey:@"title"];
    gallery.body = [[self.items objectAtIndex:r] objectForKey:@"body"];
    gallery.images = [NSArray arrayWithArray:[[self.items objectAtIndex:r] objectForKey:@"photos"]];
    
    [self.navigationController pushViewController:gallery animated:YES];
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
    
}

@end
