//
//  LocationManager.m
//  RottenMangoes
//
//  Created by Shaun Campbell on 2016-09-27.
//  Copyright © 2016 Shaun Campbell. All rights reserved.
//

#import "LocationManager.h"
#define locationAccuracy 100

@interface LocationManager() <CLLocationManagerDelegate>

@property (nonatomic) CLLocationManager *locationManager;


@end

@implementation LocationManager

+(id)sharedManager
{
    static LocationManager *sharedLocationManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedLocationManager = [[self alloc] init];
    });
    return sharedLocationManager;
    
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _locationManager = [CLLocationManager new];
        _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        _locationManager.delegate = self;
    }
    return self;
}

#pragma mark -

-(void)startLocationManager:(id<LocationManagerProtocol>)delegate
{
    self.delegate = delegate;
    
    if([CLLocationManager locationServicesEnabled])
    {
        switch ([CLLocationManager authorizationStatus])
        {
            case kCLAuthorizationStatusDenied:
            case kCLAuthorizationStatusNotDetermined:
            case kCLAuthorizationStatusRestricted:
                [self.locationManager requestWhenInUseAuthorization];
                break;
            default:
                [self.locationManager startUpdatingLocation];
                NSLog(@"Authorized");
                //some alerts for location settings
                break;
        }
    }
}

-(void)stopLocationManager
{
    if([CLLocationManager locationServicesEnabled])
    {
        if(_locationManager)
        {
            [self.locationManager stopUpdatingLocation];
        }
    }
}


#pragma mark - CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *location = [locations lastObject];
    
    if(location.verticalAccuracy <= locationAccuracy && location.verticalAccuracy <= locationAccuracy)
    {
        [self.delegate locationHasUpdated:location];
        [self stopLocationManager];
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch ([CLLocationManager authorizationStatus])
    {
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            [self.locationManager startUpdatingLocation];
            break;
        default:
            NSLog(@"Not Authorized");
            //some alerts for location settings
            break;
    }
}

@end
