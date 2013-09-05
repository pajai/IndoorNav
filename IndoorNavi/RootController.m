//
//  ViewController.m
//  IndoorNavi
//
//  Created by Patrick Jayet on 20/08/13.
//  Copyright (c) 2013 Patrick Jayet. All rights reserved.
//

#import "RootController.h"
#import "BeaconController.h"
#import "NavigationController.h"

@interface RootController ()

@end

@implementation RootController

#pragma mark transitions

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([@"VegetablesBeacon" isEqualToString:segue.identifier]) {
        BeaconController* target = (BeaconController*)segue.destinationViewController;
        target.minor = @1;
    }
    else if ([@"CashRegisterBeacon" isEqualToString:segue.identifier]) {
        BeaconController* target = (BeaconController*)segue.destinationViewController;
        target.minor = @2;
    }
    else if ([@"RangeBeacons" isEqualToString:segue.identifier]) {

        // nop
        
    }
}

#pragma mark methods from UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
