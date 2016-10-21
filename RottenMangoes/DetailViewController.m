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
#import "MapViewController.h"
#import <MapKit/MapKit.h>

@interface DetailViewController () <UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextView *synopsisTextView;

@end

@implementation DetailViewController

- (void)configureView {
    // Update the user interface for the detail item.
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.titleLabel.text = self.movie.title;
    self.synopsisTextView.text = self.movie.synopsis;
    self.posterImageView.image = self.movie.poster;
    
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
    
    if (self.movie == nil) {
        UIView *view = [[UIView alloc] initWithFrame:self.view.frame];
        view.backgroundColor = [UIColor blackColor];
        UILabel *label = [[UILabel alloc] initWithFrame:self.view.frame];
        label.textColor = [UIColor whiteColor];
        label.text = @"Select a Movie";
        label.textAlignment = NSTextAlignmentCenter;
        [view addSubview:label];
        [self.view addSubview:view];
        view.center = self.view.center;
        label.center = view.center;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if(indexPath)
    {
        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
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
        nextVC.title = review.reviewer;
    }
    else if([[segue identifier] isEqualToString:@"ShowTheatreMap"])
    {
        MapViewController *nextVC = segue.destinationViewController;
        
        
        nextVC.movie = self.movie;
        nextVC.title = @"Nearby Theatres";
    }
}



@end
