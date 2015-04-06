//
//  Message.h
//  StreamMe
//
//  Created by Zhang, Xinmei on 4/3/14.
//  Copyright (c) 2014 StreamMeTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>


@interface Message : NSObject
//@property (strong, nonatomic) NSString *msgid;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *creator;
@property (strong, nonatomic) NSString *recipient;
@property (strong, nonatomic) UIImage *avatar;
@property (strong, nonatomic) NSDate *birthtime;
-(instancetype) initWithPFObject:(PFObject *)msg;

@end
