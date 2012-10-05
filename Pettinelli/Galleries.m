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
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            photoSize = @"large";
    } else {
            photoSize = @"medium";
    }
    
	// Do any additional setup after loading the view.
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int r = indexPath.row;
    static NSString *CellIdentifier = @"Cell";
	Cell *cell = (Cell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    DLog(@"Creating cell %d", r);

    if (cell == nil) cell = [self newCustomCell];
    
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
    
    
    networkImages = [[NSArray alloc] initWithArray:[[self.items objectAtIndex:r] objectForKey:@"photos"]];

    networkGallery = [[FGalleryViewController alloc] initWithPhotoSource:self];
    [self.navigationController pushViewController:networkGallery animated:YES];
    
    
    
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
}


#pragma mark - FGalleryViewControllerDelegate Methods


- (int)numberOfPhotosForPhotoGallery:(FGalleryViewController *)gallery
{
    int num = [networkImages count];
	return num;
}


- (FGalleryPhotoSourceType)photoGallery:(FGalleryViewController *)gallery sourceTypeForPhotoAtIndex:(NSUInteger)index
{
    return FGalleryPhotoSourceTypeNetwork;
}


- (NSString*)photoGallery:(FGalleryViewController *)gallery captionForPhotoAtIndex:(NSUInteger)index
{
//    NSString *caption;
//    if( gallery == localGallery ) {
//        caption = [localCaptions ;
//    }
//    else if( gallery == networkGallery ) {
//        caption = [networkCaptions objectAtIndex:index];
//    }
	return @"";
}


- (NSString*)photoGallery:(FGalleryViewController*)gallery filePathForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index {
        
    return [[[[networkImages objectAtIndex:index] objectForKey:@"photo_file"] objectForKey:photoSize] objectForKey:@"url"];
}

- (NSString*)photoGallery:(FGalleryViewController *)gallery urlForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index {
    
    return [[[[networkImages objectAtIndex:index] objectForKey:@"photo_file"] objectForKey:photoSize] objectForKey:@"url"];
}

@end
