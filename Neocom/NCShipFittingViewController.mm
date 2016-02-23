//
//  NCShipFittingViewController.m
//  Neocom
//
//  Created by Артем Шиманский on 22.02.16.
//  Copyright © 2016 Shimanski Artem. All rights reserved.
//

#import "NCShipFittingViewController.h"
#import "NCShipFit.h"
#import "NCDgmItemsTreeController.h"
#import "NCShipModulesController.h"
#import "NCFittingEngine.h"
#import "NCDatabase.h"
#import "NCShipFitController.h"

@interface NCShipFittingViewController ()
@property (strong) NCFittingEngine* engine;
@end

@implementation NCShipFittingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.engine = [NCFittingEngine new];
	self.fit = [[NCShipFit alloc] initWithType:[[[NCDatabase sharedDatabase] managedObjectContext] invTypeWithTypeID:645]];
	[self.engine loadShipFit:self.fit];
	
	[self.fitController bind:NSContentBinding toObject:self withKeyPath:@"fit" options:nil];
	[self.dgmItems bind:@"fit" toObject:self withKeyPath:@"fit" options:nil];
}

- (IBAction) didSelectItem:(NSArray*) selectedObjects {
	NCDgmItemNode* node = [selectedObjects lastObject];
	if (node.item) {
		[self.fitController objectDidBeginEditing:self];
		self.fit.pilot->getShip()->addModule(node.item.type.typeID);
		[self.fitController objectDidEndEditing:self];
	}
}

- (void) keyDown:(NSEvent *)theEvent {
	unichar key = [[theEvent charactersIgnoringModifiers] characterAtIndex:0];
	if (key == NSBackspaceCharacter || key == NSDeleteCharacter) {
		id view = [self.view.window firstResponder];
		if (view == self.modulesTableView) {
			[self.modules remove:self];
		}
	}
	[super keyDown:theEvent];
}


@end