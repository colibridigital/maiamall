//
//  MMDWishList.m
//  MaiaMall Demo
//
//  Created by Illya Bakurov on 3/19/15.
//  Copyright (c) 2015 MaiaMall. All rights reserved.
//

#import "MMDWishList.h"

@interface MMDWishList() <NSCoding>
@property (strong, nonatomic, readwrite) NSMutableArray * wishList;
@end

@implementation MMDWishList

@synthesize wishList = _wishList;

+(id)sharedInstance {
    static dispatch_once_t onceToken;
    static MMDWishList *shared_instance = nil;
    dispatch_once(&onceToken, ^{
        shared_instance = [MMDWishList getWishListFromUserDefaults];
    });
    return shared_instance;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.wishList forKey:kWishList];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self.wishList = [[NSMutableArray alloc] initWithArray:[[aDecoder decodeObjectForKey:kWishList] copy]];
    return self;
}

//lazy instantiation
- (NSMutableArray*)wishList {
    if (_wishList == nil) {
        return _wishList = [[NSMutableArray alloc] init];
    }
    return _wishList;
}

- (void)addItemToWishList:(MMDItem*)item {
    [item setItemIsInWishList:YES];
    [self.wishList addObject:item];
    [self saveWishListIntoUserDefaults];
}

- (void)removeItemFromWishListAtObjectIndex:(NSUInteger)index {
    [[self.wishList objectAtIndex:index] setItemIsInWishList:NO];
    [self.wishList removeObjectAtIndex:index];
    [self saveWishListIntoUserDefaults];
}

- (void)saveWishListIntoUserDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    [defaults setObject:data forKey:kWishListData];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (MMDWishList*)getWishListFromUserDefaults {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kWishListData]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *data = [defaults objectForKey:kWishListData];
        return[NSKeyedUnarchiver unarchiveObjectWithData:data];
    } else {
        return [[MMDWishList alloc] init];
    }
}

@end
