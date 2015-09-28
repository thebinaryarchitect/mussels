//
//  TBAStoreManager.m
//  Mussels
//
//  Copyright (C) 2015 Xiao Yao. All Rights Reserved.
//  See LICENSE.txt for more information.
//

#import "TBAStoreManager.h"

#pragma mark - TBAStoreManager

@interface TBAStoreManager() <SKRequestDelegate, SKProductsRequestDelegate>
@property (nonatomic, strong, readwrite) NSDictionary *availableProducts;
@property (nonatomic, strong, readwrite) NSArray *invalidProductIdentifiers;
@end

@implementation TBAStoreManager

+ (TBAStoreManager *)sharedInstance {
    static TBAStoreManager *_storeManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _storeManager = [[TBAStoreManager alloc] init];
    });
    return _storeManager;
}

#pragma mark Public

- (void)fetchProductsWithIdentifiers:(NSSet *)productIDs {
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:productIDs];
    request.delegate = self;
    [request start];
}

#pragma mark SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSMutableDictionary *products = [NSMutableDictionary dictionary];
    for (SKProduct *product in response.products) {
        products[product.productIdentifier] = product;
    }
    self.availableProducts = [NSDictionary dictionaryWithDictionary:products];
    self.invalidProductIdentifiers = response.invalidProductIdentifiers;
}

#pragma mark SKRequestDelegate

- (void)requestDidFinish:(SKRequest *)request {
    
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
}

@end
