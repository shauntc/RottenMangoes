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
    [self configureView];
}

-(void)configureView
{
    _titleLabel.text = _movie.title;
    if(_movie.poster)
    {
        _posterImageView.image = _movie.poster;
    }

}

-(void)prepareForReuse{
    [super prepareForReuse];
    
    self.posterImageView.image = nil;
    
    
    
    
}

@end
