//
//  MovieReview.m
//  RottenMangoes
//
//  Created by Shaun Campbell on 2016-09-26.
//  Copyright © 2016 Shaun Campbell. All rights reserved.
//

#import "MovieReview.h"

@implementation MovieReview

-(instancetype)initWithReviewData:(NSDictionary *)reviewData
{
    self = [super init];
    if(self)
    {
        _reviewer = reviewData[@"critic"];
        _reviewText = reviewData[@"quote"];
        _fresh = reviewData[@"freshness"];
        _reviewURL = reviewData[@"links"][@"review"];
    }
    return self;
}


@end
