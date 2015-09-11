//
//  MainViewController.m
//  PebbleTest
//
//  Created by Daniel on 9/10/15.
//  Copyright (c) 2015 Worthless Apps. All rights reserved.
//

#import "MainViewController.h"
#import "CommandLogger.h"

@interface MainViewController ()
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialize CommandLogger singleton instance
    [CommandLogger sharedInstance];
    
    // relative needs to be calculated based on selected
    // receiving absolute will deselect all
    // eventually add back in new command deselecting all (disable to test)
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
