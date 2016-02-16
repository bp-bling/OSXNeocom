//
//  NCDBInvType.h
//  Neocom
//
//  Created by Artem Shimanski on 16.02.16.
//  Copyright © 2016 Shimanski Artem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NCDBCertCertificate, NCDBCertSkill, NCDBChrRace, NCDBDgmEffect, NCDBDgmTypeAttribute, NCDBDgmppHullType, NCDBDgmppItem, NCDBEveIcon, NCDBIndBlueprintType, NCDBIndProduct, NCDBIndRequiredMaterial, NCDBIndRequiredSkill, NCDBInvControlTower, NCDBInvControlTowerResource, NCDBInvGroup, NCDBInvMarketGroup, NCDBInvMetaGroup, NCDBInvTypeRequiredSkill, NCDBMapDenormalize, NCDBRamInstallationTypeContent, NCDBStaStation, NCDBTxtDescription, NCDBWhType;

NS_ASSUME_NONNULL_BEGIN

@interface NCDBInvType : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "NCDBInvType+CoreDataProperties.h"
