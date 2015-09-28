//
//  TBAStoreManager.m
//  Mussels
//
//  Copyright (C) 2015 Xiao Yao. All Rights Reserved.
//  See LICENSE.txt for more information.
//

#import "TBAStoreManager.h"

#pragma mark - TBAStoreManager

@implementation TBAStoreManager

+ (TBAStoreManager *)sharedInstance {
    static TBAStoreManager *_storeManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _storeManager = [[TBAStoreManager alloc] init];
    });
    return _storeManager;
}

@end
