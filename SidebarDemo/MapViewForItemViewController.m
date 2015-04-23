//
//  MapViewForItemViewController.m
//  MaiaMall
//
//  Created by Ingrid Funie on 14/04/2015.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import "MapViewForItemViewController.h"

@interface MapViewForItemViewController () 

@end

@implementation MapViewForItemViewController

- (void)initWithItem:(MMDItem*)item {
    self.currentItem = [[MMDItem alloc] initWithItem:item];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mapView.delegate = self;
    self.mapView.myLocationEnabled = YES;
    
    self.tabBarController.delegate =self;
    
    UITabBarItem *item = [self.tabBarController.items objectAtIndex:1];
    item.image = [[UIImage imageNamed:@"User Female-50.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    item = [self.tabBarController.items objectAtIndex:0];
    item.image = [[UIImage imageNamed:@"Home-50.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    item = [self.tabBarController.items objectAtIndex:2];
    item.image = [[UIImage imageNamed:@"News-50-2.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    item = [self.tabBarController.items objectAtIndex:3];
    item.image = [[UIImage imageNamed:@"Location-50.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [self.navigationItem.backBarButtonItem setTintColor:[UIColor colorWithRed:86.0/255.0 green:62.0/255.0 blue:51.0/255.0 alpha:1.0]];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self populateMapWithData];
    
    self.tabBarController.delegate =self;
    
    UITabBarItem *item = [self.tabBarController.items objectAtIndex:1];
    item.image = [[UIImage imageNamed:@"User Female-50.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    item = [self.tabBarController.items objectAtIndex:0];
    item.image = [[UIImage imageNamed:@"Home-50.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    item = [self.tabBarController.items objectAtIndex:2];
    item.image = [[UIImage imageNamed:@"News-50-2.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    item = [self.tabBarController.items objectAtIndex:3];
    item.image = [[UIImage imageNamed:@"Location-50.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [self.navigationItem.backBarButtonItem setTintColor:[UIColor colorWithRed:86 green:62 blue:51 alpha:1.0]];

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

#pragma mark - working with the map

- (void)populateMapWithData {
    
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(self.currentItem.itemStore.storeLatitude, self.currentItem.itemStore.storeLongitude);
    
    GMSMarker *marker = [GMSMarker markerWithPosition:coordinate];
    
    marker.title =  self.currentItem.itemStore.storeTitle;
    
    marker.snippet =  self.currentItem.itemTitle;
    
    marker.flat = YES;
    
    CGFloat widthOfMarker = 50;
    CGFloat heightOfMarker = 50;
    
    CGFloat widthOfMarkersBoard = 1;
    CGFloat heightOfMarkersTail = heightOfMarker/10 + 1; //this is just works ;)
    
    UIImage * imageOfBubble = [UIImage imageNamed:@"BubbleView"];
    
    UIGraphicsBeginImageContext(CGSizeMake(widthOfMarker, heightOfMarker));
    [imageOfBubble drawInRect:CGRectMake(0, 0, widthOfMarker, heightOfMarker)];
    
    NSString *imagePath = self.currentItem.itemImagePath;
    UIImage *itemImage = [UIImage imageWithContentsOfFile:imagePath];
    
    
    [itemImage drawInRect:CGRectMake(widthOfMarkersBoard, widthOfMarkersBoard, widthOfMarker-widthOfMarkersBoard*2, heightOfMarker - (heightOfMarkersTail + widthOfMarkersBoard))];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    marker.icon = newImage;
    
    marker.map = self.mapView;
    
    [self focusMapToShowAllMarkers];
    
}

- (void)focusMapToShowAllMarkers
{
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.currentItem.itemStore.storeLatitude
                                                            longitude:self.currentItem.itemStore.storeLongitude
                                                                 zoom:15];
    
    [self.mapView animateToCameraPosition:camera];
    
}

@end
