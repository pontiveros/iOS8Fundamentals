//
//  ViewController.m
//  iOS8Fundamentals
//
//  Created by Pedro Ontiveros on 5/13/15.
//  Copyright (c) 2015 Pedro Ontiveros. All rights reserved.
//

#import "RootViewController.h"
#import "IBeaconViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    self.title = @"iOS8Fundamentals";
    items = [[NSMutableDictionary alloc] init];
    [self fillRootTable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fillRootTable
{
    NSMutableDictionary *fundamentals = [[NSMutableDictionary alloc] init];
    [fundamentals setObject:@"openCoreDataSample" forKey:@"CoreData"];
    [fundamentals setObject:@"openWebViewVC" forKey:@"WebView"];
    [fundamentals setObject:@"openTableVC" forKey:@"TableView"];
    [fundamentals setObject:@"openCamera" forKey:@"Camera"];
    [fundamentals setObject:@"openMemoryManagement" forKey:@"Memory Management"];
    [fundamentals setObject:@"openFilesAndNetworking" forKey:@"Files and Networking"];
    [fundamentals setObject:@"openWorkingViews" forKey:@"Working with views"];
    [items setObject:fundamentals forKey:@"Fundamentals"];
    
    NSMutableDictionary *advanced = [[NSMutableDictionary alloc] init];
    [advanced setObject:@"openGesturesVC" forKey:@"Gestures"];
    [advanced setObject:@"openLocationModule" forKey:@"Location"];
    [advanced setObject:@"openMultithreadVC" forKey:@"Multithreading"];
    [advanced setObject:@"openGravityCollisionVC" forKey:@"Gravity And Collission"];
    [advanced setObject:@"openQuartzModule" forKey:@"Quartz"];
    [advanced setObject:@"openBeaconVC" forKey:@"iBeacon"];
    [items setObject:advanced forKey:@"Advanced"];
    
    /*
     NSMutableDictionary *graphics = [[[NSMutableDictionary alloc] init] autorelease];
     [graphics setObject:@"openMotionView" forKey:@"Motion"];
     [graphics setObject:@"openTransitions" forKey:@"Transitions"];
     [graphics setObject:@"openGesturesView" forKey:@"Gesture recognizer"];
     [items setObject:graphics forKey:@"Graphics"];
     */
}

- (void)openBeaconVC
{
    NSLog(@"Hello Pedro Ontiveros.");
    
    IBeaconViewController *vc = [[IBeaconViewController alloc] initWithNibName:@"IBeaconView" bundle:nil];
    [self presentViewController:vc animated:YES completion:nil];
//    [self.navigationController presentViewController:vc animated:YES completion:nil];
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try {
        NSString         *key = [[items allKeys] objectAtIndex:indexPath.section];
        NSDictionary    *dict = [items objectForKey:key];
        NSString *strSelector = [dict objectForKey:[[dict allKeys] objectAtIndex:indexPath.row]];
        
        SEL         signatureSel = NSSelectorFromString(strSelector);
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:signatureSel]];
        
        [invocation setTarget:self];
        [invocation setSelector:signatureSel];
        [invocation invoke];
        
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        
    } @catch (NSException *err) {
        NSLog(@"An error has occurred :%@", [err description]);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR" message:[err description] delegate:nil cancelButtonTitle:@"Accept" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [[UITableViewCell alloc] init];
    NSString     *key  = [[items allKeys] objectAtIndex:indexPath.section];
    NSDictionary *dict = [items objectForKey:key];
    NSString    *label = [[dict allKeys] objectAtIndex:indexPath.row];
    
    [cell.textLabel setText:label];
    return cell;
}
- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = [[items allKeys] objectAtIndex:section];
    return title;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray  *keys = [items allKeys];
    NSString  *key = [keys objectAtIndex:section];
    NSDictionary *dict = [items objectForKey:key];
    return [dict count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [items count];
}

@end
