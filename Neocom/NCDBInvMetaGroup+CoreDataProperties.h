//
//  NCDBInvMetaGroup+CoreDataProperties.h
//  Neocom
//
//  Created by Artem Shimanski on 16.02.16.
//  Copyright © 2016 Shimanski Artem. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "NCDBInvMetaGroup.h"

NS_ASSUME_NONNULL_BEGIN

@interface NCDBInvMetaGroup (CoreDataProperties)

@property (nonatomic) int32_t metaGroupID;
@property (nullable, nonatomic, retain) NSString *metaGroupName;
@property (nullable, nonatomic, retain) NCDBEveIcon *icon;
@property (nullable, nonatomic, retain) NSSet<NCDBInvType *> *types;

@end

@interface NCDBInvMetaGroup (CoreDataGeneratedAccessors)

- (void)addTypesObject:(NCDBInvType *)value;
- (void)removeTypesObject:(NCDBInvType *)value;
- (void)addTypes:(NSSet<NCDBInvType *> *)values;
- (void)removeTypes:(NSSet<NCDBInvType *> *)values;

@end

NS_ASSUME_NONNULL_END
