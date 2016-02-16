//
//  NCDBInvControlTower+CoreDataProperties.h
//  Neocom
//
//  Created by Artem Shimanski on 16.02.16.
//  Copyright © 2016 Shimanski Artem. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "NCDBInvControlTower.h"

NS_ASSUME_NONNULL_BEGIN

@interface NCDBInvControlTower (CoreDataProperties)

@property (nullable, nonatomic, retain) NSSet<NCDBInvControlTowerResource *> *resources;
@property (nullable, nonatomic, retain) NCDBInvType *type;

@end

@interface NCDBInvControlTower (CoreDataGeneratedAccessors)

- (void)addResourcesObject:(NCDBInvControlTowerResource *)value;
- (void)removeResourcesObject:(NCDBInvControlTowerResource *)value;
- (void)addResources:(NSSet<NCDBInvControlTowerResource *> *)values;
- (void)removeResources:(NSSet<NCDBInvControlTowerResource *> *)values;

@end

NS_ASSUME_NONNULL_END
