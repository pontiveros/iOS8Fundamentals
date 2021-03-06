//
//  IBeaconViewController.h
//  iOS8Fundamentals
//
//  Created by Pedro Ontiveros on 5/13/15.
//  Copyright (c) 2015 Pedro Ontiveros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface IBeaconViewController : UIViewController <CLLocationManagerDelegate>


@property (nonatomic, strong) CLLocationManager *locationManager;

@end

