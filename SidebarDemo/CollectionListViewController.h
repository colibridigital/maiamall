//
//  CollectionListViewController.h
//  MaiaMall
//
//  Created by Ingrid Funie on 27/03/2015.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionDetailCollectionView.h"

@interface CollectionListViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate, UITabBarControllerDelegate, UITabBarDelegate>
@property (weak, nonatomic) IBOutlet UITabBar *tabBarController;

@property (weak, nonatomic) IBOutlet CollectionDetailCollectionView *collectionDetailView;
@property (strong, nonatomic) IBOutlet UILabel *collectionTitle;
@property (strong, nonatomic) NSString *colText;
@property (strong, nonatomic) IBOutlet NSMutableArray *currentItems;

-(void)initWithItemsArray:(NSMutableArray*)items;
-(void)initWithTitleText:(NSString*)text;

@end
