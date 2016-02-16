//
//  NCStorage.h
//  Neocom
//
//  Created by Artem Shimanski on 25.01.13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NSManagedObjectContext+NCStorage.h"

#define NCStorageDidChangeNotification @"NCStorageDidChangeNotification"

#define NCSettingsDontNeedsCloudTransfer @"NCSettingsDontNeedsCloudTransfer"
#define NCSettingsDontNeedsCloudReset @"NCSettingsDontNeedsCloudReset"
#define NCSettingsStorageType @"NCSettingsStorageType"
#define NCSettingsUseCloudKey @"NCSettingsUseCloudKey"
#define NCSettingsCloudTokenKey @"NCSettingsCloudTokenKey"
#define NCSettingsMigratedToCloudKey @"NCSettingsMigratedToCloudKey"

typedef NS_ENUM(NSInteger, NCStorageType) {
	NCStorageTypeLocal,
	NCStorageTypeCloud
};


@interface NCStorage : NSObject
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

+ (instancetype) sharedStorage;

@end
