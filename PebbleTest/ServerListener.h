//
//  ServerListener.h
//  PebbleTest
//
//  Created by Daniel on 9/10/15.
//  Copyright (c) 2015 Worthless Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ServerListener;
@protocol ServerListenerDelegate
- (void)serverListener:(ServerListener*)serverListener relativeUpdateR:(int16_t)r g:(int16_t)g b:(int16_t)b;
- (void)serverListener:(ServerListener*)serverListener absoluteUpdateR:(uint8_t)r g:(uint8_t)g b:(uint8_t)b;
@end

@interface ServerListener : NSObject

- (id)initWithDelegate:(id<ServerListenerDelegate>)delegate;

@end
