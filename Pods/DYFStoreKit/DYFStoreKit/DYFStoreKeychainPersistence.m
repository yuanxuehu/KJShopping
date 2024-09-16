//
//  DYFStoreKeychainPersistence.m
//
//  Created by dyf on 2014/11/4. ( https://github.com/dgynfi/DYFStoreKit )
//  Copyright © 2014 dyf. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "DYFStoreKeychainPersistence.h"
#import "DYFStoreConverter.h"
#import "DYFRuntimeProvider.h"
#import "DYFKeychain.h"

@interface DYFStoreKeychainPersistence ()
@property (nonatomic, strong) DYFKeychain *keychain;
@end

@implementation DYFStoreKeychainPersistence

/** Creates an instance of DYFKeychain using lazy load.
 */
- (DYFKeychain *)keychain {
    
    if (!_keychain) {
        _keychain = [DYFKeychain createKeychain];
    }
    
    return _keychain;
}

/** Loads an array whose elements are the `NSDictionary` objects from the keychain.
 
 @return An array whose elements are the `NSDictionary` objects.
 */
- (NSArray<NSDictionary *> *)loadDataFromKeychain {
    
    NSData *data = [self.keychain getData:DYFStoreTransactionsKey];
    
    NSArray *array = [DYFStoreConverter jsonObjectWithData:data];
    
    return array;
}

- (BOOL)containsTransaction:(NSString *)transactionIdentifier {
    
    NSArray *array = [self loadDataFromKeychain];
    if (!array) { return NO; }
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:array];
    for (int idx = 0; idx < arr.count; idx++) {
        
        NSDictionary *dict = arr[idx];
        
        DYFStoreTransaction *transaction = [DYFRuntimeProvider modelWithDictionary:dict forClass:DYFStoreTransaction.class];
        NSString *identifier = transaction.transactionIdentifier;
        
        if ([identifier isEqualToString:transactionIdentifier]) {
            return YES;
        }
    }
    
    return NO;
}

- (void)storeTransaction:(DYFStoreTransaction *)transaction {
    
    if (!transaction) { return; }
    
    NSMutableArray *transactions;
    
    NSArray *array = [self loadDataFromKeychain];
    if (!array) {
        transactions = [NSMutableArray arrayWithCapacity:0];
    } else {
        transactions = [NSMutableArray arrayWithArray:array];
    }
    
    NSDictionary *dict = [DYFRuntimeProvider dictionaryWithModel:transaction];
    [transactions addObject:dict];
    
    NSData *tData = [DYFStoreConverter jsonWithObject:transactions];
    [self.keychain addData:tData forKey:DYFStoreTransactionsKey];
}

- (NSArray<DYFStoreTransaction *> *)retrieveTransactions {
    
    NSArray *array = [self loadDataFromKeychain];
    if (!array) { return nil; }
    
    NSMutableArray *transactions = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        
        DYFStoreTransaction *transaction = [DYFRuntimeProvider modelWithDictionary:dict forClass:DYFStoreTransaction.class];
        if (transaction) {
            [transactions addObject:transaction];
        }
    }
    
    return transactions;
}

- (DYFStoreTransaction *)retrieveTransaction:(NSString *)transactionIdentifier {
    
    NSArray *array = [self retrieveTransactions];
    if (!array) { return nil; }
    
    for (DYFStoreTransaction *transaction in array) {
        
        NSString *identifier = transaction.transactionIdentifier;
        if ([identifier isEqualToString:transactionIdentifier]) {
            return transaction;
        }
    }
    
    return nil;
}

- (void)removeTransaction:(NSString *)transactionIdentifier {
    
    NSArray *array = [self loadDataFromKeychain];
    if (!array) { return; }
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:array];
    int index = -1;
    for (int idx = 0; idx < arr.count; idx++) {
        
        NSDictionary *dict = arr[idx];
        
        DYFStoreTransaction *transaction = [DYFRuntimeProvider modelWithDictionary:dict forClass:DYFStoreTransaction.class];
        NSString *identifier = transaction.transactionIdentifier;
        
        if ([identifier isEqualToString:transactionIdentifier]) {
            index = idx;
            break;
        }
    }
    
    if (index >= 0) {
        [arr removeObjectAtIndex:index];
        NSData *tData = [DYFStoreConverter jsonWithObject:arr];
        [self.keychain addData:tData forKey:DYFStoreTransactionsKey];
    }
}

- (void)removeTransactions {
    [self.keychain delete:DYFStoreTransactionsKey];
}

@end
