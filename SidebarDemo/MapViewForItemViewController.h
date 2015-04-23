//
//  MapViewForItemViewController.h
//  MaiaMall
//
//  Created by Ingrid Funie on 14/04/2015.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <JPSThumbnailAnnotation/JPSThumbnailAnnotation.h>
#import <GoogleMaps/GoogleMaps.h>
#import "MMDItem.h"
#import "ProductDetailViewController.h"

@interface MapViewForItemViewController : UIViewController<GMSMapViewDelegate, UITabBarControllerDelegate, UITabBarDelegate>

@property (strong, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UITabBar *tabBarController;
@property (strong, nonatomic) MMDItem * currentItem;

- (void)initWithItem:(MMDItem*)item;

@end
