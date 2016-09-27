//
//  ReviewTableViewCell.m
//  RottenMangoes
//
//  Created by Shaun Campbell on 2016-09-26.
//  Copyright © 2016 Shaun Campbell. All rights reserved.
//

#import "ReviewTableViewCell.h"

@interface ReviewTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *reviewerLabel;
@property (weak, nonatomic) IBOutlet UITextView *reviewTextView;
@property (weak, nonatomic) IBOutlet UILabel *freshLabel;


@end

@implementation ReviewTableViewCell

-(void)setReview:(MovieReview *)review
{
    _review = review;
    
    [self configureView];
}

-(void)configureView
{
    self.backgroundColor = [UIColor clearColor];
    self.reviewerLabel.text = _review.reviewer;
    self.reviewTextView.text = _review.reviewText;
    self.freshLabel.text = _review.fresh;
    if([_review.fresh isEqualToString:@"fresh"])
    {
        self.freshLabel.textColor = [UIColor greenColor];
    }
    else
    {
        self.freshLabel.textColor = [UIColor redColor];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
