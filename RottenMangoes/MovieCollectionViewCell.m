//
//  MovieCollectionViewCell.m
//  RottenMangoes
//
//  Created by Shaun Campbell on 2016-09-26.
//  Copyright © 2016 Shaun Campbell. All rights reserved.
//

#import "MovieCollectionViewCell.h"

@interface MovieCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation MovieCollectionViewCell


-(void)setMovie:(Movie *)movie
{
    _movie = movie;
    
    NSURLSessionTask *task = [[NSURLSession sharedSession] downloadTaskWithURL:[NSURL URLWithString:_movie.posterURL] completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _posterImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
            
        });
        
        
        
        
        
        
    }];
    
    [task resume];
    
    
    self.titleLabel.text = movie.title;
    
}

-(void)prepareForReuse{
    [super prepareForReuse];
    
    self.posterImageView.image = nil;
    
    
    
    
}

@end
