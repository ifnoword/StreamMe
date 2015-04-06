//
//  Event.h
//  StreamMe
//
//  Created by Zhang, Xinmei on 4/3/14.
//  Copyright (c) 2014 StreamMeTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>
#import <Parse/Parse.h>
#import "Message.h"

@interface Event : NSObject
@property (strong, nonatomic,readonly) PFObject *eventobj;
@property (strong, nonatomic,readonly) NSString *eventid;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *creator;//username
@property (strong, nonatomic) UIImage *image;
@property (nonatomic) CLLocation *location;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSDate *birthtime; //creation date
@property (strong, nonatomic) NSDate *deathtime; //expiration date

-(instancetype) initWithTitle:(NSString *)title
                         text:(NSString *)text
                        image:(UIImage *)image
                     location:(CLLocation *)location
                      address:(NSString *)addr
                  andDuration:(CGFloat)hour;
-(id) copyWithZone:(NSZone *)zone;
-(UIImage *)loadPhoto;
-(NSString *) fetchUsername;
-(instancetype) initWithPFobj:(PFObject *)obj;
-(instancetype) initWithId:(NSString *)eventId;

-(NSError *) save;
-(NSError *) delet_;
-(NSError *) makeCommentWithText:(NSString *)text andRecipient:(NSString *)recipient;
-(NSArray *) getLatestCommentsOfNum:(NSInteger)num andSkip:(NSInteger)skip;

@end
