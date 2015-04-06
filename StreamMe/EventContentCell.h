//
//  EventContentCell.h
//  StreamMe
//
//  Created by MEI C on 4/22/14.
//  Copyright (c) 2014 StreamMeTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventContentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *eventImageView;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *postTimelabel;
@property (weak, nonatomic) IBOutlet UILabel *posterNamelabel;
@property (weak, nonatomic) IBOutlet UILabel *addrLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;

@end
