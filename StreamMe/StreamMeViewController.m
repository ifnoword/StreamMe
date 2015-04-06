//
//  StreamMeViewController.m
//  StreamMe
//
//  Created by MEI C on 3/30/14.
//  Copyright (c) 2014 StreamMeTeam. All rights reserved.
//

#import "StreamMeViewController.h"
#import "Map.h"
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import "ShowEventViewController.h"
#import "AddEventViewController.h"
#import "Event.h"

@interface StreamMeViewController ()<GMSMapViewDelegate, CLLocationManagerDelegate>
//@property (strong,nonatomic) GMSMapView *mapview;
@property (strong,nonatomic) Map *myMap;
@property (strong,nonatomic) CLLocation *currentLocation;
@property (strong,nonatomic) Event *currentEvent;
@property (strong,nonatomic) NSMutableArray *eventArray;
@end

@implementation StreamMeViewController{
    GMSMapView *mapView_;
    CLLocationManager *locationManager;
}
-(CLLocation *)currentLocation{
    if (!_currentLocation) {
        self.currentLocation = [[CLLocation alloc] initWithLatitude:41.66037246 longitude:-91.53641148];
    }
    return _currentLocation;
}

-(Map *)myMap{
    if (!_myMap) {
        _myMap = [[Map alloc] init];
    }
    return _myMap;
}
-(NSMutableArray *)eventArray{
    if (!_eventArray) {
        _eventArray = [[NSMutableArray alloc]init];
    }
    return _eventArray;
}
-(Event *)currentEvent{
    if(!_currentEvent){
        _currentEvent = [[Event alloc]init];
    }
    return _currentEvent;
}
- (void)viewDidLoad{
    
    mapView_ = [[GMSMapView alloc]initWithFrame:CGRectZero];
    mapView_.myLocationEnabled = YES;
    mapView_.settings.myLocationButton = YES;
    mapView_.delegate = self;
    
    self.view = mapView_;
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"AddEvent"]) {
        AddEventViewController *childVC = segue.destinationViewController;
        childVC.currentLocation = self.currentLocation;
    }
    else if([segue.identifier isEqualToString:@"ShowEventDetails"]){

        //[[NSUserDefaults standardUserDefaults] setObject:self.currentEvent.eventid forKey:@"UserCurrentEventId"];
        //[[NSUserDefaults standardUserDefaults] synchronize];
        ShowEventViewController *childVC = segue.destinationViewController;
        childVC.event = self.currentEvent;
        childVC.fromCommentView = NO;
    }
    else if([segue.identifier isEqualToString:@"getEventList"]){
        EventListViewController *childVC = segue.destinationViewController;
        childVC.eventList = [[NSArray alloc]initWithArray:self.eventArray];
    }

}
-(void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker{
    self.currentEvent = marker.userData;
    NSLog(@"Tap on icon %@",self.currentEvent.title);
    [self performSegueWithIdentifier:@"ShowEventDetails" sender:self];

}
-(BOOL)didTapMyLocationButtonForMapView:(GMSMapView *)mapView{
    NSLog(@"Tap on my location, current location: %@",mapView_.myLocation);
    self.currentLocation = mapView_.myLocation;
    [self addEventMarkersToMapView];
    return NO;
}

-(void)addEventMarkersToMapView{
    [mapView_ clear];
    [self.eventArray removeAllObjects];
    [self.eventArray addObjectsFromArray:[self.myMap getEvents:self.currentLocation]];
    NSLog(@"Get %d events.",self.eventArray.count);
    
    for(Event *event in self.eventArray){
        GMSMarker *eventMarker = [[GMSMarker alloc]init];
        eventMarker.userData = event;
        eventMarker.position = event.location.coordinate;
        //NSLog(@"<%f, %f>", eventMarker.position.latitude, eventMarker.position.longitude);
        eventMarker.snippet = event.title;
        eventMarker.tappable =  YES;
        eventMarker.map = mapView_;
    }
}
-(void) viewWillAppear:(BOOL)animated{
    self.currentLocation = [locationManager location];
    GMSCameraUpdate *updCam = [GMSCameraUpdate setTarget:self.currentLocation.coordinate zoom:15];
    [mapView_ animateWithCameraUpdate:updCam];
    [self addEventMarkersToMapView];
    
    //NSLog(@"====%@",[locationManager location]);
    //<+41.66037246,-91.53641148>
}
@end
