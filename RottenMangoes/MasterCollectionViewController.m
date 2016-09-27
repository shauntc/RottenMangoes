//
//  MasterCollectionViewController.m
//  RottenMangoes
//
//  Created by Shaun Campbell on 2016-09-26.
//  Copyright © 2016 Shaun Campbell. All rights reserved.
//

#import "MasterCollectionViewController.h"
#import "Movie.h"
#import "MovieCollectionViewCell.h"
#import "DetailViewController.h"

@interface MasterCollectionViewController ()

@property (nonatomic, readonly) NSString *theatresURL;
@property (nonatomic) NSArray <NSArray <Movie *> *> *movies;

@end

@implementation MasterCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    
    self.movies = [[NSArray alloc] init];
    self.title = @"In Theatres";
    
    [self retrieveMoviesIndex:0];
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"ShowDetail"])
    {
        UINavigationController *navVC = [segue destinationViewController];
        
        DetailViewController *nextVC = navVC.viewControllers[0];
        
        NSIndexPath *index = [self.collectionView indexPathsForSelectedItems][0];
        nextVC.movie = self.movies[index.section][index.row];
        
    }
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return self.movies.count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.movies[section].count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MovieCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCell" forIndexPath:indexPath];
    
    cell.movie = self.movies[indexPath.section][indexPath.item];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.item == self.movies[indexPath.section].count - 1 && indexPath.section == self.movies.count -1)
    {
        [self retrieveMoviesIndex:(1 + (int)indexPath.section)];
    }
    
    
}


#pragma mark <UICollectionViewDelegate>





/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/
#pragma mark - Data Retrieval


-(NSString *)theatresURLForPage:(int)page
{
    return [NSString stringWithFormat:@"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?apikey=55gey28y6ygcr8fjy4ty87ek&page=%d",page];
}


-(void)retrieveMoviesIndex:(int)index
{
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionTask *task = [session dataTaskWithURL:[NSURL URLWithString:[self theatresURLForPage:(index + 1)]] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(!error)
        {
            
            NSError *jsonError = nil;
            
            NSDictionary *theatresData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            
            if(!jsonError)
            {
                NSArray *movies = [[NSArray alloc] init];

                for(NSDictionary *movieData in theatresData[@"movies"])
                {
                    Movie *movie = [[Movie alloc] initWithDataDictionary:movieData];
                    
                    movies = [movies arrayByAddingObject:movie];
                }
                
                self.movies = [self.movies arrayByAddingObject:movies];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.collectionView reloadData];
                });
            }
        }
    }];
    
    [task resume];
}

@end
