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
    if(!self.reviews)
    {
    
    
        
        NSURLSessionTask *task = [[NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]] dataTaskWithURL:[self reviewsURL] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if(!error)
            {
                self.reviews = [[NSArray alloc] init];
                
                NSError *jsonError = nil;
                
                
                NSDictionary *reviewsData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                
                
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
    
}

-(void)loadTheatresForAddress:(NSString *)address WithBlock:(void (^)(BOOL success))completionBlock
{

        NSURLSessionTask *task = [[NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]] dataTaskWithURL:[self theatresURLForAddress:address] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if(!error)
            {
                
                NSError *jsonError = nil;
                
                
                NSDictionary *theatresData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                
                NSArray *theatres = [[NSArray alloc] init];
                
                for(NSDictionary *theatreData in theatresData[@"theatres"])
                {
                    Theatre *theatre = [[Theatre alloc] initWithTheatreData:theatreData];
                    theatres = [theatres arrayByAddingObject:theatre];
                }
                
                self.theatres = theatres;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(YES);
                });
            }
        }];
        [task resume];

}



-(void)loadImageWithBlock:(void (^)(BOOL success))completionBlock
{

    NSURLSessionTask *task = [[NSURLSession sharedSession] downloadTaskWithURL:[NSURL URLWithString:self.posterURL]
                                                             completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                                 if (response) {
                                                                     
                                                                     NSData * imageData = [NSData dataWithContentsOfURL:location];
                                                                     UIImage * image = [UIImage imageWithData:imageData];
                                                                     self.poster = image;
                                                                     
                                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                                         completionBlock(YES);
                                                                     });
                                                                 } else {
                                                                     if (error) {
                                                                         
                                                                     }
                                                                 }
                                                             }];
    
    [task resume];
}

-(NSURL *)reviewsURL
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"http://api.rottentomatoes.com/api/public/v1.0/movies/%@/reviews.json?apikey=55gey28y6ygcr8fjy4ty87ek&page_limit=10", self.identity]];
}

-(NSURL *)theatresURLForAddress:(NSString*)address
{
    NSString *title = [self.title stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://lighthouse-movie-showtimes.herokuapp.com/theatres.json?address=%@&movie='%@\'", address, title]];
//    NSURL * baseURL = [NSURL URLWithString:@"http://lighthouse-movie-showtimes.herokuapp.com/theatres.json"];
    return url;
}


@end
