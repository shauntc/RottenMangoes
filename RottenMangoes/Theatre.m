//
//  Theatre.m
//  RottenMangoes
//
//  Created by Shaun Campbell on 2016-09-27.
//  Copyright © 2016 Shaun Campbell. All rights reserved.
//

#import "Theatre.h"

@interface Theatre()

@property (nonatomic) NSString *identity;

@end

@implementation Theatre

- (instancetype)initWithTheatreData:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        _identity = data[@"id"];
        _title = data[@"name"];
        _subtitle = data[@"address"];
        _coordinate = CLLocationCoordinate2DMake([data[@"lat"] floatValue], [data[@"lng"] floatValue]);
    }
    return self;
}

@end
