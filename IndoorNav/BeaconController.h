//
//  BeaconControllerViewController.h
//  IndoorNavi
//
//  Created by Patrick Jayet on 20/08/13.
//  Copyright (c) 2013 Patrick Jayet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>


@interface BeaconController : UIViewController <CBPeripheralManagerDelegate>

@property (readwrite) NSNumber* minor;

@property (strong, nonatomic) IBOutlet UILabel* label;

@end
