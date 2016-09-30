//
//  LocationManager.h
//  RottenMangoes
//
//  Created by Shaun Campbell on 2016-09-27.
//  Copyright © 2016 Shaun Campbell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol LocationManagerProtocol <NSObject>

-(void)locationHasUpdated:(CLLocation *)location;

@end

@interface LocationManager : NSObject

@property (nonatomic, weak) id<LocationManagerProtocol> delegate;

+(id)sharedManager;
-(void)startLocationManager:(id<LocationManagerProtocol>)delegate;

@end
