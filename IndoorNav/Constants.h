//
//  Constants.h
//  IndoorNavi
//
//  Created by Patrick Jayet on 23/08/13.
//  Copyright (c) 2013 Patrick Jayet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject

+ (Constants*) shared;

- (NSString*) identifier;

- (NSUUID*) beaconUuid;
- (NSNumber*) major;
- (NSNumber*) minorBeacon1;
- (NSNumber*) minorBeacon2;
- (NSNumber*) power;

- (NSString*) attributeForBeacon: (NSNumber*) minor andKey:(NSString*) key;

@end
