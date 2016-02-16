//
//  NCDBDgmAttributeCategory+CoreDataProperties.h
//  Neocom
//
//  Created by Artem Shimanski on 16.02.16.
//  Copyright © 2016 Shimanski Artem. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "NCDBDgmAttributeCategory.h"

NS_ASSUME_NONNULL_BEGIN

@interface NCDBDgmAttributeCategory (CoreDataProperties)

@property (nonatomic) int32_t categoryID;
@property (nullable, nonatomic, retain) NSString *categoryName;
@property (nullable, nonatomic, retain) NSSet<NCDBDgmAttributeType *> *attributeTypes;

@end

@interface NCDBDgmAttributeCategory (CoreDataGeneratedAccessors)

- (void)addAttributeTypesObject:(NCDBDgmAttributeType *)value;
- (void)removeAttributeTypesObject:(NCDBDgmAttributeType *)value;
- (void)addAttributeTypes:(NSSet<NCDBDgmAttributeType *> *)values;
- (void)removeAttributeTypes:(NSSet<NCDBDgmAttributeType *> *)values;

@end

NS_ASSUME_NONNULL_END
