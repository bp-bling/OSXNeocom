//
//  NCCharacterAttributes.m
//  Neocom
//
//  Created by Артем Шиманский on 14.01.14.
//  Copyright (c) 2014 Artem Shimanski. All rights reserved.
//

#import "NCCharacterAttributes.h"
#import <EVEAPI/EVEAPI.h>
#import "NCTrainingQueue.h"
#include <map>
#include <limits>

@interface NCCharacterAttributes ()
- (int32_t) effectiveAttributeValueWithAttributeID:(int32_t) attributeID;
@end

@implementation NCCharacterAttributes

+ (instancetype) defaultCharacterAttributes {
	NCCharacterAttributes* attributes = [[NCCharacterAttributes alloc] init];
	attributes.charisma = 19;
	attributes.intelligence = 20;
	attributes.memory = 20;
	attributes.perception = 20;
	attributes.willpower = 20;
	return attributes;
}

+ (instancetype) optimalAttributesWithTrainingQueue:(NCTrainingQueue*) trainingQueue {
	if (trainingQueue.skills.count == 0)
		return trainingQueue.characterAttributes ?: [NCCharacterAttributes defaultCharacterAttributes];
	NCCharacterAttributes* characterAttributes = [NCCharacterAttributes defaultCharacterAttributes];

	std::map<int, NSInteger> skillPoints;
	
	for (NCSkillData* skill in trainingQueue.skills) {
		NCDBInvType* type = [trainingQueue.databaseManagedObjectContext invTypeWithTypeID:skill.typeID];
		NCDBDgmTypeAttribute *primaryAttribute = type.attributesDictionary[@(NCPrimaryAttributeAttribteID)];
		NCDBDgmTypeAttribute *secondaryAttribute = type.attributesDictionary[@(NCSecondaryAttributeAttribteID)];
		int primaryAttributeID = 1 << ((int) primaryAttribute.value - NCCharismaAttributeID);
		int secondaryAttributeID = 1 << ((int) secondaryAttribute.value - NCCharismaAttributeID);
		skillPoints[primaryAttributeID | (secondaryAttributeID << 16)] += skill.skillPointsToLevelUp;
	}

	
	int basePoints = 17;
	int bonusPoints = 14;
	int maxPoints = 27;
	int totalMaxPoints = basePoints * 5 + bonusPoints;
	float minTrainingTime = std::numeric_limits<float>().max();
	
	for (int intelligence = basePoints; intelligence <= maxPoints; intelligence++) {
		for (int memory = basePoints; memory <= maxPoints; memory++) {
			for (int perception = basePoints; perception <= maxPoints; perception++) {
				if (intelligence + memory + perception > totalMaxPoints - basePoints * 2)
					break;
				
				for (int willpower = basePoints; willpower <= maxPoints; willpower++) {
					if (intelligence + memory + perception + willpower > totalMaxPoints - basePoints)
						break;
					int charisma = totalMaxPoints - (intelligence + memory + perception + willpower);
					if (charisma > maxPoints)
						continue;
					
					float trainingTime = 0;
					for (const auto& i: skillPoints) {
						int primaryAttribute = 0;
						int secondaryAttribute = 0;
						
						switch (i.first & 0xFF) {
							case 1 << 0:
								primaryAttribute = charisma;
								break;
							case 1 << 1:
								primaryAttribute = intelligence;
								break;
							case 1 << 2:
								primaryAttribute = memory;
								break;
							case 1 << 3:
								primaryAttribute = perception;
								break;
							case 1 << 4:
								primaryAttribute = willpower;
								break;
								
							default:
								break;
						}
						switch ((i.first >> 16) & 0xFF) {
							case 1 << 0:
								secondaryAttribute = charisma;
								break;
							case 1 << 1:
								secondaryAttribute = intelligence;
								break;
							case 1 << 2:
								secondaryAttribute = memory;
								break;
							case 1 << 3:
								secondaryAttribute = perception;
								break;
							case 1 << 4:
								secondaryAttribute = willpower;
								break;
								
							default:
								break;
						}
						trainingTime += i.second / ((float) primaryAttribute + (float) secondaryAttribute / 2.0) * 60.0;
						if (trainingTime > minTrainingTime)
							break;
					}
					if (trainingTime < minTrainingTime) {
						minTrainingTime = trainingTime;
						characterAttributes.intelligence = intelligence;
						characterAttributes.memory = memory;
						characterAttributes.perception = perception;
						characterAttributes.willpower = willpower;
						characterAttributes.charisma = charisma;
					}
				}
			}
		}
	}
	
	return characterAttributes;
}

- (id) initWithCharacterSheet:(EVECharacterSheet*) characterSheet {
	if (self = [super init]) {
		if (characterSheet) {
			self.charisma = characterSheet.attributes.charisma;
			self.intelligence = characterSheet.attributes.intelligence;
			self.memory = characterSheet.attributes.memory;
			self.perception = characterSheet.attributes.perception;
			self.willpower = characterSheet.attributes.willpower;
			NSManagedObjectContext* databaseManagedObjectContext = [[NCDatabase sharedDatabase] managedObjectContext];
			for (EVECharacterSheetImplant* implant in characterSheet.implants) {
				NCDBInvType* type = [databaseManagedObjectContext invTypeWithTypeID:implant.typeID];
				self.charisma += [(NCDBDgmTypeAttribute*) type.attributesDictionary[@(NCCharismaBonusAttributeID)] value];
				self.intelligence += [(NCDBDgmTypeAttribute*) type.attributesDictionary[@(NCIntelligenceBonusAttributeID)] value];
				self.memory += [(NCDBDgmTypeAttribute*) type.attributesDictionary[@(NCMemoryBonusAttributeID)] value];
				self.perception += [(NCDBDgmTypeAttribute*) type.attributesDictionary[@(NCPerceptionBonusAttributeID)] value];
				self.willpower += [(NCDBDgmTypeAttribute*) type.attributesDictionary[@(NCWillpowerBonusAttributeID)] value];
			}
		}
		else {
			self.charisma = 19;
			self.intelligence = 20;
			self.memory = 20;
			self.perception = 20;
			self.willpower = 20;
		}
	}
	return self;
}

- (float) skillpointsPerSecondForSkill:(NCDBInvType*) skill {
	__block float skillpointsPerSecond = 0;
	[skill.managedObjectContext performBlockAndWait:^{
		NCDBDgmTypeAttribute *primaryAttribute = skill.attributesDictionary[@(NCPrimaryAttributeAttribteID)];
		NCDBDgmTypeAttribute *secondaryAttribute = skill.attributesDictionary[@(NCSecondaryAttributeAttribteID)];
		skillpointsPerSecond = [self skillpointsPerSecondWithPrimaryAttribute:primaryAttribute.value secondaryAttribute:secondaryAttribute.value];
	}];
	return skillpointsPerSecond;
}

- (float) skillpointsPerSecondWithPrimaryAttribute:(int32_t) primaryAttributeID secondaryAttribute:(int32_t) secondaryAttributeID {
	int32_t effectivePrimaryAttribute = [self effectiveAttributeValueWithAttributeID:primaryAttributeID];
	int32_t effectiveSecondaryAttribute = [self effectiveAttributeValueWithAttributeID:secondaryAttributeID];
	return (effectivePrimaryAttribute + effectiveSecondaryAttribute / 2.0) / 60.0;
}


#pragma mark - NSCoding

- (void) encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeInt32:self.charisma forKey:@"charisma"];
	[aCoder encodeInt32:self.intelligence forKey:@"intelligence"];
	[aCoder encodeInt32:self.memory forKey:@"memory"];
	[aCoder encodeInt32:self.perception forKey:@"perception"];
	[aCoder encodeInt32:self.willpower forKey:@"willpower"];
}

- (id) initWithCoder:(NSCoder *)aDecoder {
	if (self = [super init]) {
		self.charisma = [aDecoder decodeInt32ForKey:@"charisma"];
		self.intelligence = [aDecoder decodeInt32ForKey:@"intelligence"];
		self.memory = [aDecoder decodeInt32ForKey:@"memory"];
		self.perception = [aDecoder decodeInt32ForKey:@"perception"];
		self.willpower = [aDecoder decodeInt32ForKey:@"willpower"];
	}
	return self;
}

#pragma mark - Private

- (int32_t) effectiveAttributeValueWithAttributeID:(int32_t) attributeID {
	switch (attributeID) {
		case NCCharismaAttributeID:
			return self.charisma;
		case NCIntelligenceAttributeID:
			return self.intelligence;
		case NCMemoryAttributeID:
			return self.memory;
		case NCPerceptionAttributeID:
			return self.perception;
		case NCWillpowerAttributeID:
			return self.willpower;
		default:
			break;
	}
	return 0;
}

@end