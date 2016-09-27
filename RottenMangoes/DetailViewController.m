//
//  DetailViewController.m
//  RottenMangoes
//
//  Created by Shaun Campbell on 2016-09-26.
//  Copyright © 2016 Shaun Campbell. All rights reserved.
//

#import "DetailViewController.h"
#import "ReviewTableViewCell.h"
#import "WebViewController.h"

@interface DetailViewController () <UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation DetailViewController

- (void)configureView {
    // Update the user interface for the detail item.
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.titleLabel.text = self.movie.title;
    
    NSURLSessionTask *task = [[NSURLSession sharedSession] downloadTaskWithURL:[NSURL URLWithString:_movie.posterURL] completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _posterImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
        });
        
    }];
    [task resume];
    
    [self.movie loadReviewsWithBlock:^(BOOL success) {
        if(success)
        {
            [self.tableView reloadData];
        }
    }];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Managing the detail item

-(void)setMovie:(Movie *)movie
{
    _movie = movie;
    if(self.movie)
    {
        [self configureView];
    }
    
}


#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.movie.reviews.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReviewTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ReviewCell" forIndexPath:indexPath];
    
    cell.review = self.movie.reviews[indexPath.row];
    
    return cell;
}

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"ShowReviewPage"])
    {
        WebViewController *nextVC = segue.destinationViewController;
        
        MovieReview *review = self.movie.reviews[[self.tableView indexPathForSelectedRow].row];
        
        nextVC.url = [NSURL URLWithString:review.reviewURL];
    }
}



@end
