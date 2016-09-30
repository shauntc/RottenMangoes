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

#define moviesPerPage 16


@interface MasterCollectionViewController ()

@property (nonatomic, readonly) NSString *theatresURL;
@property (nonatomic) NSArray <Movie *> *movies;
@property (nonatomic, assign) int numMovies;

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
        nextVC.movie = self.movies[index.row];
        
    }
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.movies.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MovieCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCell" forIndexPath:indexPath];
    cell.movie = self.movies[indexPath.item];
    
    
    if(!self.movies[indexPath.item].poster)
    {
        [self.movies[indexPath.item] loadImageWithBlock:^(BOOL success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:1.0 animations:^{
                    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
                }];
            });
        }];
    }
    
    
    
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.item == self.movies.count - 1 && self.movies.count <= self.numMovies)
    {
        [self retrieveMoviesIndex:(int)(self.movies.count / moviesPerPage)];
        
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
    
    NSString *key = @"55gey28y6ygcr8fjy4ty87ek";
    
    
    return [NSString stringWithFormat:@"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?apikey=%@&page=%d", key, page];
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
                
                NSString *movieNumber = theatresData[@"total"];
                
                self.numMovies = [movieNumber intValue];
                
                NSArray <NSIndexPath *> *indexPaths = [[NSArray alloc] init];

                for(NSDictionary *movieData in theatresData[@"movies"])
                {
                    Movie *movie = [[Movie alloc] initWithDataDictionary:movieData];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:(self.movies.count + movies.count) inSection:0];
                    movies = [movies arrayByAddingObject:movie];
                    indexPaths = [indexPaths arrayByAddingObject:indexPath];
                }
                
                self.movies = [self.movies arrayByAddingObjectsFromArray:movies];
                
                [UIView animateWithDuration:1.0 animations:^{
                    dispatch_async(dispatch_get_main_queue(), ^{

                    [self.collectionView insertItemsAtIndexPaths:indexPaths];
                });
//                    [self.collectionView reloadData];
                }];
            }
        }
    }];
    
    [task resume];
}

@end
