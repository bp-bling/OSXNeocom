//
//  NCDBInvControlTowerResourcePurpose+CoreDataProperties.h
//  Neocom
//
//  Created by Artem Shimanski on 16.02.16.
//  Copyright © 2016 Shimanski Artem. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "NCDBInvControlTowerResourcePurpose.h"

NS_ASSUME_NONNULL_BEGIN

@interface NCDBInvControlTowerResourcePurpose (CoreDataProperties)

@property (nonatomic) int32_t purposeID;
@property (nullable, nonatomic, retain) NSString *purposeText;
@property (nullable, nonatomic, retain) NSSet<NCDBInvControlTowerResource *> *controlTowerResources;

@end

@interface NCDBInvControlTowerResourcePurpose (CoreDataGeneratedAccessors)

- (void)addControlTowerResourcesObject:(NCDBInvControlTowerResource *)value;
- (void)removeControlTowerResourcesObject:(NCDBInvControlTowerResource *)value;
- (void)addControlTowerResources:(NSSet<NCDBInvControlTowerResource *> *)values;
- (void)removeControlTowerResources:(NSSet<NCDBInvControlTowerResource *> *)values;

@end

NS_ASSUME_NONNULL_END
