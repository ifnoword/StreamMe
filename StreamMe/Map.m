//
//  Map.m
//  StreamMe
//
//  Created by MEI C on 4/20/14.
//  Copyright (c) 2014 StreamMeTeam. All rights reserved.
//

#import "Map.h"
#define range 1 //mile

@implementation Map
-(NSArray *)getEvents:(CLLocation *)location{
    NSMutableArray *eventList = [[NSMutableArray alloc] init];
    PFGeoPoint *mypoint = [PFGeoPoint geoPointWithLocation:location];
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    [query whereKey:@"location" nearGeoPoint:mypoint withinMiles:range];
    [query whereKey:@"deathtime" greaterThan:[NSDate date]];
    NSArray *eventObjs = [[NSArray alloc] initWithArray:[query findObjects]];

    for (PFObject *obj in eventObjs){
        Event *event =[[Event alloc]initWithPFobj:obj];
        [eventList addObject:event];
    }
    return eventList;
}
@end
