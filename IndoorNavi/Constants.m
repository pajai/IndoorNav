//
//  Constants.m
//  IndoorNavi
//
//  Created by Patrick Jayet on 23/08/13.
//  Copyright (c) 2013 Patrick Jayet. All rights reserved.
//

#import "Constants.h"

@interface Constants ()
@property (strong, nonatomic) NSUUID* beaconUuid;
@property (strong, nonatomic) NSDictionary* beaconData;
@end

@implementation Constants

+ (Constants*) shared
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (id)init
{
    self = [super init];
    if(self)
    {
        //self.beaconUuid  = [[NSUUID alloc] initWithUUIDString:@"BF8E3EEB-39BE-CE37-27C7-5EE7EB4B058D"]; // ti tag
        self.beaconUuid  = [[NSUUID alloc] initWithUUIDString:@"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"];
        
        self.beaconData = @{
            @1:
                @{@"id": @"vegetables",
                  @"image_near": @"offer",
                  @"image_at": @"offer"},
            @2:
                @{@"id": @"cash register",
                  @"image_near": @"wife",
                  @"image_at": @"qrcode"},
            };
    }
    
    return self;
}

- (NSString*) identifier
{
    return @"com.zuehlke.IndoorNavi";
}

- (NSUUID*) beaconUuid
{
    return _beaconUuid;
}

- (NSNumber*) major
{
    return @1;
}

- (NSString*) attributeForBeacon: (NSNumber*) minor andKey:(NSString*) key
{
    NSDictionary* beaconDic = [self.beaconData objectForKey:minor];
    return [beaconDic objectForKey:key];
}

- (NSNumber*) power
{
    return @-59;
}

@end
