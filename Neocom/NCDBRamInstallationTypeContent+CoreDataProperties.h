//
//  NCDBRamInstallationTypeContent+CoreDataProperties.h
//  Neocom
//
//  Created by Artem Shimanski on 16.02.16.
//  Copyright © 2016 Shimanski Artem. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "NCDBRamInstallationTypeContent.h"

NS_ASSUME_NONNULL_BEGIN

@interface NCDBRamInstallationTypeContent (CoreDataProperties)

@property (nonatomic) int32_t quantity;
@property (nullable, nonatomic, retain) NCDBRamAssemblyLineType *assemblyLineType;
@property (nullable, nonatomic, retain) NCDBInvType *installationType;

@end

NS_ASSUME_NONNULL_END
