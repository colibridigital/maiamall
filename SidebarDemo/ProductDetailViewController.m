//
//  ProductDetailViewController.m
//  MaiaMall
//
//  Created by Ingrid Funie on 19/03/2015.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "ItemsSimilarCollectionViewCell.h"
#import "RetailDetailViewController.h"
#import "MMDWishList.h"
#import "AppDelegate.h"
#import "PurchaseItemViewController.h"
#import "MapViewForItemViewController.h"

@interface ProductDetailViewController ()
@property (strong, nonatomic) MMDItem * currentItemToShow;

@property (strong, nonatomic) NSMutableArray * arrayWithRecommendedItems;

@end

@implementation ProductDetailViewController


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initWithItem:(MMDItem*)item {
    self.currentItemToShow = item;
}


- (void)initialiseMenuItems
{
    
    self.tabBarController.delegate =self;
    
    [self.similarItemsList registerNibAndCell];
    [self.similarItemsList reloadData];
    
    [self.productDescription flashScrollIndicators];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.arrayWithRecommendedItems = [[NSMutableArray alloc] init];
    
    [self initialiseMenuItems];
    
    [self getRecommendedItems];
    
}

- (void)getRecommendedItems {
    dispatch_async(dispatch_queue_create("Reccommendations", nil), ^{
        NSMutableArray * tempArray = [[NSMutableArray alloc] init];
        
        for (MMDItem * item in [[MMDDataBase database] arrayWithItems]) {
            if (item.itemGender == female && [item.itemCategory isEqualToString:self.currentItemToShow.itemCategory]) {
                [tempArray addObject:item];
            }
        }
        
        if (tempArray.count > 0) {
            [self.arrayWithRecommendedItems removeAllObjects];
            for (int i = 0; i < (tempArray.count > 10 ? 10 : tempArray.count); i++) {
                int index = arc4random() % tempArray.count;
                [self.arrayWithRecommendedItems addObject:[tempArray objectAtIndex:index]];
                [tempArray removeObjectAtIndex:index];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.similarItemsList reloadData];
        });
        
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"product info %@", self.currentItemToShow.itemTitle);
    
    if (!self.currentItemToShow.itemIsInWishList) {
        UIBarButtonItem * addToWishList = [[UIBarButtonItem alloc] initWithTitle:@"Add To Wishlist" style:UIBarButtonItemStylePlain target:self action:@selector(addCurrentItemToWishList)];
        [self.navigationItem setRightBarButtonItem:addToWishList];
    }
    
    
    self.productTitle.text = [NSString stringWithFormat:@"%@", self.currentItemToShow.itemTitle ? self.currentItemToShow.itemTitle : @"N/A"];
    
    
    
    self.productPrice.text = [NSString stringWithFormat:@"£%.2f", self.currentItemToShow.itemPrice];
    
    
    self.productDescription.text = self.currentItemToShow.itemDescription;
    [self.productDescription setHidden:YES];
    
    [self addGestureRecognizer:self.productImage];
    
    self.productImage.userInteractionEnabled = YES;
    
    NSString *imagePath = self.currentItemToShow.itemImagePath;
    UIImage *itemImage = [UIImage imageWithContentsOfFile:imagePath];
    
    [self.productImage setImage:itemImage];
    [self.retailPageButton setTitle:self.currentItemToShow.itemStore.storeTitle forState:UIControlStateNormal];
    
    [self initialiseMenuItems];
    
}

- (void)addGestureRecognizer:(UIImageView *)imageView{
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    singleTap.delegate = self;
    [imageView addGestureRecognizer:singleTap];
}

-(void)handleTap:(UITapGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state != UIGestureRecognizerStateEnded) {
        return;
    }
    
    if (self.productDescription.isHidden) {
        [self.productDescription setHidden:NO];
        [self.productPrice setHidden:YES];
    }
    
    //CGPoint p = [gestureRecognizer locationInView:gestureRecognizer.view];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        [self.productDescription setHidden:YES];
        [self.productPrice setHidden:NO];
    }
}




-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    if (item.tag == 0) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        
        UINavigationController *map = [storyboard instantiateViewControllerWithIdentifier:@"profileNav"];
        
        [self showViewController:map sender:self];
        
    } else if (item.tag == 1) {
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
    if (self.arrayWithRecommendedItems.count > 0) {
        return 7;
    } else {
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ItemsSimilarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ISIM_CELL" forIndexPath:indexPath];
    
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    if (((MMDItem*)[self.arrayWithRecommendedItems objectAtIndex:indexPath.row]).itemImagePath != nil) {
        NSString *imagePath = ((MMDItem*)[self.arrayWithRecommendedItems objectAtIndex:indexPath.row]).itemImagePath;
        UIImage *itemImage = [UIImage imageWithContentsOfFile:imagePath];
        
        [dict setObject:itemImage forKey:kItemImage];
    }
    if (((MMDItem*)[self.arrayWithRecommendedItems objectAtIndex:indexPath.row]).itemBrand.brandImage != nil) {
        
        [dict setObject:((MMDItem*)[self.arrayWithRecommendedItems objectAtIndex:indexPath.row]).itemBrand.brandImage forKey:kBrandImage];
    }
    if (((MMDItem*)[self.arrayWithRecommendedItems objectAtIndex:indexPath.row]).itemStore.storeLogo != nil) {
        [dict setObject:((MMDItem*)[self.arrayWithRecommendedItems objectAtIndex:indexPath.row]).itemStore.storeLogo forKey:kStoreLogo];
    }
    [dict setObject:@"2 mi away" forKey:@"distance"];
    
    NSLog(@"in the prodDetail cell");
    
    [cell initWithDictionary:dict];
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    //  UINavigationController *det = [storyboard instantiateViewControllerWithIdentifier:@"detNav"];
    
    ProductDetailViewController *prodDetail = [storyboard instantiateViewControllerWithIdentifier:@"prodDetailView"];
    
    MMDItem* item = [self.arrayWithRecommendedItems objectAtIndex:indexPath.row];
    
    [prodDetail initWithItem:item];
    
    [self.navigationController pushViewController:prodDetail animated:YES];
    
    // [self showViewController:det sender:self];
    
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)addCurrentItemToWishList {
    [[MMDWishList sharedInstance] addItemToWishList:self.currentItemToShow];
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud setLabelText:@"Succesfully Added"];
    [hud setMode:MBProgressHUDModeText];
    [self.navigationItem setRightBarButtonItem:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        
        NSString *imagePath = self.currentItemToShow.itemImagePath;
        UIImage *itemImage = [UIImage imageWithContentsOfFile:imagePath];
        
        
        ALAlertBanner *banner = [ALAlertBanner alertBannerForView:appDelegate.window
                                                            style:ALAlertBannerStyleNotify
                                                         position:ALAlertBannerPositionTop
                                                            title:@"Offer!"
                                                         subtitle:[NSString stringWithFormat:@"There is an offer for you based on your %@.", self.currentItemToShow.itemTitle]
                                                            image:itemImage
                                                      tappedBlock:^(ALAlertBanner *alertBanner) {
                                                          [ALAlertBanner hideAllAlertBanners];
                                                          UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
                                                          ProductDetailViewController * itemPage = [storyboard instantiateViewControllerWithIdentifier:@"prodDetailView"];
#warning change for offer page
                                                          [itemPage initWithItem:self.currentItemToShow];
                                                          
                                                          [self.navigationController pushViewController:itemPage animated:YES];
                                                      }];
        
        [banner setSecondsToShow:3];
        [banner show];
        
        
        //        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Offer" message:@"There is an offer for you based on your wish list." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //        [alertView show];
    });
    
}

- (IBAction)retailPageButtonClicked:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    // UINavigationController *ret = [storyboard instantiateViewControllerWithIdentifier:@"retNav"];
    
    RetailDetailViewController * brandPage = [storyboard instantiateViewControllerWithIdentifier:@"retailPage"];
    [brandPage initWithStore:self.currentItemToShow.itemStore];
    [self.navigationController pushViewController:brandPage animated:YES];
    
    
    // [self showViewController:ret sender:self];
}

- (IBAction)buyThisItemButtonClicked:(id)sender {
    [self.currentItemToShow addItemToCart];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    PurchaseItemViewController * purchasePage = [storyboard instantiateViewControllerWithIdentifier:@"purchasePage"];
    
    [self.navigationController pushViewController:purchasePage animated:YES];
    
}

- (IBAction)toMapClicked:(UIButton *)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    MapViewForItemViewController *mapPage = [storyboard instantiateViewControllerWithIdentifier:@"itemMapView"];
    [mapPage initWithItem:self.currentItemToShow];
    [self.navigationController pushViewController:mapPage animated:YES];
    
}
@end
