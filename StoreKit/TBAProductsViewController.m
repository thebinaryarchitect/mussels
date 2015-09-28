//
//  TBAProductsViewController.m
//  Mussels
//
//  Copyright (C) 2015 Xiao Yao. All Rights Reserved.
//  See LICENSE.txt for more information.
//

#import "TBAProductsViewController.h"
#import "TBAProductCell.h"
#import "TBAStoreManager.h"

#pragma mark - TBAProductsViewController

@interface TBAProductsViewController()
@property (nonatomic, strong, readwrite) NSArray *productIdentifiers;
@end

@implementation TBAProductsViewController

#pragma mark Lifecycle

- (instancetype)initWithProductIdentifiers:(NSArray *)productIDs {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        _productIdentifiers = productIDs;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[TBAProductCell class] forCellReuseIdentifier:NSStringFromClass([TBAProductCell class])];
}

#pragma mark Private

- (void)setProductIdentifiers:(NSArray *)productIdentifiers {
    if (_productIdentifiers != productIdentifiers) {
        _productIdentifiers = productIdentifiers;
        [self.tableView reloadData];
    }
}

- (SKProduct *)productAtIndexPath:(NSIndexPath *)indexPath {
    NSString *productID = self.productIdentifiers[indexPath.row];
    SKProduct *product = [TBAStoreManager sharedInstance].availableProducts[productID];
    return product;
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.productIdentifiers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TBAProductCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TBAProductCell class]) forIndexPath:indexPath];
    
    SKProduct *product = [self productAtIndexPath:indexPath];
    if (product) {
        cell.textLabel.text = product.localizedTitle;
        cell.detailTextLabel.text = product.localizedDescription;
    }
    
    return cell;
}

@end
