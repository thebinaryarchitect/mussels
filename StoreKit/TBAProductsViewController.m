//
//  TBAProductsViewController.m
//  Mussels
//
//  Copyright (C) 2015 Xiao Yao. All Rights Reserved.
//  See LICENSE.txt for more information.
//

#import "TBAProductsViewController.h"
#import "TBAProductCell.h"

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[TBAStoreManager sharedInstance] addObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[TBAStoreManager sharedInstance] removeObserver:self];
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

- (void)purchaseProduct:(UIButton *)button {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
    SKProduct *product = [self productAtIndexPath:indexPath];
    [[TBAStoreManager sharedInstance] purchaseProduct:product];
}

#pragma mark TBAStoreManagerObserver

- (void)storeManager:(TBAStoreManager *)storeManager didFetchProducts:(NSDictionary *)products invalidProductIdentifiers:(NSArray *)invalidProductIDs {
    [self.tableView reloadData];
}

- (void)storeManager:(TBAStoreManager *)storeManager didPurchaseProductWithIdentifier:(NSString *)productID {
    if ([self.productIdentifiers containsObject:productID]) {
        NSInteger index = [self.productIdentifiers indexOfObject:productID];
        NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[reloadIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
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
    
    cell.purchaseButton.tag = indexPath.row;
    [cell.purchaseButton addTarget:self action:@selector(purchaseProduct:) forControlEvents:UIControlEventValueChanged];
    
    SKProduct *product = [self productAtIndexPath:indexPath];
    if (product) {
        cell.textLabel.text = product.localizedTitle;
        cell.detailTextLabel.text = product.localizedDescription;
    }
    
    if ([[TBAStoreManager sharedInstance] isProductAvailable:product.productIdentifier]) {
        cell.accessoryView = nil;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell.purchaseButton setTitle:[[TBAStoreManager sharedInstance] priceStringForProduct:product] forState:UIControlStateNormal];
        cell.accessoryView = cell.purchaseButton;
    }
    
    return cell;
}

#pragma mark UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

@end
