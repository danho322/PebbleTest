//
//  RGBValue.m
//  PebbleTest
//
//  Created by Daniel on 9/10/15.
//  Copyright (c) 2015 Worthless Apps. All rights reserved.
//

#import "RGBCommand.h"

@implementation RGBCommand

- (id)init {
    self = [super init];
    if (self) {
        self.isCommandSelected = NO;
    }
    return self;
}

- (NSString*)commandLabelText {
    NSString* typeString = self.commandType == CommandTypeAbsolute ? @"Absolute command" : @"Relative command";
    return [NSString stringWithFormat:@"%@ - r:%d g:%d b:%d", typeString, self.rVal, self.gVal, self.bVal];
}

@end
