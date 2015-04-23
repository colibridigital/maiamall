//
//  ProfileViewController.m
//  MaiaMall
//
//  Created by Ingrid Funie on 20/03/2015.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import "ProfileViewController.h"
#import "SWRevealViewController.h"
#import "ProductCollectionViewCell.h"
#import "CollectionsCollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "ProductDetailViewController.h"
#import "CollectionListViewController.h"
#import "MapViewController.h"
#import "ProductListViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialiseMenuItems];
    
    self.summerItems =  [[NSMutableArray alloc] init];
    self.summerItems = [[MMDDataBase database] getSummerCollectionItems];
    
    self.shoesItems =  [[NSMutableArray alloc] init];
    self.shoesItems = [[MMDDataBase database] getShoesCollection];
    
    self.bagsItems =  [[NSMutableArray alloc] init];
    self.bagsItems = [[MMDDataBase database] getBagsCollection];
    
    self.shirtsItems =  [[NSMutableArray alloc] init];
    self.shirtsItems = [[MMDDataBase database] getShirtsCollection];
    
    self.formalItems =  [[NSMutableArray alloc] init];
    self.formalItems = [[MMDDataBase database] getFormalCollection];
    
    self.favCollItems =  [[NSMutableArray alloc] init];
    self.favCollItems = [[MMDDataBase database] getFavouriteCollection];
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:NO];
    
    [self initialiseMenuItems];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initialiseMenuItems
{
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(-5.0, 0.0, 320.0, 44.0)];
    self.searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    UIView *searchBarView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 310.0, 44.0)];
    searchBarView.autoresizingMask = 0;
    self.searchBar.delegate = self;
    //searchBar.backgroundImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"MaiaMall-Logo-Light" ofType: @"jpg"]];
    self.searchBar.backgroundImage = [[UIImage alloc] init];
    
    
    [searchBarView addSubview:self.searchBar];
    self.navigationItem.titleView = searchBarView;
    
    self.folllowButton.layer.cornerRadius = 2;
    self.folllowButton.layer.borderWidth = 1;
    self.folllowButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    
    [self.favsCollectionView registerNibAndCell];
    [self.collsCollectionView registerNibAndCell];
    
    [self.favsCollectionView reloadData];
    [self.collsCollectionView reloadData];
    
    self.tabBarController.delegate = self;
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    if (item.tag == 0) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        
        UINavigationController *map = [storyboard instantiateViewControllerWithIdentifier:@"profileNav"];
        
        [self showViewController:map sender:self];
        
    } else if (item.tag == 1) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        
        UINavigationController *map = [storyboard instantiateViewControllerWithIdentifier:@"mapNav"];
        
        [self showViewController:map sender:self];
    } else if (item.tag == 2) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        
        UINavigationController *map = [storyboard instantiateViewControllerWithIdentifier:@"homeNav"];
        
        [self showViewController:map sender:self];
        // [item setEnabled:YES];
        
    } else if (item.tag == 3) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        
        UINavigationController *map = [storyboard instantiateViewControllerWithIdentifier:@"blogNav"];
        
        // [self performSegueWithIdentifier:@"mapNav" sender:self];
        
        [self showViewController:map sender:self];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == self.collsCollectionView) {
        return 5;
    } else if (collectionView == self.favsCollectionView) {
        return 18;
    }
    
    else return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (collectionView == self.collsCollectionView) {
        CollectionsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"COLL_CELL" forIndexPath:indexPath];
        
        if (indexPath.row == 0) {
            
            NSString *imagePath = ((MMDItem*)[self.summerItems objectAtIndex:3]).itemImagePath;
            
            UIImage *itemImage = [UIImage imageWithContentsOfFile:imagePath];
            
            cell.detailImage.image = itemImage;
        } else if (indexPath.row == 1) {
            NSString *imagePath = ((MMDItem*)[self.shoesItems objectAtIndex:1]).itemImagePath;
            
            UIImage *itemImage = [UIImage imageWithContentsOfFile:imagePath];
            
            cell.detailImage.image = itemImage;
        }
        else if (indexPath.row == 2) {
            NSString *imagePath = ((MMDItem*)[self.bagsItems objectAtIndex:2]).itemImagePath;
            
            UIImage *itemImage = [UIImage imageWithContentsOfFile:imagePath];
            
            cell.detailImage.image = itemImage;
        } else if (indexPath.row == 3) {
            NSString *imagePath = ((MMDItem*)[self.formalItems objectAtIndex:3]).itemImagePath;
            
            UIImage *itemImage = [UIImage imageWithContentsOfFile:imagePath];
            
            cell.detailImage.image = itemImage;
        } else if (indexPath.row == 4) {
            NSString *imagePath = ((MMDItem*)[self.shirtsItems objectAtIndex:1]).itemImagePath;
            
            UIImage *itemImage = [UIImage imageWithContentsOfFile:imagePath];
            
            cell.detailImage.image = itemImage;
        }
        
        return cell;
    } else {
        ProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PROD_CELL" forIndexPath:indexPath];
        
        NSString *imagePath = ((MMDItem*)[self.favCollItems objectAtIndex:indexPath.row]).itemImagePath;
        
        UIImage *itemImage = [UIImage imageWithContentsOfFile:imagePath];
        
        cell.productImage.image = itemImage;
        
        
        return cell;
        
    }
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == self.favsCollectionView) {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        
        ProductDetailViewController *prodDetail = [storyboard instantiateViewControllerWithIdentifier:@"prodDetailView"];
        
        [prodDetail initWithItem:(MMDItem*)[self.favCollItems objectAtIndex:indexPath.row]];
        
        // UINavigationController *det = [storyboard instantiateViewControllerWithIdentifier:@"detNav"];
        
        [self showViewController:prodDetail sender:self];
    } else if (collectionView == self.collsCollectionView){
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        
        CollectionListViewController *prod = [storyboard instantiateViewControllerWithIdentifier:@"collectionListView"];
        
        if (indexPath.row == 0) {
            
            [prod initWithItemsArray:self.summerItems];
            
            prod.colText = @"Summer Collection";
            
        } else if (indexPath.row == 1) {
            [prod initWithItemsArray:self.shoesItems];
            
            [prod initWithTitleText: @"Shoes Collection"];
            
            prod.colText = @"Shoes Collection";
            
        } else if (indexPath.row == 2) {
            [prod initWithItemsArray:self.bagsItems];
            
            [prod initWithTitleText: @"Bags Collection"];
            
            prod.colText = @"Bags Collection";
            
        } else if (indexPath.row == 3) {
            [prod initWithItemsArray:self.formalItems];
            
            [prod initWithTitleText: @"Formal Items Collection"];
            
            prod.colText = @"Formal Items Collection";
            
        } else if (indexPath.row == 4) {
            [prod initWithItemsArray:self.shirtsItems];
            
            [prod initWithTitleText: @"Shirts Collections"];
            
            prod.colText = @"Shirts Collection";
        }
        
        [self showViewController:prod sender:self];
        
    }
    
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    //UINavigationController *prodListDetails = [storyboard instantiateViewControllerWithIdentifier:@"prodNav"];
    
    // [self showViewController:prodListDetails sender:self];
    
    [self.searchBar resignFirstResponder];
    
    
    dispatch_async(dispatch_queue_create("Search", nil), ^{
        
        NSMutableArray * arrayWithSearchResults = [[NSMutableArray alloc] init];
        
        for (MMDItem* item in [[MMDDataBase database] arrayWithItems]) {
            if (![[NSUserDefaults standardUserDefaults] boolForKey:kFemaleOrMaleSwitch]) {
                if ((([[item.itemTitle lowercaseString] rangeOfString:[self.searchBar.text lowercaseString]].location != NSNotFound) || ([[item.itemCategory lowercaseString] rangeOfString:[self.searchBar.text lowercaseString]].location != NSNotFound)) && item.itemGender == female) {
                    [arrayWithSearchResults addObject:item];
                }
            } else {
                if (([[item.itemTitle lowercaseString] rangeOfString:[self.searchBar.text lowercaseString]].location != NSNotFound) || ([[item.itemCategory lowercaseString] rangeOfString:[self.searchBar.text lowercaseString]].location != NSNotFound)) {
                    [arrayWithSearchResults addObject:item];
                }
            }
            
            
        }
        
        if (arrayWithSearchResults.count > 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
                ProductListViewController * searchPage = [storyboard instantiateViewControllerWithIdentifier:@"prodListSearchDetails"];
                [searchPage initWithArrayWithSearchResults:arrayWithSearchResults andTextForSearch:self.searchBar.text];
                [self.navigationController pushViewController:searchPage animated:YES];
            });
        }
    });
    
    
}

- (IBAction)filterSearchMenuClicked:(id)sender {
    
    self.arrayWithSearchResults = [[NSMutableArray alloc] init];
    
    for (MMDItem* item in [[MMDDataBase database] arrayWithItems]) {
        if (![[NSUserDefaults standardUserDefaults] boolForKey:kFemaleOrMaleSwitch]) {
            if ((([[item.itemTitle lowercaseString] rangeOfString:[self.searchBar.text lowercaseString]].location != NSNotFound) || ([[item.itemCategory lowercaseString] rangeOfString:[self.searchBar.text lowercaseString]].location != NSNotFound)) && item.itemGender == female) {
                [self.arrayWithSearchResults addObject:item];
            }
        } else {
            if (([[item.itemTitle lowercaseString] rangeOfString:[self.searchBar.text lowercaseString]].location != NSNotFound) || ([[item.itemCategory lowercaseString] rangeOfString:[self.searchBar.text lowercaseString]].location != NSNotFound))  {
                [self.arrayWithSearchResults addObject:item];
            }
        }
        
    }
    
    if (self.searchBar.text != nil && self.arrayWithSearchResults.count > 0) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
            
            MapViewController *map = [storyboard instantiateViewControllerWithIdentifier:@"map"];
            
            [map initWithArrayWithSearchResults:self.arrayWithSearchResults andTextForSearch:self.searchBar.text];
            //[map initMap];
            
            [map populateMapWithData];
            
            [self.navigationController pushViewController:map animated:YES];
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
            MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"No Results Found";
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        });
    }
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
