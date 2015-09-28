//
//  TBAStoreManager.h
//  Mussels
//
//  Copyright (C) 2015 Xiao Yao. All Rights Reserved.
//  See LICENSE.txt for more information.
//

@import Foundation;

#pragma mark - TBAStoreManager

/**
 *  Manages interactions with StoreKit, such as loading, purchasing and restoring products.
 */
@interface TBAStoreManager : NSObject

/**
 *  The shared instance of the store manager.
 *
 *  @return The shared instance of the store manager.
 */
+ (TBAStoreManager *)sharedInstance;

@end
