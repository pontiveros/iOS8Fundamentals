//
//  RegionMonitor.h
//  iOS8Fundamentals
//
//  Created by Pedro Ontiveros on 5/15/15.
//  Copyright (c) 2015 Pedro Ontiveros. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface RegionMonitor : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

+ (id)sharedInstance;
- (void)startRegionMonitor;

@end
