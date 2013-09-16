//
//  LocationUpdate.m
//  Jobs
//
//  Created by Mathew Vlandys on 20/07/13.
//  Copyright (c) 2013 Dispatchr. All rights reserved.
//

#import "LocationUpdate.h"

@implementation LocationUpdate

- (LocationUpdate*)init {
    self = [super init];
    
    isUpdating = 0;
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter  = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    return self;
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    isUpdating = 1;
    
    CLLocation              *lastLocation = [locations lastObject];
    CLLocationCoordinate2D  newLocation   = lastLocation.coordinate;
    
    if (memcmp(&location, &newLocation, sizeof(CLLocationCoordinate2D))) {
        NSString *longitude = [NSString stringWithFormat:@"%f",newLocation.longitude];
        NSString *latitude  = [NSString stringWithFormat:@"%f",newLocation.latitude];
        
        NSDictionary *postData = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:longitude, latitude, nil]
                                                               forKeys:[NSArray arrayWithObjects:@"longitude", @"latitude", nil]];
        
        jRequest = [[JsonRequest alloc] initWithUrl:@"http://service.uberpimp.net/updatelocation" postData:postData];
        [jRequest startConnection:self];
        
        [locationManager stopUpdatingLocation];
        location = newLocation;
    }
    
    isUpdating = 0;
}

- (void)updateLocation
{
    if (isUpdating == 0) {
        [locationManager startUpdatingLocation];
    }
}

#pragma mark -
#pragma mark NSURLConnection Delegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    /*
    NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@", response);
    */
}

@end
