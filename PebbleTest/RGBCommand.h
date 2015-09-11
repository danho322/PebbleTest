//
//  RGBValue.h
//  PebbleTest
//
//  Created by Daniel on 9/10/15.
//  Copyright (c) 2015 Worthless Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CommandType) {
    CommandTypeRelative,
    CommandTypeAbsolute
};

@interface RGBCommand : NSObject

@property (nonatomic) BOOL isCommandSelected;
@property (nonatomic) CommandType commandType;
@property (nonatomic) int16_t rVal;
@property (nonatomic) int16_t gVal;
@property (nonatomic) int16_t bVal;

- (NSString*)commandLabelText;

@end
