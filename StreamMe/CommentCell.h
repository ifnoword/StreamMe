//
//  CommentCell.h
//  StreamMe
//
//  Created by MEI C on 4/22/14.
//  Copyright (c) 2014 StreamMeTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UILabel *usernamelabel;
@property (weak, nonatomic) IBOutlet UILabel *timelabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end
