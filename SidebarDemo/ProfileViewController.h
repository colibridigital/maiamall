//
//  ProfileViewController.h
//  MaiaMall
//
//  Created by Ingrid Funie on 20/03/2015.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionsCollectionView.h"
#import "FavouritesListCollectionView.h"

@interface ProfileViewController : UIViewController<UISearchBarDelegate, UITabBarControllerDelegate, UITabBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (strong, nonatomic) IBOutlet UITabBar *tabBarController;
@property (strong, nonatomic) IBOutlet CollectionsCollectionView *collsCollectionView;
@property (strong, nonatomic) IBOutlet FavouritesListCollectionView *favsCollectionView;
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) IBOutlet UIButton *folllowButton;

@property (strong, nonatomic) NSMutableArray * arrayWithSearchResults;

@property (strong, nonatomic) NSMutableArray * summerItems;
@property (strong, nonatomic) NSMutableArray * shoesItems;
@property (strong, nonatomic) NSMutableArray * bagsItems;
@property (strong, nonatomic) NSMutableArray * formalItems;
@property (strong, nonatomic) NSMutableArray * shirtsItems;
@property (strong, nonatomic) NSMutableArray * favCollItems;

@end
