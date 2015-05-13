//
//  IBeaconViewController.m
//  iOS8Fundamentals
//
//  Created by Pedro Ontiveros on 5/13/15.
//  Copyright (c) 2015 Pedro Ontiveros. All rights reserved.
//

#import "IBeaconViewController.h"

@interface IBeaconViewController ()

@end

@implementation IBeaconViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"72D678E1-C1C4-4161-92F1-60A05347AF93"];
    CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid major:100 minor:1 identifier:@"UbiClip1"];
    
    [self.locationManager startRangingBeaconsInRegion:region];
    [self.locationManager startMonitoringForRegion:region];
    // [self.locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSString*)readProximity:(CLProximity)proximity
{
    switch (proximity) {
        case CLProximityUnknown: {
        } break;
        case CLProximityImmediate: { } break;
        case CLProximityNear: {} break;
        case CLProximityFar: {}break;
        default:
            break;
    }
    
    return @"";
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"Hello I'm in didUpdateLocations");
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
    NSLog(@"Hello I'm in didStartMonitoringForRegion");
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    NSLog(@"Hello I'm in didRangeBeacons");
}

- (void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error
{
    if (error) {
        NSLog(@"monitor region beacon error: %@", [error description]);
    } else {
        NSLog(@"Hello I'm in didStartMonitoringForRegion");
    }
}

@end
