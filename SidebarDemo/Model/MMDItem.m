//
//  MMDItem.m
//  MaiaMall Demo
//
//  Created by Illya Bakurov on 3/19/15.
//  Copyright (c) 2015 MaiaMall. All rights reserved.
//

#import "MMDItem.h"

@interface MMDItem() <NSCoding>

@property (strong, nonatomic, readwrite) NSString * itemId;
@property (strong, nonatomic, readwrite) NSString * itemTitle;
@property (strong, nonatomic, readwrite) NSString * itemDescription;
@property (strong, nonatomic, readwrite) UIImage * itemImage;
@property (nonatomic, readwrite) BOOL hasDefaultImage;
@property (strong, nonatomic, readwrite) NSString * itemSKU;
@property (strong, nonatomic, readwrite) NSString * itemCollection;
@property (strong, nonatomic, readwrite) NSString * itemCategory;
@property (strong, nonatomic, readwrite) NSMutableArray * itemColors;
@property (strong, nonatomic, readwrite) NSMutableArray * itemSizes;
@property (strong, nonatomic, readwrite) MMDStore * itemStore;
@property (strong, nonatomic, readwrite) MMDBrand* itemBrand;
@property (nonatomic, readwrite) float itemPrice;
@property (nonatomic, readwrite) BOOL itemIsInWishList;
@property (nonatomic, readwrite) kGender itemGender;
@property (nonatomic, readwrite) int itemNumberInCart;
@property (strong, nonatomic, readwrite) NSMutableArray * itemOffers; //array of MMDOffers

@end

@implementation MMDItem

@synthesize itemIsInWishList = _itemIsInWishList;

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.itemId forKey:kItemId];
    [aCoder encodeObject:self.itemTitle forKey:kItemTitle];
    [aCoder encodeObject:self.itemDescription forKey:kItemDescription];
    NSData* imageData = UIImageJPEGRepresentation(self.itemImage, 1.0);
    [aCoder encodeObject:imageData forKey:kItemImage];
    [aCoder encodeObject:self.itemImagePath forKey:kItemImagePath];
    [aCoder encodeObject:self.itemSKU forKey:kItemSKU];
    [aCoder encodeObject:self.itemCollection forKey:kItemCollection];
    [aCoder encodeObject:self.itemCategory forKey:kItemCategory];
    [aCoder encodeObject:self.itemStore forKey:kItemStore];
    [aCoder encodeFloat:self.itemPrice forKey:kItemPrice];
    [aCoder encodeObject:self.itemBrand forKey:kItemBrand];
    [aCoder encodeBool:self.itemIsInWishList forKey:kItemIsInWishList];
    [aCoder encodeInt:self.itemGender forKey:kItemGender];
    [aCoder encodeObject:self.itemColors forKey:kItemColors];
    [aCoder encodeObject:self.itemSizes forKey:kItemSizes];
    [aCoder encodeInt:self.itemNumberInCart forKey:kItemNumberInCart];
    [aCoder encodeObject:self.itemOffers forKey:kItemOffers];
    
    [aCoder encodeBool:self.hasDefaultImage forKey:kItemHasDefaultImage];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self.itemId = [aDecoder decodeObjectForKey:kItemId];
    self.itemTitle = [aDecoder decodeObjectForKey:kItemTitle];
    self.itemDescription = [aDecoder decodeObjectForKey:kItemDescription];
    NSData* myEncodedImageData = [aDecoder decodeObjectForKey:kItemImage];
    self.itemImage = [[UIImage alloc] initWithData:myEncodedImageData];
    self.itemImagePath = [aDecoder decodeObjectForKey:kItemImagePath];
    self.itemSKU = [aDecoder decodeObjectForKey:kItemSKU];
    self.itemCollection = [aDecoder decodeObjectForKey:kItemCollection];
    self.itemCategory = [aDecoder decodeObjectForKey:kItemCategory];
    self.itemStore = [aDecoder decodeObjectForKey:kItemStore];
    self.itemPrice = [aDecoder decodeFloatForKey:kItemPrice];
    self.itemBrand = [aDecoder decodeObjectForKey:kItemBrand];
    self.itemIsInWishList = [aDecoder decodeBoolForKey:kItemIsInWishList];
    self.itemGender = [aDecoder decodeIntForKey:kItemGender];
    
    if ([aDecoder decodeObjectForKey:kItemColors]) {
        self.itemColors = [[NSMutableArray alloc] initWithArray:[aDecoder decodeObjectForKey:kItemColors]];
    } else {
        self.itemColors = [[NSMutableArray alloc] init];
    }
    
    if ([aDecoder decodeObjectForKey:kItemSizes]) {
        self.itemSizes = [[NSMutableArray alloc] initWithArray:[aDecoder decodeObjectForKey:kItemSizes]];
    } else {
        self.itemSizes = [[NSMutableArray alloc] init];
    }
    
    self.itemNumberInCart = [aDecoder decodeIntForKey:kItemNumberInCart];
    
    if ([aDecoder decodeObjectForKey:kItemOffers]) {
        self.itemOffers = [[NSMutableArray alloc] initWithArray:[aDecoder decodeObjectForKey:kItemOffers]];
    } else {
        self.itemOffers = [[NSMutableArray alloc] init];
    }
    
    self.hasDefaultImage = [aDecoder decodeBoolForKey:kItemHasDefaultImage];
    
    return self;
}

- (instancetype)initWithId:(NSString*)itemId title:(NSString*)itemTitle description:(NSString*)itemDescription image:(UIImage*)itemImage SKU:(NSString*)itemSKU collection:(NSString*)itemCollection category:(NSString*)itemCategory price:(float)itemPrice store:(MMDStore*)itemStore brand:(MMDBrand *)itemBrand gender:(kGender)itemGender color:(NSMutableArray *)itemColors size:(NSMutableArray *)itemSizes {
    
    self.itemId = itemId;
    self.itemTitle = itemTitle;
    self.itemDescription = itemDescription;
    if (itemImage == nil) {
        self.itemImage = [UIImage imageNamed:@"product"];
        self.hasDefaultImage = YES;
    } else {
        self.itemImage = itemImage;
        self.hasDefaultImage = NO;
    }
    self.itemSKU = itemSKU;
    self.itemCollection = itemCollection;
    self.itemCategory = itemCategory;
    self.itemPrice = itemPrice;
    self.itemStore = itemStore;
    self.itemBrand = itemBrand;
    self.itemIsInWishList = NO;
    self.itemGender = itemGender;
    self.itemColors = [[NSMutableArray alloc] initWithArray:[itemColors copy]];;
    self.itemSizes = [[NSMutableArray alloc] initWithArray:[itemSizes copy]];;
    self.itemNumberInCart = 0;
    self.itemOffers = [[NSMutableArray alloc] init];
    
    return self;
    
}

- (instancetype)initWithImagePath:(NSString*)itemId title:(NSString*)itemTitle description:(NSString*)itemDescription imagePath:(NSString*)itemImagePath SKU:(NSString*)itemSKU collection:(NSString*)itemCollection category:(NSString*)itemCategory price:(float)itemPrice store:(MMDStore*)itemStore brand:(MMDBrand *)itemBrand gender:(kGender)itemGender color:(NSMutableArray *)itemColors size:(NSMutableArray *)itemSizes {
    
    self.itemId = itemId;
    self.itemTitle = itemTitle;
    self.itemDescription = itemDescription;
    self.itemImagePath = itemImagePath;
    self.itemSKU = itemSKU;
    self.itemCollection = itemCollection;
    self.itemCategory = itemCategory;
    self.itemPrice = itemPrice;
    self.itemStore = itemStore;
    self.itemBrand = itemBrand;
    self.itemIsInWishList = NO;
    self.itemGender = itemGender;
    self.itemColors = [[NSMutableArray alloc] initWithArray:[itemColors copy]];;
    self.itemSizes = [[NSMutableArray alloc] initWithArray:[itemSizes copy]];;
    self.itemNumberInCart = 0;
    self.itemOffers = [[NSMutableArray alloc] init];
    
    return self;
    
}

- (instancetype)initWithItem:(MMDItem*)item {
    self.itemId = item.itemId;
    self.itemTitle = item.itemTitle;
    self.itemDescription = item.itemDescription;
    self.itemImage = item.itemImage;
    self.hasDefaultImage = item.hasDefaultImage;
    self.itemSKU = item.itemSKU;
    self.itemCollection = item.itemCollection;
    self.itemCategory = item.itemCategory;
    self.itemPrice = item.itemPrice;
    self.itemStore = item.itemStore;
    self.itemBrand = item.itemBrand;
    self.itemIsInWishList = item.itemIsInWishList;
    self.itemGender = item.itemGender;
    self.itemImagePath = item.itemImagePath;
    self.itemColors = [[NSMutableArray alloc] initWithArray:[item.itemColors copy]];
    self.itemSizes = [[NSMutableArray alloc] initWithArray:[item.itemSizes copy]];
    self.itemNumberInCart = item.itemNumberInCart;
    self.itemOffers = [[NSMutableArray alloc] initWithArray:[item.itemOffers copy]];
    
    return self;
}

- (void)setItemIsInWishList:(BOOL)isInWishList {
    _itemIsInWishList = isInWishList;
}

- (void)addOffer:(MMDOffer*)offer {
    [self.itemOffers addObject:offer];
}


- (void)removeOffer:(MMDOffer*)offer {
    [self.itemOffers removeObject:offer];
}

- (void)addItemToCart {
    if (self.itemNumberInCart == 0 && ![[[MMDCart cart] arrayWithItemsToPurchase] containsObject:self]) {
        [[[MMDCart cart] arrayWithItemsToPurchase] addObject:self];
    }
    self.itemNumberInCart++;
    [[MMDCart cart] saveCartIntoDefaults];
}

- (void)decrementItemFromCart {
    if (self.itemNumberInCart > 0) {
        self.itemNumberInCart--;
    }
    [[MMDCart cart] saveCartIntoDefaults];
}

- (void)annulateItemInCart {
    self.itemNumberInCart = 0;
    [[MMDCart cart] saveCartIntoDefaults];
}

- (void)removeItemFromCart {
    self.itemNumberInCart = 0;
    [[[MMDCart cart] arrayWithItemsToPurchase] removeObject:self];
    [[MMDCart cart] saveCartIntoDefaults];
}

@end
