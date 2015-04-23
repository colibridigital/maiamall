//
//  ProductDetailViewController.h
//  MaiaMall
//
//  Created by Ingrid Funie on 19/03/2015.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemsSimilarCollectionView.h"
#import "MMDItem.h"
#import "ALAlertBanner.h"
#import "MBProgressHUD.h"

@interface ProductDetailViewController : UIViewController< UITabBarDelegate, UITabBarControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet ItemsSimilarCollectionView *similarItemsList;
- (IBAction)retailPageButtonClicked:(id)sender;
- (IBAction)buyThisItemButtonClicked:(id)sender;
- (IBAction)toMapClicked:(id)sender;

- (void)initWithItem:(MMDItem*)item;
- (void)addCurrentItemToWishList;

@property (strong, nonatomic) IBOutlet UIButton *addToWishlistButton;
@property (weak, nonatomic) IBOutlet UITabBar *tabBarController;
@property (weak, nonatomic) IBOutlet UILabel *productTitle;
@property (weak, nonatomic) IBOutlet UIImageView *productImage;
@property (weak, nonatomic) IBOutlet UILabel *productPrice;
@property (weak, nonatomic) IBOutlet UITextView *productDescription;
@property (weak, nonatomic) IBOutlet UIButton *retailPageButton;
@property (weak, nonatomic) IBOutlet UIButton *buyThisButton;
@end
