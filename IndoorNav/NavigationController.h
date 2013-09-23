//
//  NavigationController.h
//  IndoorNavi
//
//  Created by Patrick Jayet on 23/08/13.
//  Copyright (c) 2013 Patrick Jayet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface NavigationController : UIViewController <CLLocationManagerDelegate>

@property (weak,nonatomic) IBOutlet UILabel* label;
@property (weak,nonatomic) IBOutlet UILabel* distLabel;
@property (weak,nonatomic) IBOutlet UIImageView* image;

@end
