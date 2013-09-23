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
        NSString* uuid = [[NSUserDefaults standardUserDefaults] stringForKey:@"uuid_preference"];
        self.beaconUuid  = [[NSUUID alloc] initWithUUIDString:uuid];
        
        NSString* minor1 = [[NSUserDefaults standardUserDefaults] stringForKey:@"minor1_preference"];
        NSNumber* minor1Nb = [NSNumber numberWithInt:[minor1 integerValue]];
        NSString* minor2 = [[NSUserDefaults standardUserDefaults] stringForKey:@"minor2_preference"];
        NSNumber* minor2Nb = [NSNumber numberWithInt:[minor2 integerValue]];
        self.beaconData = @{
            minor1Nb:
                @{@"id": @"vegetables",
                  @"image_near": @"offer",
                  @"image_at": @"offer"},
            minor2Nb:
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
    NSString* major = [[NSUserDefaults standardUserDefaults] stringForKey:@"major_preference"];
    return [NSNumber numberWithInt:[major integerValue]];
}

- (NSNumber*) minorBeacon1
{
    NSString* major = [[NSUserDefaults standardUserDefaults] stringForKey:@"minor1_preference"];
    return [NSNumber numberWithInt:[major integerValue]];
}

- (NSNumber*) minorBeacon2
{
    NSString* major = [[NSUserDefaults standardUserDefaults] stringForKey:@"minor2_preference"];
    return [NSNumber numberWithInt:[major integerValue]];
}

- (NSNumber*) power
{
    return @-59;
}

- (NSString*) attributeForBeacon: (NSNumber*) minor andKey:(NSString*) key
{
    NSDictionary* beaconDic = [self.beaconData objectForKey:minor];
    return [beaconDic objectForKey:key];
}

@end
