//
//  Cell.m
//  Pettinelli
//
//  Created by Andrea Barbon on 03/09/12.
//  Copyright (c) 2012 fractalsoft srl. All rights reserved.
//

#import "Cell.h"

@implementation Cell

@synthesize titleLabel, detailLabel, imageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
