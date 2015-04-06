//
//  Event.m
//  StreamMe
//
//  Created by Zhang, Xinmei on 4/3/14.
//  Copyright (c) 2014 StreamMeTeam. All rights reserved.
//

#import "Event.h"

#define NUM_COMMENT_PER_QUERY 10
#define PHOTO_MAX_H 150
#define PHOTO_MAX_W 150
#define MAX_LEN_OF_TITLE 20
#define MAX_LEN_OF_DESCRP 1000
#define MIN_LEN_OF_ADDR 5
#define MAX_LEN_OF_ADDR 200


@interface Event ()<NSCopying>
@property (strong, nonatomic,readwrite) PFObject *eventobj;
@property (strong, nonatomic,readwrite) NSString *eventid;
@end

@implementation Event

-(instancetype) initWithTitle:(NSString *)title text:(NSString *)text image:(UIImage *)image location:(CLLocation *)location address:(NSString *)addr  andDuration:(CGFloat)hour{
    self = [super init];
    self.title = title;
    self.text = text;
    self.image = image;
    self.creator = [PFUser currentUser].username;
    self.location = location;
    self.address =addr;
    self.deathtime = [[NSDate alloc] initWithTimeIntervalSinceNow:hour*3600];
    return self;
}

-(id) copyWithZone:(NSZone *)zone{
    
    Event *copy = [[[self class] alloc]init];
    copy.eventobj = self.eventobj;
    copy.title = [self.title copy];
    copy.eventid =  [self.eventid copy];
    copy.text = [self.text copy];
    copy.image = [self.image copy];
    copy.creator = [self.creator copy];
    copy.location = [self.location copy];
    copy.address = [self.address copy];
    copy.birthtime = [self.birthtime copy];
    copy.deathtime = [self.deathtime copy];
    
    return copy;
}

-(instancetype) initWithPFobj:(PFObject *)obj{
    self = [super init];
    self.eventid = obj.objectId;
    self.eventobj = obj;
    self.title = obj[@"title"];
    self.text = obj[@"text"];
    self.address = obj[@"address"];
    self.birthtime = obj.createdAt;
    self.deathtime = obj[@"deathtime"];
    PFGeoPoint *geoPoint = obj[@"location"];
    self.location = [[CLLocation alloc]initWithLatitude:geoPoint.latitude longitude:geoPoint.longitude];

    return self;
}

-(instancetype) initWithId:(NSString *)eventId{
    self = [super init];
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    [query getObjectWithId:eventId];
    self.eventobj = [query getObjectWithId:eventId];
    if (self.eventobj) {
        self.eventid = self.eventobj.objectId;
        self.title = self.eventobj[@"title"];
        self.text = self.eventobj[@"text"];
        self.address = self.eventobj[@"address"];
        self.birthtime = self.eventobj.createdAt;
        self.deathtime = self.eventobj[@"deathtime"];
        
        PFGeoPoint *geoPoint = self.eventobj[@"location"];
        self.location = [[CLLocation alloc]initWithLatitude:geoPoint.latitude longitude:geoPoint.longitude];
        
    }
    return self;

}

-(UIImage *)loadPhoto{
    PFFile *imageFile = self.eventobj[@"image"];
    NSData *imageData = [imageFile getData];
    if(imageData){
        self.image = [UIImage imageWithData:imageData];
        return self.image;
    }
    else return Nil;
}

-(NSString *) fetchUsername{
    PFUser *owner = self.eventobj[@"creator"];
    NSError *err;
    [owner fetch:&err];
    if (!err) {
        self.creator = owner.username;
        return self.creator;
    }
    else {
        return Nil;
    }
}
-(NSError *) save{
    NSError *error;
    NSString *errDomain = @"EVENTINVALIDINPUT";
    NSString *errMsg;
    if (self.title.length == 0 || self.title.length > MAX_LEN_OF_TITLE) {
        errMsg =[NSString stringWithFormat:@"Title length should between 1 and %d!",MAX_LEN_OF_TITLE];
        NSDictionary *dict = [NSDictionary dictionaryWithObject:errMsg forKey:@"error"];
        error = [NSError errorWithDomain:errDomain code:0 userInfo:dict];
        return error;
    }
    else if(self.text.length == 0 || self.text.length > MAX_LEN_OF_DESCRP){
        errMsg =[NSString stringWithFormat:@"Description length should between 1 and %d!",MAX_LEN_OF_DESCRP];
        NSDictionary *dict = [NSDictionary dictionaryWithObject:errMsg forKey:@"error"];
        error = [NSError errorWithDomain:errDomain code:0 userInfo:dict];
        return error;
    }
    else if(self.address.length < MIN_LEN_OF_ADDR || self.address.length > MAX_LEN_OF_ADDR){
        errMsg =[NSString stringWithFormat:@"Address length should between %d and %d",MIN_LEN_OF_ADDR,MAX_LEN_OF_ADDR];
        NSDictionary *dict = [NSDictionary dictionaryWithObject:errMsg forKey:@"error"];
        error = [NSError errorWithDomain:errDomain code:0 userInfo:dict];
        return error;
    
    }
    else{
        self.eventobj = [PFObject objectWithClassName:@"Event"];
        self.eventobj[@"title"] = self.title;
        self.eventobj[@"text"] = self.text;
        self.eventobj[@"location"]=[PFGeoPoint geoPointWithLocation:self.location];
        self.eventobj[@"address"] = self.address;
        self.eventobj[@"deathtime"] =self.deathtime;
        self.eventobj[@"creator"] = [PFUser currentUser];
    
        if (self.image) {
            NSData *imagedata = UIImagePNGRepresentation(self.image);
            PFFile *imgfile = [PFFile fileWithData:imagedata];
            [imgfile saveInBackground];
            self.eventobj[@"image"] = imgfile;
        }

        [self.eventobj save:&error];
        return error;
    }
}

-(NSError *) delet_{
    NSError *err;
    [self.eventobj delete:&err];
    return err;
}

-(NSError *) makeCommentWithText:(NSString *)text andRecipient:(NSString *)recipient;{
    NSError *error;
    PFObject *msg = [PFObject objectWithClassName:@"Msg"];
    msg[@"text"] = text;
    msg[@"to"] = recipient;
    msg[@"from"] = [PFUser currentUser];
    msg[@"onEvent"] = self.eventobj;
    [msg save:&error];
    return error;
}
-(NSArray *) getLatestCommentsOfNum:(NSInteger)num andSkip:(NSInteger)skip{
    PFQuery *query = [PFQuery queryWithClassName:@"Msg"];
    [query  whereKey:@"onEvent" equalTo:self.eventobj];
    if (num < 100) {
        query.limit = num;
    }
    query.skip = skip;
    [query orderByDescending:@"createAt"];
    NSArray *msgObjs = [[NSArray alloc] initWithArray:[query findObjects]];
    NSMutableArray *msgArray = [[NSMutableArray alloc] init];
    
    if (msgObjs) {
        for (PFObject *msgObj in msgObjs ) {
            Message *msg = [[Message alloc]initWithPFObject:msgObj];
            [msgArray addObject:msg];
        }
        
    }
    NSLog(@"Event  will return %d comments", [msgArray count]);
    return msgArray;
}
@end
