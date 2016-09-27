//
//  Movie.m
//  RottenMangoes
//
//  Created by Shaun Campbell on 2016-09-26.
//  Copyright © 2016 Shaun Campbell. All rights reserved.
//

#import "Movie.h"

@interface Movie()

@property (nonatomic) NSString *identity;

@end

@implementation Movie


-(instancetype)initWithDataDictionary:(NSDictionary *)movieData
{
    self = [super init];
    if(self)
    {
        _title = movieData[@"title"];
        _mpaa_rating = movieData[@"mpaa_rating"];
        _rating = movieData[@"ratings"][@"critics_rating"];
        _posterURL = movieData[@"posters"][@"original"];
        _synopsis = movieData[@"synopsis"];
        _identity = movieData[@"id"];
    }
    
    return self;
}

-(void)loadReviewsWithBlock:(void (^)(BOOL success))completionBlock
{
    
    
    
    
    NSURLSessionTask *task = [[NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]] dataTaskWithURL:[NSURL URLWithString:[self reviewsURL]] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(!error)
        {
            
            NSError *jsonError = nil;
            
            
            NSDictionary *reviewsData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            
            self.reviews = [[NSArray alloc] init];
            
            for(NSDictionary *reviewData in reviewsData[@"reviews"])
            {
                MovieReview *review = [[MovieReview alloc] initWithReviewData:reviewData];
                self.reviews = [self.reviews arrayByAddingObject:review];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(YES);
            });
        }
    }];
    [task resume];
}


-(NSString *)reviewsURL
{
    return [NSString stringWithFormat:@"http://api.rottentomatoes.com/api/public/v1.0/movies/%@/reviews.json?apikey=55gey28y6ygcr8fjy4ty87ek&page_limit=10", self.identity];
}
                                                                            

@end
