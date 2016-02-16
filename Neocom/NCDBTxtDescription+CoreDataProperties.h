//
//  NCDBTxtDescription+CoreDataProperties.h
//  Neocom
//
//  Created by Artem Shimanski on 16.02.16.
//  Copyright © 2016 Shimanski Artem. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "NCDBTxtDescription.h"

NS_ASSUME_NONNULL_BEGIN

@interface NCDBTxtDescription (CoreDataProperties)

@property (nullable, nonatomic, retain) id text;
@property (nullable, nonatomic, retain) NCDBCertCertificate *certificate;
@property (nullable, nonatomic, retain) NCDBInvType *type;

@end

NS_ASSUME_NONNULL_END
