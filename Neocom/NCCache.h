//
//  NCCache.h
//  Neocom
//
//  Created by Artem Shimanski on 12.12.13.
//  Copyright (c) 2013 Artem Shimanski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NCCacheRecord.h"
#import "NCCachePrice.h"
#import "NSManagedObjectContext+NCCache.h"

#define NCCacheDefaultExpireTime (60 * 60)

@interface NCCache : NSObject
//@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

+ (instancetype) sharedCache;
- (void) clear;
- (void) clearInvalidData;

@end
