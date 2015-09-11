//
//  ServerListener.m
//  PebbleTest
//
//  Created by Daniel on 9/10/15.
//  Copyright (c) 2015 Worthless Apps. All rights reserved.
//

#import "ServerListener.h"

#define GET_B(buf, pos) (int8_t)buf[pos]
#define GET_UB(buf, pos) (uint8_t)buf[pos]
#define GET_h(buf, pos) ((int8_t)buf[pos+1] | (int8_t)buf[pos]<<8)

#define PORT_NUM    1234

@interface ServerListener() <NSStreamDelegate>
@property (nonatomic, strong) NSInputStream *inputStream;
@property (nonatomic, weak) id delegate;
@end

@implementation ServerListener

- (id)initWithDelegate:(id)delegate {
    self = [super init];
    if (self) {
        if ([delegate conformsToProtocol:@protocol(ServerListenerDelegate)])
        {
            self.delegate = delegate;
        }
        [self initNetworkCommunication];
    }
    return self;
}

- (void)initNetworkCommunication {
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"localhost", PORT_NUM, &readStream, &writeStream);
    self.inputStream = objc_unretainedObject(readStream);
    [self.inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.inputStream setDelegate:self];
    [self.inputStream open];
}

- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
    switch (streamEvent) {
            
        case NSStreamEventOpenCompleted:
            NSLog(@"Stream opened");
            break;
            
        case NSStreamEventHasBytesAvailable:
            if (theStream == self.inputStream) {
                
                uint8_t buffer[1024];
                NSInteger len;
                
                while ([self.inputStream hasBytesAvailable]) {
                    len = [self.inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0) {
                        
                        int8_t constant = GET_B(buffer, 0);
                        if (constant == 1)
                        {
                            [self.delegate serverListener:self
                                          relativeUpdateR:GET_h(buffer, 1)
                                                        g:GET_h(buffer, 3)
                                                        b:GET_h(buffer, 5)];
                        }
                        else if (constant == 2)
                        {
                            [self.delegate serverListener:self
                                          absoluteUpdateR:GET_UB(buffer, 1)
                                                        g:GET_UB(buffer, 2)
                                                        b:GET_UB(buffer, 3)];
                        }
                    }
                }
            }
            break;
            
        case NSStreamEventErrorOccurred:
            NSLog(@"Can not connect to the host!");
            break;
            
        case NSStreamEventEndEncountered:
            break;
            
        default:
            NSLog(@"Unknown event");
    }
}

@end
