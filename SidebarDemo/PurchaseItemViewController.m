//
//  PurchaseItemViewController.m
//  MaiaMall
//
//  Created by Ingrid Funie on 06/04/2015.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import "PurchaseItemViewController.h"
#import "SWRevealViewController.h"
#import "ProductListViewController.h"
#import "MapViewController.h"

@interface PurchaseItemViewController ()

@end

@implementation PurchaseItemViewController

- (void)calculatePrice
{
    float subtotalPrice = 0.0;
    
    for (MMDItem * item in [[MMDCart cart] arrayWithItemsToPurchase]) {
        if (item.itemNumberInCart > 0) {
            subtotalPrice += item.itemNumberInCart * item.itemPrice;
        }
    }
    
    self.basketSubtotalPrice.text = [NSString stringWithFormat:@"Basket Subtotal: %.2f", subtotalPrice];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self calculatePrice];
    
    [self initialiseMenuItems];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:NO];
    
    [self calculatePrice];
    
    [self initialiseMenuItems];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    
    [self calculatePrice];
    
    [self initialiseMenuItems];
    
    [self addGestureRecognizer:self.cartTitle];
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
    
    self.tabBarController.delegate = self;
    
    UITabBarItem *item = [self.tabBarController.items objectAtIndex:1];
    item.image = [[UIImage imageNamed:@"User Female-50.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    item = [self.tabBarController.items objectAtIndex:0];
    item.image = [[UIImage imageNamed:@"Home-50.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    item = [self.tabBarController.items objectAtIndex:2];
    item.image = [[UIImage imageNamed:@"News-50-2.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    item = [self.tabBarController.items objectAtIndex:3];
    item.image = [[UIImage imageNamed:@"Location-50.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}



- (IBAction)plusButtonClicked:(UIButton *)sender {
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.cartTV];
    NSIndexPath *indexPath = [self.cartTV indexPathForRowAtPoint:buttonPosition];
    
    [[[[MMDCart cart] arrayWithItemsToPurchase] objectAtIndex:indexPath.row] addItemToCart];
    [((PurchaseItemTableViewCell*)[self.cartTV cellForRowAtIndexPath:indexPath]) setTextFieldTextFornumber:((MMDItem*)[[[MMDCart cart] arrayWithItemsToPurchase] objectAtIndex:indexPath.row]).itemNumberInCart];
    [self.cartTV reloadData];
    [self calculatePrice];
}

- (IBAction)minusButtonClicked:(UIButton *)sender {
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.cartTV];
    NSIndexPath *indexPath = [self.cartTV indexPathForRowAtPoint:buttonPosition];
    
    if (((MMDItem*)[[[MMDCart cart] arrayWithItemsToPurchase] objectAtIndex:indexPath.row]).itemNumberInCart > 0) {
        [[[[MMDCart cart] arrayWithItemsToPurchase] objectAtIndex:indexPath.row] decrementItemFromCart];
        [((PurchaseItemTableViewCell*)[self.cartTV cellForRowAtIndexPath:indexPath]) setTextFieldTextFornumber:((MMDItem*)[[[MMDCart cart] arrayWithItemsToPurchase] objectAtIndex:indexPath.row]).itemNumberInCart];
        [self.cartTV reloadData];
    } else if (((MMDItem*)[[[MMDCart cart] arrayWithItemsToPurchase] objectAtIndex:indexPath.row]).itemNumberInCart == 0) {
        [[[[MMDCart cart] arrayWithItemsToPurchase] objectAtIndex:indexPath.row] removeItemFromCart];
        [self.cartTV reloadData];
    }
    
    [self calculatePrice];
    
}

- (void)addGestureRecognizer:(UILabel *)label{
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    singleTap.delegate = self;
    [label addGestureRecognizer:singleTap];
}

- (void)purchaseItems {
    if([[MMDCart cart] arrayWithItemsToPurchase].count > 0) {
        [[MMDCart cart] cartWasPurchased];
        
        //    [MBProgressHUD hideAllHUDsForView:self.cartTV animated:YES];
        
        ALAlertBanner *banner = [ALAlertBanner alertBannerForView:self.view
                                                            style:ALAlertBannerStyleNotify
                                                         position:ALAlertBannerPositionTop
                                                            title:@"Thank you!"
                                                         subtitle:@"Your purchase was successfull. Do not forget to pick your items up in the store!"
                                                            image:nil
                                                      tappedBlock:nil];
        [banner setSecondsToShow:0];
        [banner show];
        
        
        
        //        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Thank you!" message:@"Your purchase was successfull. Do not forget to pick your items up in the store!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //        [alertView show];
        
        self.basketSubtotalPrice.text = [NSString stringWithFormat:@"Basket Subtotal: %.2f", 0.00];
        
        [self.cartTV reloadData];
    };
}

-(void)handleTap:(UITapGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state != UIGestureRecognizerStateEnded) {
        return;
    }
    
    [self purchaseItems];
    
    //CGPoint p = [gestureRecognizer locationInView:gestureRecognizer.view];
    
}

- (IBAction)purchaseButtonClicked:(UIButton *)sender {
    
    [self purchaseItems];
}

#pragma mark - Table View DataSourca and Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([[MMDCart cart] arrayWithItemsToPurchase].count > 0) {
        [self.messageLabel setText:@""];
        self.cartTV.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        return [[MMDCart cart] arrayWithItemsToPurchase].count;
    } else {
        
        // Display a message when the table is empty
        self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        self.messageLabel.text = @"Your cart is empty.";
        self.messageLabel.textColor = [UIColor lightGrayColor];
        self.messageLabel.numberOfLines = 0;
        self.messageLabel.textAlignment = NSTextAlignmentCenter;
        self.messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
        [self.messageLabel sizeToFit];
        
        self.cartTV.backgroundView = self.messageLabel;
        self.cartTV.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        return 0;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PurchaseItemTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"itemCell"];
    
    MMDItem *item = [[[MMDCart cart] arrayWithItemsToPurchase] objectAtIndex:indexPath.row];
    
    [cell initCellWithItem:item];
    
    /* float totalPrice = 0.0;
     
     for (MMDItem * item in [[MMDCart cart] arrayWithItemsToPurchase]) {
     if (item.itemNumberInCart > 0) {
     totalPrice += item.itemNumberInCart * item.itemPrice;
     }
     }*/
    
    [cell initTotalPrice:item.itemPrice];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[[[MMDCart cart] arrayWithItemsToPurchase] objectAtIndex:indexPath.row] removeItemFromCart];
        [tableView reloadData];
        [self calculatePrice];
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
                if ((([[item.itemTitle lowercaseString] rangeOfString:[self.searchBar.text lowercaseString]].location != NSNotFound) || ([[item.itemCategory lowercaseString] rangeOfString:[self.searchBar.text lowercaseString]].location != NSNotFound)) && item.itemGender == female) {
                    [self.arrayWithSearchResults addObject:item];
                }
            } else {
                if (([[item.itemTitle lowercaseString] rangeOfString:[self.searchBar.text lowercaseString]].location != NSNotFound) || ([[item.itemCategory lowercaseString] rangeOfString:[self.searchBar.text lowercaseString]].location != NSNotFound)) {
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

- (IBAction)filterSearchMenuClicked:(id)sender {
    
    self.arrayWithSearchResults = [[NSMutableArray alloc] init];
    
    for (MMDItem* item in [[MMDDataBase database] arrayWithItems]) {
        if (![[NSUserDefaults standardUserDefaults] boolForKey:kFemaleOrMaleSwitch]) {
            if ((([[item.itemTitle lowercaseString] rangeOfString:[self.searchBar.text lowercaseString]].location != NSNotFound) || ([[item.itemCategory lowercaseString] rangeOfString:[self.searchBar.text lowercaseString]].location != NSNotFound)) && item.itemGender == female) {
                [self.arrayWithSearchResults addObject:item];
            }
        } else {
            if (([[item.itemTitle lowercaseString] rangeOfString:[self.searchBar.text lowercaseString]].location != NSNotFound) || ([[item.itemCategory lowercaseString] rangeOfString:[self.searchBar.text lowercaseString]].location != NSNotFound)) {
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


#pragma mark - Collection View DataSource and Delegate

@end
