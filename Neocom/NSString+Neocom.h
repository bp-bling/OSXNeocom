//
//  NSString+Neocom.h
//  Neocom
//
//  Created by Артем Шиманский on 26.02.16.
//  Copyright © 2016 Shimanski Artem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Neocom)

//+ (NSString*) stringWithResource:(float) resource unit:(NSString*) unit;
+ (NSString*) stringWithTotalResources:(float) total usedResources:(float) used unit:(NSString*) unit;
+ (NSString*) shortStringWithFloat:(float) value unit:(NSString*) unit;
+ (NSString*) stringWithTimeLeft:(NSTimeInterval) timeLeft;
+ (NSString*) stringWithTimeLeft:(NSTimeInterval) timeLeft componentsLimit:(NSInteger) componentsLimit;

@end
