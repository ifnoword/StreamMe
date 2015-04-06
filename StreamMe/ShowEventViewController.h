//
//  ShowEventViewController.h
//  StreamMe
//
//  Created by MEI C on 4/23/14.
//  Copyright (c) 2014 StreamMeTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import "Message.h"
#import "CommentCell.h"
#import "EventContentCell.h"
#import "CommentViewController.h"
#import "User.h"
@interface ShowEventViewController : UIViewController
@property (strong,nonatomic) Event *event;
@property (weak, nonatomic) IBOutlet UIButton *getCommentsBtn;
@property (nonatomic) BOOL fromCommentView;
@end
