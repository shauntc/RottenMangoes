//
//  MapViewController.m
//  RottenMangoes
//
//  Created by Shaun Campbell on 2016-09-27.
//  Copyright © 2016 Shaun Campbell. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "LocationManager.h"

#define regionSize 2100

@interface MapViewController () <LocationManagerProtocol>

@property (nonatomic) CLLocation *location;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) LocationManager *locationManager;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationManager = [LocationManager sharedManager];
    [self.locationManager startLocationManager:self];
    
    
    self.mapView.showsUserLocation = YES;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)configureView
{
    
    
    
}


#pragma mark - LocationManagerDelegate

-(void)locationHasUpdated:(CLLocation *)location
{
    self.location = location;
    
    CLLocationCoordinate2D currentLocation = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currentLocation, regionSize, regionSize);
    
    [self.mapView setRegion:region animated:YES];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        NSString *postalCode = placemarks[0].postalCode;
        
        [self.movie loadTheatresForAddress:postalCode WithBlock:^(BOOL success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.mapView addAnnotations:self.movie.theatres];
            });
        }];
    }];
    

    
}


@end
