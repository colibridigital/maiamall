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
#import "FMDB.h"

@implementation MMDDataBase

static MMDDataBase *dataBase;
AppDelegate* appDel;

+(id)database {
    appDel = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    static dispatch_once_t onceToken;
    static MMDDataBase *shared_instance = nil;
    dispatch_once(&onceToken, ^{
        
            shared_instance = [[MMDDataBase alloc] init];
            [shared_instance initDatabase];
        
    });

    return shared_instance;
}

/*- (void)encodeWithCoder:(NSCoder *)aCoder {
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
}*/

- (id)init {
    if ((self = [super init])) {
        NSString *sqLiteDb = [appDel getDBPath];
        
        dataBase = [FMDatabase databaseWithPath:sqLiteDb];
    }
    return self;
}

- (void)closeDataBase {
    [dataBase close];
}

- (void)initDatabase {
    
    [dataBase open];
    
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:kDataBaseWasInitiated]) {
    
    self.arrayWithItems = [[NSMutableArray alloc] initWithArray:[self getItems]];
    self.arrayWithOffers = [[NSMutableArray alloc] initWithArray:[self getOffers]];
        
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.arrayWithItems];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kItemsInDataBase];
        
        
    NSData *data2 = [NSKeyedArchiver archivedDataWithRootObject:self.arrayWithOffers];
    [[NSUserDefaults standardUserDefaults] setObject:data2 forKey:kOffersInDataBase];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kDataBaseWasInitiated];
    [[NSUserDefaults standardUserDefaults] synchronize];
        
    } else {
        
        NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
        NSData *dataRepresentingSavedArray = [currentDefaults objectForKey:kItemsInDataBase];
        if (dataRepresentingSavedArray != nil)
        {
            NSArray *oldSavedArray = [NSKeyedUnarchiver unarchiveObjectWithData:dataRepresentingSavedArray];
            if (oldSavedArray != nil)
                self.arrayWithItems = [[NSMutableArray alloc] initWithArray:oldSavedArray];
            else
                self.arrayWithItems = [[NSMutableArray alloc] init];
        }
        
        NSData *dataRepresentingSavedArray2 = [currentDefaults objectForKey:kOffersInDataBase];
        if (dataRepresentingSavedArray2 != nil)
        {
            NSArray *oldSavedArray2 = [NSKeyedUnarchiver unarchiveObjectWithData:dataRepresentingSavedArray2];
            if (oldSavedArray2 != nil)
                self.arrayWithOffers = [[NSMutableArray alloc] initWithArray:oldSavedArray2];
            else
                self.arrayWithOffers = [[NSMutableArray alloc] init];
        }
    }
    [self closeDataBase];
}

- (MMDStore *)getStoreDetails:(int)itemStoreId {
    MMDStore *itemStore;
    
   // if (![dataBase open])
     //   [dataBase open];

    
    FMResultSet *rs = [dataBase executeQuery:@"SELECT longName, logourl FROM Store WHERE id=?", [NSNumber numberWithInt:itemStoreId], nil];
    FMResultSet *rs2;
    [self sanitiseResultSet:rs];
    
    while ([rs next]) {
        
        UIImage * storeLogo = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[rs stringForColumn:@"logoURL"]]]];
        
        NSString * storeTitle = [[NSString alloc] initWithString:[rs stringForColumn:@"longName"]];
        
        double latitude = 0;
        double longitude = 0;
        
        rs2 = [dataBase executeQuery:@"SELECT latitude, longitude FROM StoreCoordinate WHERE store_id=?", [NSNumber numberWithInt:itemStoreId], nil];
        
        while ([rs2 next]) {
            latitude = [rs2 doubleForColumn:@"latitude"];
            longitude = [rs2 doubleForColumn:@"longitude"];
            
            if (latitude != 0 & longitude != 0) {
                itemStore = [[MMDStore alloc] initWithId:[NSString stringWithFormat:@"%i", itemStoreId] title:storeTitle description:@"" logo:storeLogo latitude:latitude longitude:longitude];
            }
        }
        
        [rs2 close];
    }
    
    [rs close];
    //[self closeDataBase];
    
    return itemStore;
}

- (void)getColourDetails:(int)itemId itemColors:(NSMutableArray *)itemColors {
   // if (![dataBase open])
   //     [dataBase open];
    
    FMResultSet *rs = [dataBase executeQuery:@"select name from color where id = (select color_id from productColor where product_id = ?)", [NSNumber numberWithInt:itemId], nil];
    [self sanitiseResultSet:rs];
    
    while ([rs next]) {
        [itemColors addObject: [rs stringForColumn:@"name"]];
    }
    
    [rs close];
    //[self closeDataBase];
}

- (void)loadSizeDetails:(int)itemId itemSizes:(NSMutableArray *)itemSizes {
    
  //  if (![dataBase open])
        //[dataBase open];
    
    FMResultSet *rs = [dataBase executeQuery:@"select value from SIZE where id = (select size_id from productSize where product_id = ?)", [NSNumber numberWithInt:itemId], nil];
    [self sanitiseResultSet:rs];
    
    while ([rs next]) {
        [itemSizes addObject: [rs stringForColumn:@"value"]];
    }
    
    [rs close];
   // [self closeDataBase];
}

- (MMDBrand *)loadBrandDetails:(int)itemBrandId {
    MMDBrand *itemBrand;
    NSString *brandTitle;
    
  //  if (![dataBase open])
        //[dataBase open];
    
    FMResultSet *rs = [dataBase executeQuery:@"SELECT name FROM Brand WHERE id=?", [NSNumber numberWithInt:itemBrandId], nil];
    [self sanitiseResultSet:rs];
    
    while ([rs next]) {
        brandTitle = [rs stringForColumn:@"name"];
    }
    
    itemBrand = [[MMDBrand alloc] initWithId:[NSString stringWithFormat:@"%i", itemBrandId] title:brandTitle image:nil];
    
    [rs close];
   // [self closeDataBase];
    
    return itemBrand;
}

- (NSString *)loadCategoryDetails:(int)itemCategoryId {
    NSString *itemCategory=@"";
    
   // if (![dataBase open])
    //    [dataBase open];

    
    FMResultSet *rs = [dataBase executeQuery:@"SELECT name FROM Category WHERE id=?", [NSNumber numberWithInt:itemCategoryId], nil];
    [self sanitiseResultSet:rs];
    
    while ([rs next]) {
        itemCategory = [rs stringForColumn:@"name"];
    }
    
    [rs close];
   // [self closeDataBase];
    
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
    NSString *imagePath;
    
    imagePath = [self loadProductImagePath:itemId];
    
    NSLog(@"\n");
    NSLog(@"Getting image for item id %i", itemId);
    NSLog(@"loading path: %@", imagePath);
    
    char *charPath=[imagePath UTF8String];
    
    if (([imagePath rangeOfString:@"http"].location == NSNotFound) && ([imagePath rangeOfString:@"asset1"].location == NSNotFound) && (([imagePath rangeOfString:@"ttp"].location == NSNotFound))) {
        return imagePath;
    } else {
        itemImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithUTF8String:charPath]]]];
        NSString *imagePath = [self saveImageGetPath:itemImage];
        [self updateDatabaseWithImagepath:itemId :(imagePath)];
        return imagePath;
    }
}

- (void) updateDatabaseWithImagepath:(int)itemId : (NSString *) imagePath {
    char *filePath=[imagePath UTF8String];
    
    //if (![dataBase open])
    //    [dataBase open];

    [dataBase beginTransaction];
    
    BOOL success = [dataBase executeUpdate:@"UPDATE ProductImage SET url= ? WHERE product_id = ?", [NSString stringWithFormat:@"%s", filePath], [NSNumber numberWithInt:itemId],nil];
    
    if(success) {
        NSLog(@"Updated image URL for item id %i", itemId);
        [dataBase commit];
    } else {
        NSLog(@"Error updating database with new image path for item id %i", itemId);
    }
}

- (void)sanitiseResultSet:(FMResultSet *)rs {
    if (!rs) {
        NSLog(@"%s: executeQuery failed: %@", __FUNCTION__, [dataBase lastErrorMessage]);
        return;
    }
}

- (NSString *)loadProductImagePath:(int)itemId {
    NSString *urlString;
    
  //  if (![dataBase open])
   //     [dataBase open];

    
    FMResultSet *rs = [dataBase executeQuery:@"SELECT url FROM ProductImage WHERE product_id= ? ", [NSNumber numberWithInt:itemId],nil];
    [self sanitiseResultSet:rs];
    
    while ([rs next]) {
        urlString = [rs stringForColumn:@"url"];
    }
    
    [rs close];
  //  [self closeDataBase];
    
    return urlString;
}

- (NSString *)saveImageGetPath:(UIImage *)finalImage {
    NSData *imageData = UIImagePNGRepresentation(finalImage);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *imagePath =[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",[self randomStringWithLength:10]]];
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



- (NSMutableArray *)getItemsFromDatabaseWithQuery:(NSString *)query {
    NSMutableArray *retval = [[NSMutableArray alloc] init];
    FMResultSet *rs = [dataBase executeQuery:query];
    [self sanitiseResultSet:rs];
    
    while ([rs next]) {
        NSString *itemTitle = @"";
        NSString *itemDescription = @"";
        NSString *itemCategory = @"";
        NSString *itemSKU = @"";
        NSMutableArray *itemColors = [[NSMutableArray alloc] init];
        NSMutableArray *itemSizes = [[NSMutableArray alloc] init];
        MMDBrand * itemBrand;
        MMDStore* itemStore;
        NSString *itemURLChar=@"";
        
        int itemId = [rs intForColumn:@"id"];
        itemURLChar = [[NSString alloc] initWithString:[rs stringForColumn:@"url"]];
        itemTitle = [[NSString alloc] initWithString:[rs stringForColumn:@"title"]];
        itemDescription = [[NSString alloc] initWithString:[rs stringForColumn:@"description"]];
        itemSKU = [[NSString alloc] initWithString:[rs stringForColumn:@"sku"]];
        
        float itemPrice = [[rs stringForColumn:@"price"] floatValue];
        int itemGender = [rs intForColumn:@"gender"];
        int itemBrandId = [rs intForColumn:@"brand_id"];
        int itemStoreId = [rs intForColumn:@"store_id"];
        int itemCategoryId = [rs intForColumn:@"category_id"];
        
        if(itemStoreId != 6 && itemStoreId != 1 && itemStoreId !=5 && itemStoreId !=8) //add here 5 for M&S
        {
            int itemLiked = [rs intForColumn:@"liked"];
            
            int itemHasOffer = [rs intForColumn:@"hasOffer"];
            
            itemBrand = [self loadBrandDetails:itemBrandId];
            
            itemCategory = [self loadCategoryDetails:itemCategoryId];
            
            itemStore = [self getStoreDetails:itemStoreId];
            
            [self getColourDetails:itemId itemColors:itemColors];
            
            [self loadSizeDetails:itemId itemSizes:itemSizes];
            
            NSString *imagePath = [self manipulateImage:itemId];
            
            if (imagePath != nil && ![imagePath isEqualToString:@"(null)"]) {
                
                MMDItem * item = [[MMDItem alloc] initWithImagePath:[NSString stringWithFormat:@"%i", itemId] title:itemTitle description:itemDescription imagePath:imagePath SKU:itemSKU collection:@"" category:itemCategory price:itemPrice store:itemStore brand:itemBrand gender:itemGender color:itemColors size:itemSizes];
                
                [retval addObject:item];
            }
        }
    }
    
    [rs close];
    return retval;
}

- (NSMutableArray *)getItems {
   // if (![dataBase open])
   //     [dataBase open];
    
    NSString *query = @"SELECT * FROM Product";
    
    NSMutableArray *retval;
    retval = [self getItemsFromDatabaseWithQuery:query];
   // [self closeDataBase];
    
    return retval;
}

- (NSMutableArray *)getSummerCollectionItems {
    [dataBase open];
    NSString *query = @"SELECT * FROM Product where id in (414, 420, 437, 450, 551)";
    
    NSMutableArray *retval;
    retval = [self getItemsFromDatabaseWithQuery:query];
     [self closeDataBase];
    
    return retval;
}
- (NSMutableArray *)getShoesCollection {
    [dataBase open];
    NSString *query = @"SELECT * FROM Product where id in (542, 548, 555, 561, 614, 615, 619)";
    
    NSMutableArray *retval;
    retval = [self getItemsFromDatabaseWithQuery:query];
     [self closeDataBase];
    
    return retval;
}
- (NSMutableArray *)getBagsCollection {
    [dataBase open];
    NSString *query = @"SELECT * FROM Product where id in (540, 538, 527, 524, 427, 424)";
    
    NSMutableArray *retval;
    retval = [self getItemsFromDatabaseWithQuery:query];
     [self closeDataBase];
    
    return retval;
}
- (NSMutableArray *)getShirtsCollection {
    [dataBase open];
    NSString *query = @"SELECT * FROM Product where id in (566, 567, 569)";
    
    NSMutableArray *retval;
    retval = [self getItemsFromDatabaseWithQuery:query];
     [self closeDataBase];
    
    return retval;
}
- (NSMutableArray *)getFormalCollection {
    [dataBase open];
    
    NSString *query = @"SELECT * FROM Product where id in (570, 595, 537, 547, 585)";
    
    NSMutableArray *retval;
    retval = [self getItemsFromDatabaseWithQuery:query];
     [self closeDataBase];
    
    return retval;
}
- (NSMutableArray *)getFavouriteCollection {
    
    [dataBase open];
    NSString *query = @"SELECT * FROM Product where id in (614, 570, 566, 540, 548, 567, 585, 619, 612, 550, 552, 568, 569, 581, 582, 591, 592, 593, 439, 437)";
    
    NSMutableArray *retval;
    retval = [self getItemsFromDatabaseWithQuery:query];
     [self closeDataBase];
    
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
    
  //  if (![dataBase open])
   //     [dataBase open];


    FMResultSet *rs = [dataBase executeQuery:@"SELECT * FROM Offer"];
    [self sanitiseResultSet:rs];
    
    while ([rs next]) {
        //[retval addObject:[rs stringForColumn:@"price"]];
    }
    
    [rs close];
   // [self closeDataBase];
    
    return retval;

 }

@end
