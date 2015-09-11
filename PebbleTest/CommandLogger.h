//
//  CommandLogger.h
//  PebbleTest
//
//  Created by Daniel on 9/10/15.
//  Copyright (c) 2015 Worthless Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString* kCommandUpdatedNotification = @"kCommandUpdatedNotification";
static NSString* kAbsoluteCommandNotification = @"kAbsoluteCommandNotification";

@class RGBCommand;
@interface CommandLogger : NSObject

@property (nonatomic) uint8_t currentRVal;
@property (nonatomic) uint8_t currentGVal;
@property (nonatomic) uint8_t currentBVal;

- (NSInteger)commandCount;
- (RGBCommand*)commandForIndex:(NSInteger)index;
- (BOOL)toggleCommandIndex:(NSInteger)index;
+ (id)sharedInstance;

@end
