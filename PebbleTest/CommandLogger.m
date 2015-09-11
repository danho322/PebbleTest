//
//  CommandLogger.m
//  PebbleTest
//
//  Created by Daniel on 9/10/15.
//  Copyright (c) 2015 Worthless Apps. All rights reserved.
//

#import "CommandLogger.h"
#import "ServerListener.h"
#import "RGBCommand.h"

@interface CommandLogger() <ServerListenerDelegate>
@property (nonatomic, strong) ServerListener* serverListener;
@property (nonatomic, strong) NSMutableArray* commandArray;
@end

@implementation CommandLogger

- (id)init {
    self = [super init];
    if (self) {
        self.currentRVal = 127;
        self.currentGVal = 127;
        self.currentBVal = 127;
        self.serverListener = [[ServerListener alloc] initWithDelegate:self];
        
        self.commandArray = [NSMutableArray array];
    }
    
    return self;
}

- (NSInteger)commandCount {
    return [self.commandArray count];
}

- (RGBCommand*)commandForIndex:(NSInteger)index {
    if (index < 0 || index >= [self commandCount]) {
        return nil;
    }
    
    return self.commandArray[index];
}

- (BOOL)toggleCommandIndex:(NSInteger)index {
    if (index < 0 || index >= [self commandCount]) {
        return NO;
    }
    
    RGBCommand* command = self.commandArray[index];
    if (command.commandType == CommandTypeAbsolute) {
        // Not allowed to select absolute
        return NO;
    }
    command.isCommandSelected = !command.isCommandSelected;
    
    [self selectedCommand:command isSelected:command.isCommandSelected];
    
    return command.isCommandSelected;
}

- (void)selectedCommand:(RGBCommand*)command isSelected:(BOOL)selected {
    
    if (selected) {
        self.currentRVal += command.rVal;
        self.currentGVal += command.gVal;
        self.currentBVal += command.bVal;
    }
    else {
        self.currentRVal -= command.rVal;
        self.currentGVal -= command.gVal;
        self.currentBVal -= command.bVal;
    }
    
    [self keepRGBValuesInBound];
    
    NSLog(@"%d %d %d", self.currentRVal, self.currentGVal, self.currentBVal);
}

- (void)resetSelectedCommands {
    for (RGBCommand* command in self.commandArray) {
        command.isCommandSelected = NO;
    }
}

- (void)keepRGBValuesInBound {
    self.currentRVal = [self validRGBValue:self.currentRVal];
    self.currentGVal = [self validRGBValue:self.currentGVal];
    self.currentBVal = [self validRGBValue:self.currentBVal];
}

- (uint8_t)validRGBValue:(uint8_t)value {
    value = MAX(0, value);
    value = MIN(255, value);
    return value;
}

#pragma mark - Server Listener Delegate

- (void)serverListener:(ServerListener *)serverListener relativeUpdateR:(int16_t)r g:(int16_t)g b:(int16_t)b {
    [self logCommand:CommandTypeRelative r:r g:g b:b];
}

- (void)serverListener:(ServerListener *)serverListener absoluteUpdateR:(uint8_t)r g:(uint8_t)g b:(uint8_t)b {
    [self resetSelectedCommands];
    self.currentRVal = r;
    self.currentGVal = g;
    self.currentBVal = b;
    [self logCommand:CommandTypeAbsolute r:r g:g b:b];
}

- (void)logCommand:(CommandType)type r:(int16_t)r g:(int16_t)g b:(int16_t)b {
    RGBCommand* value = [[RGBCommand alloc] init];
    value.commandType = type;
    value.rVal = r;
    value.gVal = g;
    value.bVal = b;
    
    [self.commandArray addObject:value];
    if (type == CommandTypeRelative) {
        self.currentRVal += value.rVal;
        self.currentGVal += value.gVal;
        self.currentBVal += value.bVal;
        value.isCommandSelected = YES;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kCommandUpdatedNotification object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kAbsoluteCommandNotification object:nil];
    }
    
    NSLog(@"%d %d %d", self.currentRVal, self.currentGVal, self.currentBVal);
    
}

#pragma mark - Singleton

+ (id)sharedInstance {
    static CommandLogger *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

@end
