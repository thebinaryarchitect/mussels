//
//  TBAStoreManager.m
//  Mussels
//
//  Copyright (C) 2015 Xiao Yao. All Rights Reserved.
//  See LICENSE.txt for more information.
//

#import "TBAStoreManager.h"

#pragma mark - TBAStoreManager

@interface TBAStoreManager() <SKPaymentTransactionObserver, SKRequestDelegate, SKProductsRequestDelegate>
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

- (instancetype)init {
    self = [super init];
    if (self) {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}

- (void)dealloc {
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}

#pragma mark Public

- (void)fetchProductsWithIdentifiers:(NSSet *)productIDs {
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:productIDs];
    request.delegate = self;
    [request start];
}

- (void)purchaseProduct:(SKProduct *)product {
    SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)restoreProducts {
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

#pragma mark Private

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    if (transaction.downloads && transaction.downloads.count > 0) {
        // Handle downloads
    } else {
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    }
}

#pragma mark SKPaymentTransactionObserver

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing: {
                // Do nothing.
                break;
            }
                case SKPaymentTransactionStateDeferred:
                case SKPaymentTransactionStatePurchased:
            case SKPaymentTransactionStateRestored: {
                [self completeTransaction:transaction];
                break;
            }
            case SKPaymentTransactionStateFailed: {
                // Handle failure.
                break;
            }
            default:
                break;
        }
    }
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
