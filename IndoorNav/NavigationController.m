//
//  NavigationController.m
//  IndoorNavi
//
//  Created by Patrick Jayet on 23/08/13.
//  Copyright (c) 2013 Patrick Jayet. All rights reserved.
//

#import "NavigationController.h"
#import "Constants.h"
#import <AVFoundation/AVFoundation.h>


@interface NavigationController ()

@property (strong,nonatomic) CLLocationManager* locationManager;
@property (strong,nonatomic) CLBeaconRegion* region;
@property (strong,nonatomic) NSString* lastTextualPos;
@property (strong,nonatomic) AVSpeechSynthesizer* speeachSynthesizer;

- (void) sayTextIfChanged: (NSString*) text;
- (void) resetDisplay;
- (NSArray*) sortBeacons:(NSArray*)beacons;
- (void) updateUiForNearestBeacon:(CLBeacon*) nearestBeacon;

@end


@implementation NavigationController

#pragma mark custom methods

- (void) sayTextIfChanged: (NSString*) text
{
    if (![self.lastTextualPos isEqualToString:text]) {
        self.lastTextualPos = text;
        AVSpeechUtterance* speechUtterance = [AVSpeechUtterance speechUtteranceWithString:text];
        speechUtterance.rate = 0.2;
        [self.speeachSynthesizer speakUtterance:speechUtterance];
    }
}

- (void) resetDisplay
{
    self.label.text = @"No beacon in range";
    self.distLabel.text = @"Infinity";
    self.image.image = nil;
    
    [self sayTextIfChanged:self.label.text];
}

- (NSArray*) sortBeacons:(NSArray*)beacons
{
    return [beacons sortedArrayUsingComparator:^(id obj1, id obj2) {
        CLBeacon* beacon1 = (CLBeacon*)obj1;
        CLBeacon* beacon2 = (CLBeacon*)obj2;
        
        if (beacon1.accuracy < beacon2.accuracy) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        else if (beacon1.accuracy > beacon2.accuracy) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        else {
            return (NSComparisonResult)NSOrderedSame;
        }
    }];
}

- (void) updateUiForNearestBeacon:(CLBeacon*) nearestBeacon
{
    Constants* constants = [Constants shared];
    NSString* beaconId = [constants attributeForBeacon:nearestBeacon.minor andKey:@"id"];
    
    NSString* prefix = nil;
    NSString* imageName = nil;
    if (nearestBeacon.proximity == CLProximityImmediate) {
        prefix = @"At the";
        imageName = [constants attributeForBeacon:nearestBeacon.minor andKey:@"image_at"];
    }
    else if (nearestBeacon.proximity == CLProximityNear) {
        prefix = @"Near the";
        imageName = [constants attributeForBeacon:nearestBeacon.minor andKey:@"image_near"];
    }
    else if (nearestBeacon.proximity == CLProximityFar) {
        prefix = @"Far from the";
    }
    
    if (prefix != nil) {
        NSString* text = [NSString stringWithFormat:@"%@ %@", prefix, beaconId];
        self.label.text = text;
        self.distLabel.text = [NSString stringWithFormat:@"%.2f m", nearestBeacon.accuracy];
        self.image.image = [UIImage imageNamed:imageName];
        
        [self sayTextIfChanged:text];
        
    }
    else {
        [self resetDisplay];
    }
    
}

#pragma mark methods from CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    NSLog(@"did enter region %@", region);
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    NSLog(@"did exit region %@", region);
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    NSLog(@"monitoring did fail for region %@, with error %@", region, [error localizedDescription]);
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    if(state == CLRegionStateInside)
    {
        NSLog(@"You're inside the region %@", region);
    }
    else if(state == CLRegionStateOutside)
    {
        NSLog(@"You're outside the region %@", region);
    }
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    // CoreLocation will call this delegate method at 1 Hz with updated range information.
    // Beacons will be categorized and displayed by proximity.
    
    if ([beacons count] == 0) {
        [self resetDisplay];
        return;
    }
    
    NSArray* sortedBeacons = [self sortBeacons:beacons];
    CLBeacon* nearestBeacon = [sortedBeacons objectAtIndex:0];
    [self updateUiForNearestBeacon:nearestBeacon];

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

    self.speeachSynthesizer = [[AVSpeechSynthesizer alloc] init];
    self.lastTextualPos = nil;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    Constants* constants = [Constants shared];
    NSUUID* uuid  = [constants beaconUuid];
    NSNumber* major = [constants major];
    NSString* identifier = [constants identifier];
    
    self.region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid major:[major shortValue] identifier:identifier];
    self.region.notifyOnEntry = YES;
    self.region.notifyOnExit = YES;
    
    [self.locationManager startMonitoringForRegion:self.region];
    [self.locationManager startRangingBeaconsInRegion:self.region];
    
    self.distLabel.text = @"infinity";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self resetDisplay];
    [self.locationManager startMonitoringForRegion:self.region];
    [self.locationManager startRangingBeaconsInRegion:self.region];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.locationManager stopMonitoringForRegion:self.region];
    [self.locationManager stopRangingBeaconsInRegion:self.region];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
