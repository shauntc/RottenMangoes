//
//  MovieReview.h
//  RottenMangoes
//
//  Created by Shaun Campbell on 2016-09-26.
//  Copyright © 2016 Shaun Campbell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MovieReview : NSObject


@property (nonatomic) NSString *reviewer;
@property (nonatomic) NSString *reviewText;
@property (nonatomic) NSString *fresh;
@property (nonatomic) NSString *reviewURL;

-(instancetype)initWithReviewData:(NSDictionary *)reviewData;

@end
