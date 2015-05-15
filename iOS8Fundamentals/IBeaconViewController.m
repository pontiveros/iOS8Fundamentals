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
    self.title = @"iBeacon";
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    NSUUID *uuid0 = [[NSUUID alloc] initWithUUIDString:@"72D678E1-C1C4-4161-92F1-60A05347AF93"];
    NSUUID *uuid1 = [[NSUUID alloc] initWithUUIDString:@"92DDA21C-128E-4222-A6EE-EED829DA039D"];
    NSUUID *uuid2 = [[NSUUID alloc] initWithUUIDString:@"E2C56DB5-DFFB--B060-D0F5A71096E0"];
    
    CLBeaconRegion *region0 = [[CLBeaconRegion alloc] initWithProximityUUID:uuid0 major:5 minor:1000 identifier:@"UbiClip0"];
    CLBeaconRegion *region1 = [[CLBeaconRegion alloc] initWithProximityUUID:uuid1 major:5 minor:1000 identifier:@"UbiClip1"];
    CLBeaconRegion *region2 = [[CLBeaconRegion alloc] initWithProximityUUID:uuid2 major:5 minor:1000 identifier:@"iPadAir"];
    
    [self.locationManager startRangingBeaconsInRegion:region0];
    [self.locationManager startMonitoringForRegion:region0];
    
    [self.locationManager startRangingBeaconsInRegion:region1];
    [self.locationManager startMonitoringForRegion:region1];
    
    [self.locationManager startRangingBeaconsInRegion:region2];
    [self.locationManager startMonitoringForRegion:region2];
    
    [self.locationManager startUpdatingLocation];
    [self.locationManager startMonitoringVisits];
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
        case CLProximityUnknown:    { [self.label setText:@"Unknown distance"]; }   break;
        case CLProximityImmediate:  { [self.label setText:@"Immediate distance"]; } break;
        case CLProximityNear:       { [self.label setText:@"Near distance"]; }      break;
        case CLProximityFar:        { [self.label setText:@"Far distance"]; }       break;
        default:                    { [self.label setText:@"Unkdefined"]; }         break;
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
    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        CLBeaconRegion *beacon = (CLBeaconRegion*)region;
        NSLog(@"%@", beacon.proximityUUID);
    } else {
        NSLog(@"is not a fucking beacon.");
    }
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

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    if (region) {
        NSLog(@"hi I'm didEnterRegion");
    }
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    if (region) {
        NSLog(@"hi I'm didExitRegion");
    }
}

@end
