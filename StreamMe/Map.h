//
//  Map.h
//  StreamMe
//
//  Created by MEI C on 4/20/14.
//  Copyright (c) 2014 StreamMeTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>
#import "Event.h"

@interface Map : NSObject
-(NSArray *)getEvents:(CLLocation *)location;
@end
