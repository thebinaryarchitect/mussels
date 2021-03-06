//
//  TBAStoreManager.m
//  Mussels
//
//  Copyright (C) 2015 Xiao Yao. All Rights Reserved.
//  See LICENSE.txt for more information.
//

#import "TBAStoreManager.h"

#pragma mark - NSUserDefaults (TBAStoreManagerAdditions)

@interface NSUserDefaults (TBAStoreManagerAdditions)

- (NSString *)IAPKey;
- (NSSet *)purchasedProductIdentifiers;
- (void)setPurchasedProductIdentifiers:(NSSet *)identifiers;
- (void)addProductIdentifier:(NSString *)productID;
- (void)removeProductIdentifier:(NSString *)productID;

@end

@implementation NSUserDefaults (TBAStoreManagerAdditions)

- (NSString *)IAPKey {
    NSString *bundleID = [NSBundle mainBundle].bundleIdentifier;
    return [bundleID stringByAppendingPathComponent:@"iaps"];
}

- (NSSet *)purchasedProductIdentifiers {
    NSData *data = [self objectForKey:[self IAPKey]];
    if (data) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return nil;
}

- (void)setPurchasedProductIdentifiers:(NSSet *)identifiers {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:identifiers];
    [self setObject:data forKey:[self IAPKey]];
    [self synchronize];
}

- (void)addProductIdentifier:(NSString *)productID {
    NSMutableSet *productIDs = [NSMutableSet setWithSet:[self purchasedProductIdentifiers]];
    [productIDs addObject:productID];
    [self setPurchasedProductIdentifiers:productIDs];
}

- (void)removeProductIdentifier:(NSString *)productID {
    NSMutableSet *productIDs = [NSMutableSet setWithSet:[self purchasedProductIdentifiers]];
    [productIDs removeObject:productID];
    [self setPurchasedProductIdentifiers:productIDs];
}

@end

#pragma mark - TBAStoreManager

@interface TBAStoreManager() <SKPaymentTransactionObserver, SKRequestDelegate, SKProductsRequestDelegate>
@property (nonatomic, strong, readwrite) NSDictionary *availableProducts;
@property (nonatomic, strong, readwrite) NSArray *invalidProductIdentifiers;
@property (nonatomic, strong, readwrite) NSMutableSet *observers;
@property (nonatomic, strong, readwrite) NSNumberFormatter *numberFormatter;
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
        self.observers = [NSMutableSet set];
        
        self.numberFormatter = [[NSNumberFormatter alloc] init];
        self.numberFormatter.formatterBehavior = NSNumberFormatterBehavior10_4;
        self.numberFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
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

- (NSSet *)purchasedProductIdentifiers {
    return [[NSUserDefaults standardUserDefaults] purchasedProductIdentifiers];
}

- (BOOL)isProductAvailable:(NSString *)productID {
    return [[self purchasedProductIdentifiers] containsObject:productID];
}

- (void)addObserver:(id<TBAStoreManagerObserver>)observer {
    [self.observers addObject:observer];
}

- (void)removeObserver:(id)observer {
    [self.observers removeObject:observer];
}

- (NSString *)priceStringForProduct:(SKProduct *)product {
    self.numberFormatter.locale = product.priceLocale;
    return [self.numberFormatter stringFromNumber:product.price];
}

#pragma mark Private

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    NSString *productID = transaction.payment.productIdentifier;
    if (transaction.error.code != SKErrorPaymentCancelled) {
        for (id<TBAStoreManagerObserver> observer in self.observers) {
            if ([observer respondsToSelector:@selector(storeManager:didPurchaseProductWithIdentifier:)]) {
                [observer storeManager:self didPurchaseProductWithIdentifier:productID];
            }
        }
    }
    
    if (transaction.downloads && transaction.downloads.count > 0) {
        // Handle downloads
    } else {
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        [[NSUserDefaults standardUserDefaults] addProductIdentifier:productID];
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
    for (id<TBAStoreManagerObserver> observer in self.observers) {
        if ([observer respondsToSelector:@selector(storeManager:didFetchProducts:invalidProductIdentifiers:)]) {
            [observer storeManager:self didFetchProducts:self.availableProducts invalidProductIdentifiers:self.invalidProductIdentifiers];
        }
    }
}

#pragma mark SKRequestDelegate

- (void)requestDidFinish:(SKRequest *)request {
    
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
}

@end
