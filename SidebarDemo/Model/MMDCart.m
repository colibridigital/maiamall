//
//  MMDCart.m
//  MaiaMall Demo
//
//  Created by Illya Bakurov on 3/25/15.
//  Copyright (c) 2015 MaiaMall. All rights reserved.
//

#import "MMDCart.h"

@implementation MMDCart

+(id)cart {
    static dispatch_once_t onceToken;
    static MMDCart *shared_instance = nil;
    dispatch_once(&onceToken, ^{
        shared_instance = [MMDCart getDataFromDefaults];
        if (shared_instance.arrayWithItemsToPurchase == nil) {
            shared_instance.arrayWithItemsToPurchase = [[NSMutableArray alloc] init];
        }
    });
    return shared_instance;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.arrayWithItemsToPurchase forKey:kArrayWithItemsToPurchase];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ([aDecoder decodeObjectForKey:kArrayWithItemsToPurchase]) {
        self.arrayWithItemsToPurchase = [[NSMutableArray alloc] initWithArray:[aDecoder decodeObjectForKey:kArrayWithItemsToPurchase]];
    } else {
        self.arrayWithItemsToPurchase = [[NSMutableArray alloc] init];
    }
    
    return self;
}

+ (MMDCart*)getDataFromDefaults {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kCart]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *data = [defaults objectForKey:kCart];
        return[NSKeyedUnarchiver unarchiveObjectWithData:data];
    } else {
        return [[MMDCart alloc] init];
    }
}

- (void)saveCartIntoDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    [defaults setObject:data forKey:kCart];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)cartWasPurchased {
    if (self.arrayWithItemsToPurchase.count > 0) {
        for (MMDItem * item in self.arrayWithItemsToPurchase) {
            [item annulateItemInCart];
        }
        [self.arrayWithItemsToPurchase removeAllObjects];
    }
    [self saveCartIntoDefaults];
}

@end
