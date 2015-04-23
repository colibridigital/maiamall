//
//  DefineKeys.h
//  MaiaMall Demo
//
//  Created by Illya Bakurov on 3/19/15.
//  Copyright (c) 2015 MaiaMall. All rights reserved.
//

#ifndef MaiaMall_Demo_DefineKeys_h
#define MaiaMall_Demo_DefineKeys_h

//Google api key
#define kGoogleAPIKey @"AIzaSyD1l3mOBZRj1jBz23SPjLxtdvWbMC5tJPM"

//keys for MMDWishList
#define kWishListData @"wishListData"
#define kWishList @"wishList"

//keys for MMDItem
#define kItemId @"itemId"
#define kItemTitle @"itemTitle"
#define kItemDescription @"itemDescription"
#define kItemImage @"itemImage"
#define kItemImagePath @"itemImagePath"
#define kItemSKU @"itemSKU"
#define kItemCollection @"itemCollection"
#define kItemCategory @"itemCategory"
#define kItemStore @"itemStore"
#define kItemPrice @"itemPrice"
#define kItemIsInWishList @"itemIsInWishList"
#define kItemBrand @"itemBrand"
#define kItemGender @"itemGender"
#define kItemColors @"itemColors"
#define kItemSizes @"itemSizes"
#define kItemNumberInCart @"itemNumberInCart"
#define kItemOffers @"itemOffers"
#define kItemHasDefaultImage @"itemHasDefaultImage"

//keys for MMDStore
#define kStoreId @"storeId"
#define kStoreTitle @"storeTitle"
#define kStoreDescription @"storeDescription"
#define kStoreLogo @"storeLogo"
#define kStoreLatitude @"storeLatitude"
#define kStoreLongitude @"storeLongitude"

//keys for MMDOffer
#define kOfferId @"offerId"
#define kOfferTitle @"offerTitle"
#define kOfferDescription @"offerDescription"
#define kOfferItems @"offerItems"

//keys for MMDBrand
#define kBrandId @"brandId"
#define kBrandTitle @"brandTitle"
#define kBrandImage @"brandImage"

//keys for indexes for TabBar
#define kIndexForMain 0
#define kIndexForWishList 1

//switcher in menu
#define kFemaleOrMaleSwitch @"femaleOrMaleSwitch"
#define kWidthForRearView 200.0f //it is kind of random number, really should be calculated from the biggest width of the label in the menu.

//keys for MMDDataBase
#define kDataBaseWasInitiated @"dataBaseWasInitiated"
#define kDataBase @"dataBase"
#define kItemsInDataBase @"itemsInDataBase"
#define kOffersInDataBase @"offersInDataBase"

//keys for use in Search process
#define kStoreItems @"storeItems"
#define kItem @"item"

//keys for use in Cart
#define kCart @"cart"
#define kArrayWithItemsToPurchase @"arrayWithItemsToPurchase"

#endif
