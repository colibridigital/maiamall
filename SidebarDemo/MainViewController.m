//
//  ViewController.m
//  SidebarDemo
//
//  Created by Simon on 28/6/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "MainViewController.h"
#import "SWRevealViewController.h"
#import "TrendCollectionViewCell.h"
#import "MapViewController.h"
#import "ProductCollectionViewCell.h"
#import "ProductListViewController.h"
#import "TrendsViewController.h"
#import "ProductDetailViewController.h"

@interface MainViewController ()
@property (nonatomic) BOOL genderWasChanged;
@end

@implementation MainViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
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

    
    self.appDelegate = [[AppDelegate alloc] init];
    
    self.arrayWithRecommendedItems = [[NSMutableArray alloc] init];
    
    
    [searchBarView addSubview:self.searchBar];
    self.navigationItem.titleView = searchBarView;

    
    [self.trendCollectionView registerNibAndCell];
    [self.productCollectionView registerNibAndCell];
    
    [self.trendCollectionView reloadData];
    [self.productCollectionView reloadData];
    
    
    self.tabBarController.delegate = self;
  
    
    self.arrayWithSearchResults = [[NSMutableArray alloc] init];
    
    self.genderWasChanged = NO;
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:kDataBaseWasInitiated]) {
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"Wait. Initialiazing Database";
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [MMDDataBase database];
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            [self getTrendingItems];
        });
    } else {
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"Wait. Loading Database";
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self getTrendingItems];
        });
        
    }

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    settingsViewController.delegate = self;
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kDataBaseWasInitiated]) {
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"Wait. Loading Database";
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            [self getTrendingItems];
        });
        
    }

   // [self getTrendingItems];
    
}
    
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.searchBar resignFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:kDataBaseWasInitiated]) {
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"Wait. Initialiazing Database";
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MMDDataBase database];
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            [self getTrendingItems];
        });
        
    }
}


- (void)genderWasChangedFrom:(kGender)fromGender to:(kGender)toGender {
    self.genderWasChanged = YES;
    [self getTrendingItems];
}

- (void)getTrendingItems {
    
    //totally dummy. that is why it is done in such dummy way. Should be rewritten when possible.
    
    if (self.arrayWithRecommendedItems.count == 0) {
       
        dispatch_async(dispatch_queue_create("Trend loading", nil), ^{
            NSMutableArray * tempArray = [[NSMutableArray alloc] init];
        
                for (MMDItem* item in [[MMDDataBase database] arrayWithItems]) {
                    
                    if (item.itemGender == female && ![[NSUserDefaults standardUserDefaults] boolForKey:kFemaleOrMaleSwitch]) {
                        
                                int category = arc4random() % 3;
                        if ([item.itemCategory isEqualToString:(category == 0 ? @"Shirts" : (category == 1 ? @"Dresses" : (category == 2 ? @"Bags" : @"Shoes")))]) {
                                    [tempArray addObject:item];
                                }
                        }
                    
                    if (item.itemGender == male && [[NSUserDefaults standardUserDefaults] boolForKey:kFemaleOrMaleSwitch]) {
                        // here is male
                        
                        int category = arc4random() % 3;
                        if ([item.itemCategory isEqualToString:(category == 0 ? @"Shirts" : (category == 1 ? @"Jackets" : (category == 2 ? @"Trousers" : @"Shoes")))]) {
                            [tempArray addObject:item];
                        }
                    }

                }
            
            
            if (tempArray.count > 0) {
                [self.arrayWithRecommendedItems removeAllObjects];
                for (int i = 0; i < (tempArray.count > 15 ? 15 : tempArray.count); i++) {
                    int index = arc4random() % tempArray.count;
                    [self.arrayWithRecommendedItems addObject:[tempArray objectAtIndex:index]];
                    [tempArray removeObjectAtIndex:index];
                }
            }
         dispatch_async(dispatch_get_main_queue(), ^{
                
             [self.productCollectionView reloadData];
         });
        });
    }
    
}




-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
   // NSLog(@"Touch detected");
    
    [self.view endEditing:YES];
    [self.searchBar resignFirstResponder];
    
}

/*- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return CGRectContainsPoint([[self dropDown] frame], [touch locationInView:[self view]]) && !(CGRectContainsPoint([[self trendCollectionView] frame], [touch locationInView:[self view]]));
}*/


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    // return
    return true;
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
    if (collectionView == self.trendCollectionView) {
        return 5;
    } else if (collectionView == self.productCollectionView) {
        
        NSLog(@"count of items: %lu", (unsigned long)self.arrayWithRecommendedItems.count);
        
        return self.arrayWithRecommendedItems.count;
    }
    
    else return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.trendCollectionView) {
        TrendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TREND_CELL" forIndexPath:indexPath];
        if (![[NSUserDefaults standardUserDefaults] boolForKey:kFemaleOrMaleSwitch]) {
            if (indexPath.row == 4) {
                UIImage *img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"naomi" ofType: @"jpg"]];
                
                cell.trendImage.image = img;
                
            } else if (indexPath.row == 3) {
                UIImage *img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"denimTrend" ofType: @"jpg"]];
                
                cell.trendImage.image = img;
            } else if (indexPath.row == 2) {
                UIImage *img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"vogueTrend" ofType: @"jpg"]];
                
                cell.trendImage.image = img;
            } else if (indexPath.row == 1) {
                UIImage *img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shoesTrend" ofType: @"jpg"]];
                
                cell.trendImage.image = img;
            } else if (indexPath.row == 0) {
                UIImage *img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bagsTrend" ofType: @"jpg"]];
                
                cell.trendImage.image = img;
            }
        }else {
            if (indexPath.row == 4) {
                UIImage *img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"printsMen" ofType: @"jpg"]];
                
                cell.trendImage.image = img;
                
            } else if (indexPath.row == 3) {
                UIImage *img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"jeans" ofType: @"png"]];
                
                cell.trendImage.image = img;
            } else if (indexPath.row == 2) {
                UIImage *img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shoes" ofType: @"jpg"]];
                
                cell.trendImage.image = img;
            } else if (indexPath.row == 1) {
                UIImage *img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tshirt" ofType: @"png"]];
                
                cell.trendImage.image = img;
            } else if (indexPath.row == 0) {
                UIImage *img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"suit" ofType: @"jpg"]];
                
                cell.trendImage.image = img;
            }

        }
        
        return cell;
    } else {
        ProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PROD_CELL" forIndexPath:indexPath];
        
        NSLog(@"in showing the cell");
        
        NSString *imagePath = ((MMDItem*)[self.arrayWithRecommendedItems objectAtIndex:indexPath.item]).itemImagePath;
        
        UIImage *itemImage = [UIImage imageWithContentsOfFile:imagePath];
        
        cell.productImage.image = itemImage;
        
        return cell;
    }
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == self.productCollectionView) {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        
        //  UINavigationController *det = [storyboard instantiateViewControllerWithIdentifier:@"detNav"];
        
        ProductDetailViewController *prodDetail = [storyboard instantiateViewControllerWithIdentifier:@"prodDetailView"];
        
        MMDItem* item = [self.arrayWithRecommendedItems objectAtIndex:indexPath.row];
        
        NSLog(@"product info before setting %@", item.itemTitle);
        
        [prodDetail initWithItem:item];
        
        [self.navigationController pushViewController:prodDetail animated:YES];
        
        // [self showViewController:det sender:self];
    } else if (collectionView == self.trendCollectionView) {
        
        if (![[NSUserDefaults standardUserDefaults] boolForKey:kFemaleOrMaleSwitch]) {
            if (indexPath.row == 4) {
                
                NSString *myURL = @"http://www.fashionsfinest.com/fashion/celebrity-style/item/3973-ultimate-style-from-naomi-campbell";
                
                NSURL *url =[NSURL URLWithString:myURL];
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
                
                TrendsViewController* trendsVC = [storyboard instantiateViewControllerWithIdentifier:@"trendsView"];
                
                [trendsVC initWithURL:url];
                
                [self.navigationController pushViewController:trendsVC animated:YES];
                
               // [[UIApplication sharedApplication] openURL:url];
            } else if (indexPath.row == 3) {
                NSString *myURL = @"http://www.style.com/trends/fashion";
                
                NSURL *url =[NSURL URLWithString:myURL];
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
                
                TrendsViewController* trendsVC = [storyboard instantiateViewControllerWithIdentifier:@"trendsView"];
                
                [trendsVC initWithURL:url];
                
                [self.navigationController pushViewController:trendsVC animated:YES];
                
                //[[UIApplication sharedApplication] openURL:url];
            } else if (indexPath.row == 2) {
                NSString *myURL = @"http://www.vogue.co.uk/fashion/trends";
                
                NSURL *url =[NSURL URLWithString:myURL];
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
                
                TrendsViewController* trendsVC = [storyboard instantiateViewControllerWithIdentifier:@"trendsView"];
                
                [trendsVC initWithURL:url];
                
                [self.navigationController pushViewController:trendsVC animated:YES];
                
               // [[UIApplication sharedApplication] openURL:url];
            } else if (indexPath.row == 1) {
                NSString *myURL = @"http://www.fashionisers.com/trends/spring-summer-2015-shoe-trends/";

                
                NSURL *url =[NSURL URLWithString:myURL];
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
                
                TrendsViewController* trendsVC = [storyboard instantiateViewControllerWithIdentifier:@"trendsView"];
                
                [trendsVC initWithURL:url];
                
                [self.navigationController pushViewController:trendsVC animated:YES];
                
               // [[UIApplication sharedApplication] openURL:url];
            } else if (indexPath.row == 0) {
                NSString *myURL = @"http://www.purseblog.com/news/30-best-bags-spring-2015-runways/";
                
                NSURL *url =[NSURL URLWithString:myURL];
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
                
                TrendsViewController* trendsVC = [storyboard instantiateViewControllerWithIdentifier:@"trendsView"];
                
                [trendsVC initWithURL:url];
                
                [self.navigationController pushViewController:trendsVC animated:YES];
                
               // [[UIApplication sharedApplication] openURL:url];
            }
        } else {
            if (indexPath.row == 4) {
                
                NSString *myURL = @"http://www.telegraph.co.uk/men/fashion-and-style/11304179/Five-key-mens-style-trends-for-2015.html";
                
                NSURL *url =[NSURL URLWithString:myURL];
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
                
                TrendsViewController* trendsVC = [storyboard instantiateViewControllerWithIdentifier:@"trendsView"];
                
                [trendsVC initWithURL:url];
                
                [self.navigationController pushViewController:trendsVC animated:YES];
                
               // [[UIApplication sharedApplication] openURL:url];
            } else if (indexPath.row == 3) {
                NSString *myURL = @"http://www.brostrick.com/mens-fashion/best-mens-jeans-denim-pants/";
                
                NSURL *url =[NSURL URLWithString:myURL];
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
                
                TrendsViewController* trendsVC = [storyboard instantiateViewControllerWithIdentifier:@"trendsView"];
                
                [trendsVC initWithURL:url];
                
                [self.navigationController pushViewController:trendsVC animated:YES];
                
               // [[UIApplication sharedApplication] openURL:url];
            } else if (indexPath.row == 2) {
                NSString *myURL = @"http://www.gq.com/style/style-manual/201204/dress-shoes-leather-polish#slide=1";
                
                NSURL *url =[NSURL URLWithString:myURL];
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
                
                TrendsViewController* trendsVC = [storyboard instantiateViewControllerWithIdentifier:@"trendsView"];
                
                [trendsVC initWithURL:url];
                
                [self.navigationController pushViewController:trendsVC animated:YES];
                
               // [[UIApplication sharedApplication] openURL:url];
            } else if (indexPath.row == 1) {
                NSString *myURL = @"http://www.brostrick.com/mens-fashion/t-shirts-for-men-graphic-tees/";
                NSURL *url =[NSURL URLWithString:myURL];
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
                
                TrendsViewController* trendsVC = [storyboard instantiateViewControllerWithIdentifier:@"trendsView"];
                
                [trendsVC initWithURL:url];
                
                [self.navigationController pushViewController:trendsVC animated:YES];
                
               // [[UIApplication sharedApplication] openURL:url];
            } else if (indexPath.row == 0) {
                NSString *myURL = @"http://www.fashionbeans.com/2014/mens-fashion-trend-2015-dressed-down-suiting/";
                
                NSURL *url =[NSURL URLWithString:myURL];
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
                
                TrendsViewController* trendsVC = [storyboard instantiateViewControllerWithIdentifier:@"trendsView"];
                
                [trendsVC initWithURL:url];
                
                [self.navigationController pushViewController:trendsVC animated:YES];
                
                //[[UIApplication sharedApplication] openURL:url];
            }

        }
        
    }
    
}




- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    //UINavigationController *prodListDetails = [storyboard instantiateViewControllerWithIdentifier:@"prodNav"];
    
   // [self showViewController:prodListDetails sender:self];
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Searching...";
    
    dispatch_async(dispatch_queue_create("Search", nil), ^{
        self.arrayWithSearchResults = [[NSMutableArray alloc] init];
        
        for (MMDItem* item in [[MMDDataBase database] arrayWithItems]) {
            if (![[NSUserDefaults standardUserDefaults] boolForKey:kFemaleOrMaleSwitch]) {
                    if ([[item.itemTitle lowercaseString] rangeOfString:[searchBar.text lowercaseString]].location != NSNotFound && item.itemGender == female) {
                        [self.arrayWithSearchResults addObject:item];
                    }
            } else {
                if ([[item.itemTitle lowercaseString] rangeOfString:[searchBar.text lowercaseString]].location != NSNotFound) {
                    [self.arrayWithSearchResults addObject:item];
                }
            }
          
        }
        
        if (self.arrayWithSearchResults.count > 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
                ProductListViewController * searchPage = [storyboard instantiateViewControllerWithIdentifier:@"prodListSearchDetails"];
                [searchPage initWithArrayWithSearchResults:self.arrayWithSearchResults andTextForSearch:self.searchBar.text];
                [self.navigationController pushViewController:searchPage animated:YES];
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
        
    });

    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"FilterMenuSegue"])
    {
        NSLog(@"in here");
        
        WYStoryboardPopoverSegue *popoverSegue = (WYStoryboardPopoverSegue *)segue;
        anotherPopoverController = [popoverSegue popoverControllerWithSender:sender
                                                    permittedArrowDirections:WYPopoverArrowDirectionDown
                                                                    animated:YES
                                                                     options:WYPopoverAnimationOptionFadeWithScale];
        
        anotherPopoverController.popoverContentSize = CGSizeMake(220, 360);
        
        anotherPopoverController.delegate = self;
    }
}

#pragma mark - WYPopoverControllerDelegate

- (void)popoverControllerDidPresentPopover:(WYPopoverController *)controller
{
    NSLog(@"popoverControllerDidPresentPopover");
}

- (BOOL)popoverControllerShouldDismissPopover:(WYPopoverController *)controller
{
    return YES;
}

- (void)popoverControllerDidDismissPopover:(WYPopoverController *)controller
{
    if (controller == anotherPopoverController)
    {
        anotherPopoverController.delegate = nil;
        anotherPopoverController = nil;
    }
   
}

- (BOOL)popoverControllerShouldIgnoreKeyboardBounds:(WYPopoverController *)popoverController
{
    return YES;
}

- (void)popoverController:(WYPopoverController *)popoverController willTranslatePopoverWithYOffset:(float *)value
{
    // keyboard is shown and the popover will be moved up by 163 pixels for example ( *value = 163 )
    *value = 0; // set value to 0 if you want to avoid the popover to be moved
}





- (IBAction)filterSearchMenuClicked:(id)sender {
    
    self.arrayWithSearchResults = [[NSMutableArray alloc] init];
    
    for (MMDItem* item in [[MMDDataBase database] arrayWithItems]) {
        if (![[NSUserDefaults standardUserDefaults] boolForKey:kFemaleOrMaleSwitch]) {
            if ([[item.itemTitle lowercaseString] rangeOfString:[self.searchBar.text lowercaseString]].location != NSNotFound && item.itemGender == female) {
                [self.arrayWithSearchResults addObject:item];
            }
        } else {
            if ([[item.itemTitle lowercaseString] rangeOfString:[self.searchBar.text lowercaseString]].location != NSNotFound) {
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

@end
