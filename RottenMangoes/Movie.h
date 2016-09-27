//
//  Movie.h
//  RottenMangoes
//
//  Created by Shaun Campbell on 2016-09-26.
//  Copyright © 2016 Shaun Campbell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MovieReview.h"


@interface Movie : NSObject

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *mpaa_rating;
@property (nonatomic) NSNumber *rating;
@property (nonatomic) NSString *posterURL;
@property (nonatomic) NSString *synopsis;
@property (nonatomic) NSArray<MovieReview *> *reviews;


-(instancetype)initWithDataDictionary:(NSDictionary *)movieData;
-(void)loadReviewsWithBlock:(void (^)(BOOL success))completionBlock;


@end
