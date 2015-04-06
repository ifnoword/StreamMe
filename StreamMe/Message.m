//
//  Message.m
//  StreamMe
//
//  Created by Zhang, Xinmei on 4/3/14.
//  Copyright (c) 2014 StreamMeTeam. All rights reserved.
//

#import "Message.h"
@interface Message()
@property (strong,nonatomic)  PFObject *msgobj;

@end

@implementation Message
-(instancetype) initWithPFObject:(PFObject *)msg{
    self = [super init];
    self.text = msg[@"text"];
    self.recipient = msg[@"to"];
    self.birthtime = msg.createdAt;
    PFUser *creator = msg[@"from"];
    NSError *err;
    [creator fetch:&err];
    if (!err) {
        self.creator = creator.username;
    }
    PFFile *imageFile = creator[@"avatar"];
    NSData *imageData = [imageFile getData];
    if(imageData){
        self.avatar = [UIImage imageWithData:imageData];
    }
    return self;
}


@end
