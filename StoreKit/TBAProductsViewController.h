//
//  TBAProductsViewController.h
//  Mussels
//
//  Copyright (C) 2015 Xiao Yao. All Rights Reserved.
//  See LICENSE.txt for more information.
//

@import StoreKit;
@import UIKit;

#pragma mark - TBAProductsViewController

/**
 *  Displays a list of products.
 */
@interface TBAProductsViewController : UITableViewController

/**
 *  The designated initializer.
 *
 *  @param productIDs The product identifiers. The order of these IDs will dictate the order the products are displayed in the table view.
 *
 *  @return TBAProductsViewController or nil.
 */
- (instancetype)initWithProductIdentifiers:(NSArray *)productIDs;

@end
