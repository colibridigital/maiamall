//
//  CollectionListViewController.m
//  MaiaMall
//
//  Created by Ingrid Funie on 27/03/2015.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import "CollectionListViewController.h"
#import "CollectionDetailCollectionViewCell.h"
#import "ProductDetailViewController.h"
#import "MMDItem.h"

@interface CollectionListViewController ()

@end

@implementation CollectionListViewController

-(void)initWithItemsArray:(NSMutableArray*)items {
    self.currentItems = items;
}

-(void)initWithTitleText:(NSString *)text {
    self.collectionTitle.text = @"";
    [self.collectionTitle setText:text];
}

- (void)initialiseMenuItems {
    
    self.tabBarController.delegate = self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialiseMenuItems];
    
    [self.collectionDetailView registerNibAndCell];
    [self.collectionDetailView reloadData];
    
    // Do any additional setup after loading the view.
    
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:NO];
    // Do any additional setup after loading the view.
    
    [self initialiseMenuItems];
    
    [self.collectionDetailView reloadData];
    
    NSLog(@"current items: %lu", self.currentItems.count);
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    self.collectionTitle.text = self.colText;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    if (item.tag == 0) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        
        UINavigationController *map = [storyboard instantiateViewControllerWithIdentifier:@"profileNav"];
        
        [self showViewController:map sender:self];
        
    } else
        if (item.tag == 1) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
            
            UINavigationController *map = [storyboard instantiateViewControllerWithIdentifier:@"mapNav"];
            
            // [self performSegueWithIdentifier:@"mapNav" sender:self];
            
            [self showViewController:map sender:self];
        } else if (item.tag == 2) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
            
            UINavigationController *map = [storyboard instantiateViewControllerWithIdentifier:@"homeNav"];
            
            // [self performSegueWithIdentifier:@"mapNav" sender:self];
            
            [self showViewController:map sender:self];
        } else if (item.tag == 3) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
            
            UINavigationController *map = [storyboard instantiateViewControllerWithIdentifier:@"blogNav"];
            
            // [self performSegueWithIdentifier:@"mapNav" sender:self];
            
            [self showViewController:map sender:self];
        }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"in here: %lu", self.currentItems.count);
    
    return self.currentItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"COLLDET_CELL" forIndexPath:indexPath];
    
    NSString *imagePath = ((MMDItem*)[self.currentItems objectAtIndex:indexPath.row]).itemImagePath;
    
    UIImage *itemImage = [UIImage imageWithContentsOfFile:imagePath];
    
    // NSLog(@"current items: %lu", sizeof(self.currentItems));
    
    NSLog(@"in the collection cell");
    
    cell.detailImage.image = itemImage;
    
    // UIImage *img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"product2" ofType: @"png"]];
    
    //cell.detailImage = [[UIImageView alloc] initWithImage:img];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    ProductDetailViewController *prodDetail = [storyboard instantiateViewControllerWithIdentifier:@"prodDetailView"];
    
    [prodDetail initWithItem:[self.currentItems objectAtIndex:indexPath.row]];
    
    // UINavigationController *det = [storyboard instantiateViewControllerWithIdentifier:@"detNav"];
    
    [self showViewController:prodDetail sender:self];
    
    
}




/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
