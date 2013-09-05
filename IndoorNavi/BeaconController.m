//
//  BeaconControllerViewController.m
//  IndoorNavi
//
//  Created by Patrick Jayet on 20/08/13.
//  Copyright (c) 2013 Patrick Jayet. All rights reserved.
//

#import "BeaconController.h"
#import "Constants.h"
#import <CoreLocation/CoreLocation.h>


@interface BeaconController ()
@property (strong, nonatomic) CBPeripheralManager* peripheralManager;
@property (strong, nonatomic) NSDictionary* peripheralData;
@end


@implementation BeaconController

#pragma mark event handling

- (IBAction)peekState:(id)sender
{
    NSLog(@"Peripheral manager did update state %d, advertising %@", self.peripheralManager.state, (self.peripheralManager.isAdvertising ? @"yes" : @"no"));
    
}

#pragma mark methods from CBPeripheralManagerDelegate

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    NSLog(@"Peripheral manager did update state %d, advertising %@", peripheral.state, (peripheral.isAdvertising ? @"yes" : @"no"));
    
    if (!peripheral.isAdvertising) {
        [peripheral startAdvertising:self.peripheralData];
        NSLog(@"advertising %@", (peripheral.isAdvertising ? @"yes" : @"no"));
    }
}

#pragma mark methods from UIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    Constants* constants = [Constants shared];
 
    NSString* id = [constants attributeForBeacon:self.minor andKey:@"id"];
    self.label.text = [NSString stringWithFormat:@"%@ beacon", id];
    
    NSUUID* uuid = [constants beaconUuid];
    NSString* identifier = [constants identifier];
    NSNumber* major = [constants major];
    
    CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid major:[major shortValue] minor:[self.minor shortValue] identifier:identifier];
    self.peripheralData = [region peripheralDataWithMeasuredPower:constants.power];
    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    
    //[self.peripheralManager startAdvertising:peripheralData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
