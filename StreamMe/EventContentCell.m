//
//  EventContentCell.m
//  StreamMe
//
//  Created by MEI C on 4/22/14.
//  Copyright (c) 2014 StreamMeTeam. All rights reserved.
//

#import "EventContentCell.h"

@implementation EventContentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
