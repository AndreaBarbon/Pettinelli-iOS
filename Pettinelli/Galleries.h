//
//  Galleries.h
//  Pettinelli
//
//  Created by Andrea Barbon on 29/08/12.
//  Copyright (c) 2012 fractalsoft srl. All rights reserved.
//

#import "BrowserViewController.h"
#import "FGalleryViewController.h"

@interface Galleries : BrowserViewController <FGalleryViewControllerDelegate> {
    
    FGalleryViewController *networkGallery;
    NSArray *networkImages;

}

@end
