//
//  MMDDataBase.h
//  MaiaMall Demo
//
//  Created by Illya Bakurov on 3/19/15.
//  Copyright (c) 2015 MaiaMall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "FMDatabase.h"

@interface MMDDataBase : NSObject <NSCoding> {
    FMDatabase * dataBase;
}

@property (strong, nonatomic) NSMutableArray * arrayWithItems;
@property (strong, nonatomic) NSMutableArray * arrayWithOffers;

+ (id)database;
- (void)initDatabase;
- (void)saveDatabase;
- (void)closeDataBase;

@end
