//
//  ViewController.m
//  Mussels
//
//  Copyright (C) 2015 Xiao Yao. All Rights Reserved.
//  See LICENSE.txt for more information.
//

#import "ViewController.h"
#import "TBA+StoreKit.h"

#pragma mark - ViewController

@interface ViewController ()

@end

@implementation ViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"IAP" ofType:@"plist"];
    NSArray *identifiers = [NSArray arrayWithContentsOfFile:filePath];
        
    [[TBAStoreManager sharedInstance] fetchProductsWithIdentifiers:[NSSet setWithArray:identifiers]];
    
    TBAProductsViewController *productsVC = [[TBAProductsViewController alloc] initWithProductIdentifiers:identifiers];
    self = [super initWithRootViewController:productsVC];
    if (self) {
        
    }
    return self;
}

@end
