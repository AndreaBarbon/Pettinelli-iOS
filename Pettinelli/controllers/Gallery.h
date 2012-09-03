//
//  Gallery.h
//  Pettinelli
//
//  Created by Andrea Barbon on 31/08/12.
//  Copyright (c) 2012 fractalsoft srl. All rights reserved.
//

#import "Detail.h"

@interface Gallery : Detail {
    
    IBOutlet UIPageControl *pageControl;
    int screen_width;
}

@property(nonatomic, retain) NSArray *images;

@end
