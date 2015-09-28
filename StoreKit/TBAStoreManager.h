//
//  TBAStoreManager.h
//  Mussels
//
//  Copyright (C) 2015 Xiao Yao. All Rights Reserved.
//  See LICENSE.txt for more information.
//

@import Foundation;
@import StoreKit;

#pragma mark - TBAStoreManager

/**
 *  Manages interactions with StoreKit, such as loading, purchasing and restoring products.
 */
@interface TBAStoreManager : NSObject

/**
 *  A dictionary of products. The product identifiers are used as the keys of the dictionary.
 */
@property (nonatomic, strong, readonly) NSDictionary *availableProducts;

/**
 *  The invalid product identifiers.
 */
@property (nonatomic, strong, readonly) NSArray *invalidProductIdentifiers;

/**
 *  The shared instance of the store manager.
 *
 *  @return The shared instance of the store manager.
 */
+ (TBAStoreManager *)sharedInstance;

/**
 *  Attempts to fetch the products associated with the product identifiers.
 *
 *  @param productIDs Set of strings representing the product identifiers.
 */
- (void)fetchProductsWithIdentifiers:(NSSet *)productIDs;

@end
