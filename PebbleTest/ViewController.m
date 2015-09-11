//
//  ViewController.m
//  PebbleTest
//
//  Created by Daniel on 9/10/15.
//  Copyright (c) 2015 Worthless Apps. All rights reserved.
//

#import "ViewController.h"
#import "CommandLogger.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *rgbLabel;
@end

@implementation ViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self updateBackgroundColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCommandUpdatedNotification) name:kCommandUpdatedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCommandUpdatedNotification) name:kAbsoluteCommandNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [self updateBackgroundColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleCommandUpdatedNotification {
    [self updateBackgroundColor];
}

- (void)updateBackgroundColor {
    CommandLogger* commandLogger = [CommandLogger sharedInstance];
    UIColor* color = [UIColor colorWithRed:commandLogger.currentRVal / 255.f
                                     green:commandLogger.currentGVal / 255.f
                                      blue:commandLogger.currentBVal / 255.f
                                     alpha:1];
    [self.view setBackgroundColor:color];
    
    NSString* text = [NSString stringWithFormat:@"RGB: %d, %d, %d", commandLogger.currentRVal, commandLogger.currentGVal, commandLogger.currentBVal];
    self.rgbLabel.text = text;
}

@end
