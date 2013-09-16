//
//  LocationUpdate.h
//  Jobs
//
//  Created by Mathew Vlandys on 20/07/13.
//  Copyright (c) 2013 Dispatchr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "JsonRequest.h"

@interface LocationUpdate : NSObject <CLLocationManagerDelegate>
{
    CLLocationManager      *locationManager;
    CLLocationCoordinate2D location;
    JsonRequest            *jRequest;
    int                    isUpdating;
}

- (void)updateLocation;

@end
