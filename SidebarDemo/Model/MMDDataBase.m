//
//  MMDDataBase.m
//  MaiaMall Demo
//
//  Created by Illya Bakurov on 3/19/15.
//  Copyright (c) 2015 MaiaMall. All rights reserved.
//

#import "MMDDataBase.h"
#import "MMDItem.h"
#import "MMDStore.h"
#import "MMDOffer.h"
#import "MMDBrand.h"

@implementation MMDDataBase

static MMDDataBase *dataBase;

+(id)database {
    static dispatch_once_t onceToken;
    static MMDDataBase *shared_instance = nil;
    dispatch_once(&onceToken, ^{
        if ([[NSUserDefaults standardUserDefaults] boolForKey:kDataBaseWasInitiated]) {
            shared_instance = [MMDDataBase getDataBase];
        } else {
            shared_instance = [[MMDDataBase alloc] init];
            [shared_instance initDatabase];
        }
    });
    return shared_instance;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.arrayWithItems forKey:kItemsInDataBase];
    [aCoder encodeObject:self.arrayWithOffers forKey:kOffersInDataBase];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ([aDecoder decodeObjectForKey:kItemsInDataBase]) {
        self.arrayWithItems = [[NSMutableArray alloc] initWithArray:[aDecoder decodeObjectForKey:kItemsInDataBase]];
    } else {
        self.arrayWithItems = [[NSMutableArray alloc] init];
    }
    
    if ([aDecoder decodeObjectForKey:kOffersInDataBase]) {
        self.arrayWithOffers = [[NSMutableArray alloc] initWithArray:[aDecoder decodeObjectForKey:kOffersInDataBase]];
    } else {
        self.arrayWithOffers = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (id)init {
    if ((self = [super init])) {
        NSString *sqLiteDb = [[NSBundle mainBundle] pathForResource:@"maiamall"
                                                             ofType:@"s3db"];
        
        if (sqlite3_open([sqLiteDb UTF8String], &dataBase) != SQLITE_OK) {
            NSLog(@"Failed to open database!");
        }
    }
    return self;
}

+ (MMDDataBase*)getDataBase {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kDataBase]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *data = [defaults objectForKey:kDataBase];
        return[NSKeyedUnarchiver unarchiveObjectWithData:data];
    } else {
        return [[MMDDataBase alloc] init];
    }
}

- (void)saveDataBase {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    [defaults setObject:data forKey:kDataBase];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)closeDataBase {
    sqlite3_close(dataBase);
}

- (void)initDatabase {
    self.arrayWithItems = [[NSMutableArray alloc] initWithArray:[self getItems]];
    self.arrayWithOffers = [[NSMutableArray alloc] initWithArray:[self getOffers]];
    [self saveDataBase];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kDataBaseWasInitiated];
    [self closeDataBase];
}

- (MMDStore *)getStoreDetails:(int)itemStoreId {
    MMDStore *itemStore;
    NSString *queryForStoreName = [NSString stringWithFormat:@"SELECT longName, logourl FROM Store WHERE id=%i", itemStoreId];
    sqlite3_stmt *statementForStoreName;
    if (sqlite3_prepare_v2(dataBase, [queryForStoreName UTF8String], -1, &statementForStoreName, nil)
        == SQLITE_OK) {
        while (sqlite3_step(statementForStoreName) == SQLITE_ROW) {
            char * storeTitleChar = (char *)sqlite3_column_text(statementForStoreName, 0);
            char * storeLogoURL = (char *)sqlite3_column_text(statementForStoreName, 1);
            
            UIImage * storeLogo = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithUTF8String:storeLogoURL]]]];
            
            NSString * storeTitle = [[NSString alloc] initWithUTF8String:storeTitleChar];
            
            double latitude = 0;
            double longitude = 0;
            NSString *queryForStoreCoordinates = [NSString stringWithFormat:@"SELECT latitude, longitude FROM StoreCoordinate WHERE store_id=%i", itemStoreId];
            sqlite3_stmt *statementForStoreCoordinates;
            if (sqlite3_prepare_v2(dataBase, [queryForStoreCoordinates UTF8String], -1, &statementForStoreCoordinates, nil)
                == SQLITE_OK) {
                while (sqlite3_step(statementForStoreCoordinates) == SQLITE_ROW) {
                    latitude = (double) sqlite3_column_double(statementForStoreCoordinates, 0);
                    longitude = (double) sqlite3_column_double(statementForStoreCoordinates, 1);
                }
            }
            
            if (latitude != 0 & longitude != 0) {
                itemStore = [[MMDStore alloc] initWithId:[NSString stringWithFormat:@"%i", itemStoreId] title:storeTitle description:@"" logo:storeLogo latitude:latitude longitude:longitude];
            }
        }
        
    }
    sqlite3_finalize(statementForStoreName);
    return itemStore;
}

- (void)getColourDetails:(int)itemId itemColors:(NSMutableArray *)itemColors {
    NSString *queryForColorName = [NSString stringWithFormat:@"SELECT color_id FROM ProductColor WHERE product_id=%i", itemId];
    sqlite3_stmt *statementForColorName;
    if (sqlite3_prepare_v2(dataBase, [queryForColorName UTF8String], -1, &statementForColorName, nil)
        == SQLITE_OK) {
        while (sqlite3_step(statementForColorName) == SQLITE_ROW) {
            
            int colorId = (int) sqlite3_column_int(statementForColorName, 0);
            NSString * itemColor = @"";
            
            NSString *queryForSpecificColorName = [NSString stringWithFormat:@"SELECT name FROM Color WHERE id=%i", colorId];
            sqlite3_stmt *statementForSpecificColorName;
            if (sqlite3_prepare_v2(dataBase, [queryForSpecificColorName UTF8String], -1, &statementForSpecificColorName, nil)
                == SQLITE_OK) {
                while (sqlite3_step(statementForSpecificColorName) == SQLITE_ROW) {
                    char * itemColorChar = (char *)sqlite3_column_text(statementForSpecificColorName, 0);
                    itemColor = [[NSString alloc] initWithUTF8String:itemColorChar];
                }
            }
            sqlite3_finalize(statementForSpecificColorName);
            
            [itemColors addObject:itemColor];
        }
    }
    sqlite3_finalize(statementForColorName);
}

- (void)loadSizeDetails:(int)itemId itemSizes:(NSMutableArray *)itemSizes {
    NSString *queryForSizeName = [NSString stringWithFormat:@"SELECT size_id FROM ProductSize WHERE product_id=%i", itemId];
    sqlite3_stmt *statementForSizeName;
    if (sqlite3_prepare_v2(dataBase, [queryForSizeName UTF8String], -1, &statementForSizeName, nil)
        == SQLITE_OK) {
        while (sqlite3_step(statementForSizeName) == SQLITE_ROW) {
            
            int sizeId = (int) sqlite3_column_int(statementForSizeName, 0);
            NSString * itemSize = @"";
            
            NSString *queryForSpecificSizeName = [NSString stringWithFormat:@"SELECT value FROM Size WHERE id=%i", sizeId];
            sqlite3_stmt *statementForSpecificSizeName;
            if (sqlite3_prepare_v2(dataBase, [queryForSpecificSizeName UTF8String], -1, &statementForSpecificSizeName, nil)
                == SQLITE_OK) {
                while (sqlite3_step(statementForSpecificSizeName) == SQLITE_ROW) {
                    char * itemSizeChar = (char *)sqlite3_column_text(statementForSpecificSizeName, 0);
                    itemSize = [[NSString alloc] initWithUTF8String:itemSizeChar];
                }
            }
            sqlite3_finalize(statementForSpecificSizeName);
            
            [itemSizes addObject:itemSize];
        }
    }
    sqlite3_finalize(statementForSizeName);
}

- (MMDBrand *)loadBrandDetails:(int)itemBrandId {
    MMDBrand *itemBrand;
    NSString *queryForBrandName = [NSString stringWithFormat:@"SELECT name FROM Brand WHERE id=%i", itemBrandId];
    sqlite3_stmt *statementForBrandName;
    if (sqlite3_prepare_v2(dataBase, [queryForBrandName UTF8String], -1, &statementForBrandName, nil)
        == SQLITE_OK) {
        while (sqlite3_step(statementForBrandName) == SQLITE_ROW) {
            char * brandTitleChar = (char *)sqlite3_column_text(statementForBrandName, 0);
            NSString * brandTitle = [[NSString alloc] initWithUTF8String:brandTitleChar];
            
            itemBrand = [[MMDBrand alloc] initWithId:[NSString stringWithFormat:@"%i", itemBrandId] title:brandTitle image:nil];
        }
    }
    sqlite3_finalize(statementForBrandName);
    return itemBrand;
}

- (NSString *)loadCategoryDetails:(int)itemCategoryId {
    NSString *itemCategory=@"";
    NSString *queryForCategoryName = [NSString stringWithFormat:@"SELECT name FROM Category WHERE id=%i", itemCategoryId];
    sqlite3_stmt *statementForCategoryName;
    if (sqlite3_prepare_v2(dataBase, [queryForCategoryName UTF8String], -1, &statementForCategoryName, nil)
        == SQLITE_OK) {
        while (sqlite3_step(statementForCategoryName) == SQLITE_ROW) {
            char * itemCategoryChar = (char *)sqlite3_column_text(statementForCategoryName, 0);
            itemCategory = [[NSString alloc] initWithUTF8String:itemCategoryChar];
        }
    }
    sqlite3_finalize(statementForCategoryName);
    return itemCategory;
}

-(NSString *) randomStringWithLength: (int) len {
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
    }
    
    return randomString;
}

- (NSString *)manipulateImage:(int)itemId {
    UIImage *itemImage;
    
    itemImage = [self loadProductImage:itemId];
    
    NSString *imagePath = [self saveImageGetPath:itemImage];
    
    [self updateDatabaseWithImagepath:itemId :imagePath];
    
    return imagePath;
}

- (void) updateDatabaseWithImagepath:(int)itemId : (NSString *) imagePath {
    char *filePath=[imagePath UTF8String];
    sqlite3_stmt *updateStmt;
    const char *sql = "update ProductImage Set url = ? Where ID = ?";
    
    if(sqlite3_prepare_v2(dataBase, sql, -1, &updateStmt, NULL) != SQLITE_OK)
            NSLog(@"Error while creating update statement. %s", sqlite3_errmsg(dataBase));
    
    sqlite3_bind_text(updateStmt, 1, filePath, -1, SQLITE_STATIC);
    
    char* errmsg;
    sqlite3_exec(dataBase, "COMMIT", NULL, NULL, &errmsg);
    
    if(SQLITE_DONE != sqlite3_step(updateStmt))
        NSLog(@"Error while updating. %s", sqlite3_errmsg(dataBase));
    sqlite3_finalize(updateStmt);
}

- (UIImage *)loadProductImage:(int)itemId {
    UIImage *itemImage;
    NSString *queryForItemImage = [NSString stringWithFormat:@"SELECT url FROM ProductImage WHERE product_id=%i", itemId];
    sqlite3_stmt *statementForItemImage;
    if (sqlite3_prepare_v2(dataBase, [queryForItemImage UTF8String], -1, &statementForItemImage, nil)
        == SQLITE_OK) {
        while (sqlite3_step(statementForItemImage) == SQLITE_ROW) {
            char * itemImageURL = (char *)sqlite3_column_text(statementForItemImage, 0);
            
            NSString *urlString = [NSString stringWithUTF8String: itemImageURL];
           
            if ([urlString rangeOfString:@"http"].location == NSNotFound) {
                    itemImage = [UIImage imageWithContentsOfFile:urlString];
            } else {
                itemImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithUTF8String:itemImageURL]]]];
            }
            
        }
    }
    
    return itemImage;
}

- (NSString *)saveImageGetPath:(UIImage *)finalImage {
    NSData *imageData = UIImagePNGRepresentation(finalImage);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *imagePath =[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",[self randomStringWithLength:10]]];
    
    NSLog((@"pre writing to file"));
    if (![imageData writeToFile:imagePath atomically:NO])
    {
        NSLog((@"Failed to cache image data to disk"));
    }
    else
    {
        NSLog((@"the cached image path is %@",imagePath));
    }
    return imagePath;
}

- (NSMutableArray *)getItems {
    NSMutableArray * retval = [[NSMutableArray alloc] init];
    NSString *queryForItems = @"SELECT * FROM Product";
    sqlite3_stmt *statementForItems;
    if (sqlite3_prepare_v2(dataBase, [queryForItems UTF8String], -1, &statementForItems, nil)
        == SQLITE_OK) {
        while (sqlite3_step(statementForItems) == SQLITE_ROW) {
            
            NSString *itemTitle = @"";
            NSString *itemDescription = @"";
            NSString *itemCategory = @"";
            NSString *itemSKU = @"";
            NSMutableArray *itemColors = [[NSMutableArray alloc] init];
            NSMutableArray *itemSizes = [[NSMutableArray alloc] init];
            MMDBrand * itemBrand;
            MMDStore* itemStore;
            
            int itemId = (int) sqlite3_column_int(statementForItems, 0);
            char *itemURLChar = (char*)sqlite3_column_text(statementForItems, 1);
            
            char *itemTitleChar = (char *)sqlite3_column_text(statementForItems, 2);
            itemTitle = [[NSString alloc] initWithUTF8String:itemTitleChar];
            
            char *itemDescriptionChar = (char *) sqlite3_column_text(statementForItems, 3);
            itemDescription = [[NSString alloc] initWithUTF8String:itemDescriptionChar];
            
            char *itemSKUChar = (char *) sqlite3_column_text(statementForItems, 4);
            itemSKU = [[NSString alloc] initWithUTF8String:itemSKUChar];
            
            float itemPrice = (float) sqlite3_column_double(statementForItems, 5);
            int itemGender = (int) sqlite3_column_int(statementForItems, 6);
            int itemBrandId = (int) sqlite3_column_int(statementForItems, 7);
            int itemStoreId = (int) sqlite3_column_int(statementForItems, 8);
            int itemCategoryId = (int) sqlite3_column_int(statementForItems, 9);
            
            int itemLiked = (int)sqlite3_column_int(statementForItems, 10);
            
            int itemHasOffer = (int)sqlite3_column_int(statementForItems, 11);
            
            if (itemStoreId != 5 && itemStoreId != 6 && itemStoreId != 1) {
                itemBrand = [self loadBrandDetails:itemBrandId];
                
                
                itemCategory = [self loadCategoryDetails:itemCategoryId];
                
                itemStore = [self getStoreDetails:itemStoreId];
                
                [self getColourDetails:itemId itemColors:itemColors];
                
                [self loadSizeDetails:itemId itemSizes:itemSizes];
                
                NSString *imagePath = [self manipulateImage:itemId];
                
#warning add offers
                
                MMDItem * item = [[MMDItem alloc] initWithImagePath:[NSString stringWithFormat:@"%i", itemId] title:itemTitle description:itemDescription imagePath:imagePath SKU:itemSKU collection:@"" category:itemCategory price:itemPrice store:itemStore brand:itemBrand gender:itemGender color:itemColors size:itemSizes];
                
                [retval addObject:item];
            }
        }
        sqlite3_finalize(statementForItems);
    }
    
    return retval;
}

- (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (NSMutableArray*)getOffers {
    NSMutableArray * retval = [[NSMutableArray alloc] init];
    NSString *queryForOffers = @"SELECT * FROM Offer";
    sqlite3_stmt *statementForOffers;
    if (sqlite3_prepare_v2(dataBase, [queryForOffers UTF8String], -1, &statementForOffers, nil)
        == SQLITE_OK) {
        while (sqlite3_step(statementForOffers) == SQLITE_ROW) {
            
            
            
        }
    }
    return retval;
}

@end
