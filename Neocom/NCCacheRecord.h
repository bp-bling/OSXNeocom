//
//  NCCacheRecord.h
//  Neocom
//
//  Created by Artem Shimanski on 17.02.16.
//  Copyright © 2016 Shimanski Artem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NCCacheRecordData;

NS_ASSUME_NONNULL_BEGIN

@interface NCCacheRecord : NSManagedObject
@property (readonly, getter = isExpired) BOOL expired;

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "NCCacheRecord+CoreDataProperties.h"
