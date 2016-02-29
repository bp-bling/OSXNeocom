//
//  NCSkillData.m
//  Neocom
//
//  Created by Артем Шиманский on 26.02.16.
//  Copyright © 2016 Shimanski Artem. All rights reserved.
//

#import "NCSkillData.h"
#import "NCCharacterAttributes.h"
#import <EVEAPI/EVEAPI.h>
#import <objc/runtime.h>

@interface NCSkillData() {
	NSNumber* _hash;
}
//@property (nonatomic, strong, readwrite) NCDBInvType* type;
@property (nonatomic, strong) NSString* typeName;
@property (nonatomic, assign) int32_t rank;
@property (nonatomic, assign) int32_t typeID;
@property (nonatomic, assign) int32_t primaryAttributeID;
@property (nonatomic, assign) int32_t secondaryAttributeID;

@end

@implementation NCSkillData

- (NSTimeInterval) trainingTimeToLevelUpWithCharacterAttributes:(NCCharacterAttributes*) attributes {
	return [self skillPointsToLevelUp] / [attributes skillpointsPerSecondWithPrimaryAttribute:self.primaryAttributeID secondaryAttribute:self.secondaryAttributeID];
}

- (NSTimeInterval) trainingTimeToFinishWithCharacterAttributes:(NCCharacterAttributes*) attributes {
	return [self skillPointsToFinish] / [attributes skillpointsPerSecondWithPrimaryAttribute:self.primaryAttributeID secondaryAttribute:self.secondaryAttributeID];
}

- (id) initWithInvType:(NCDBInvType*) type {
	if (!type)
		return nil;

	if (self = [super init]) {
		[type.managedObjectContext performBlockAndWait:^{
			self.typeID = type.typeID;
			self.rank = [(NCDBDgmTypeAttribute*) type.attributesDictionary[@(NCSkillTimeConstantAttributeID)] value];
			self.primaryAttributeID = [(NCDBDgmTypeAttribute*) type.attributesDictionary[@(NCPrimaryAttributeAttribteID)] value];
			self.secondaryAttributeID = [(NCDBDgmTypeAttribute*) type.attributesDictionary[@(NCSecondaryAttributeAttribteID)] value];
			self.typeName = type.typeName;
		}];
	}
	return self;
}

- (float) skillPointsAtLevel:(int32_t) level {
	if (level == 0)
		return 0;
	if (self.rank) {
		float sp = pow(2, 2.5 * level - 2.5) * 250 * self.rank;
		return sp;
	}
	return 0;
}

- (int32_t) skillPointsToFinish {
	float sp = [self skillPointsAtLevel:self.currentLevel];
	float targetSP = self.targetSkillPoints;
	sp = MAX(sp, self.skillPoints);
	return targetSP > sp ? (targetSP - sp) : 0;
}

- (int32_t) skillPointsToLevelUp {
	float sp = [self skillPointsAtLevel:self.currentLevel];
	float targetSP = [self skillPointsAtLevel:self.currentLevel + 1];
	sp = MAX(sp, self.skillPoints);
	targetSP = MIN(self.targetSkillPoints, targetSP);
	
	return targetSP > sp ? (targetSP - sp) : 0;
}

- (void) setTargetLevel:(int32_t)targetLevel {
	_targetLevel = targetLevel;
	_targetSkillPoints = [self skillPointsAtLevel:targetLevel];
	_hash = nil;
}

- (void) setCurrentLevel:(int32_t)currentLevel {
	_currentLevel = currentLevel;
	_hash = nil;
}

- (void) setCharacterSkill:(EVECharacterSheetSkill *)characterSkill {
	_characterSkill = characterSkill;
	_hash = nil;
}

- (int32_t) trainedLevel {
	return self.characterSkill.level;
}

- (int32_t) skillPoints {
	return self.characterSkill.skillPoints;
}

- (BOOL) isActive {
	if (self.currentLevel == self.targetLevel - 1) {
		for (EVESkillQueueItem* item in self.characterSkill.skillQueueItems) {
			if (item.queuePosition == 0)
				return item.level == self.targetLevel;
		}
	}
	return NO;
}

- (NSString*) description {
	NSString* description = [NSString stringWithFormat:@"%@ (x%d)", self.typeName, self.rank];
	return description;
}

- (NSTimeInterval) trainingTimeToLevelUp {
	return [self trainingTimeToLevelUpWithCharacterAttributes:self.characterAttributes ?: [NCCharacterAttributes defaultCharacterAttributes]];
}

- (NSTimeInterval) trainingTime {
	return [self trainingTimeToFinishWithCharacterAttributes:self.characterAttributes ?: [NCCharacterAttributes defaultCharacterAttributes]];
}

- (BOOL) isEqual:(id)object {
	return [object isKindOfClass:[self class]] && self.hash == [object hash];
}

- (NSUInteger) hash {
	if (!_hash) {
		NSInteger data[] = {self.typeID, self.targetLevel, self.currentLevel, self.trainedLevel};
		NSUInteger hash = [[NSData dataWithBytes:data length:sizeof(data)] hash];
		_hash = @(hash);
		return hash;
	}
	else
		return [_hash unsignedIntegerValue];
}

- (NSImage*) levelImage {
	NSDataAsset* asset = [[NSDataAsset alloc] initWithName:[NSString stringWithFormat:@"level_%d%d%d", self.trainedLevel, self.targetLevel, self.active]];
	return [[NSImage alloc] initWithData:asset.data];
}

- (float) progress {
	float sp = [self skillPointsAtLevel:self.currentLevel];
	float targetSP = [self skillPointsAtLevel:self.currentLevel + 1];

	return 1.0 - ([self skillPointsToLevelUp] / (targetSP - sp));
}

#pragma mark - NSCopying

- (id) copyWithZone:(NSZone *)zone {
	NCSkillData* other = [NCSkillData new];
	other.typeName = self.typeName;
	other.rank = self.rank;
	other.typeID = self.typeID;
	other.primaryAttributeID = self.primaryAttributeID;
	other.secondaryAttributeID = self.secondaryAttributeID;
	other.characterSkill = self.characterSkill;
	other.currentLevel = self.currentLevel;
	other.targetLevel = self.targetLevel;
	other.characterAttributes = self.characterAttributes;
	return other;
}

/*#pragma mark - NSCoding

- (void) encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeInt32:self.typeID forKey:@"typeID"];
	[aCoder encodeInt32:self.currentLevel forKey:@"currentLevel"];
	[aCoder encodeInt32:self.targetLevel forKey:@"targetLevel"];
	[aCoder encodeObject:self.characterSkill forKey:@"characterSkill"];
	if (self.characterAttributes)
		[aCoder encodeObject:self.characterAttributes forKey:@"characterAttributes"];
}

- (id) initWithCoder:(NSCoder *)aDecoder {
	if (self = [super init]) {
		self.typeID = [aDecoder decodeInt32ForKey:@"typeID"];
		self.currentLevel = [aDecoder decodeInt32ForKey:@"currentLevel"];
		self.targetLevel = [aDecoder decodeInt32ForKey:@"targetLevel"];
		self.characterAttributes = [aDecoder decodeObjectForKey:@"characterAttributes"];
		self.characterSkill = [aDecoder decodeObjectForKey:@"characterSkill"];
	}
	return self;
}*/

@end
