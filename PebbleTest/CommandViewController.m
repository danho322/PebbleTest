//
//  CommandViewController.m
//  PebbleTest
//
//  Created by Daniel on 9/10/15.
//  Copyright (c) 2015 Worthless Apps. All rights reserved.
//

#import "CommandViewController.h"
#import "CommandLogger.h"
#import "RGBCommand.h"

@interface CommandViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *commandTableView;

@end

@implementation CommandViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.commandTableView.delegate = self;
    self.commandTableView.dataSource = self;
    self.commandTableView.allowsMultipleSelection = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCommandUpdatedNotification) name:kCommandUpdatedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAbsoluteCommandNotification) name:kAbsoluteCommandNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.commandTableView reloadData];
}

- (void)handleCommandUpdatedNotification {
//    [self.commandTableView reloadData];
    [self.commandTableView beginUpdates];
    
    NSIndexPath* index = [NSIndexPath indexPathForRow:[[CommandLogger sharedInstance] commandCount] - 1 inSection:0];
    [self.commandTableView insertRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self.commandTableView endUpdates];
}

- (void)handleAbsoluteCommandNotification {
    [self.commandTableView reloadData];
}

- (void)configureCell:(UITableViewCell*)cell rgbCommand:(RGBCommand*)command {
    [cell setHighlighted:command.isCommandSelected animated:NO];
    dispatch_queue_t background_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(background_queue, ^{
        NSString* labelText = [command commandLabelText];
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.textLabel.text = labelText;
        });
    });
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    CommandLogger* commandLogger = [CommandLogger sharedInstance];
    return [commandLogger commandCount];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* cellIdentifier = @"TableViewCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommandLogger* commandLogger = [CommandLogger sharedInstance];
    [self configureCell:cell rgbCommand:[commandLogger commandForIndex:indexPath.row]];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CommandLogger* commandLogger = [CommandLogger sharedInstance];
    BOOL selected = [commandLogger toggleCommandIndex:indexPath.row ];
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:selected];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    CommandLogger* commandLogger = [CommandLogger sharedInstance];
    BOOL selected = [commandLogger toggleCommandIndex:indexPath.row ];
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:selected];
}

@end
