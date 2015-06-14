//
//  ViewController.m
//  iOS8Fundamentals
//
//  Created by Pedro Ontiveros on 5/13/15.
//  Copyright (c) 2015 Pedro Ontiveros. All rights reserved.
//

#import "RootViewController.h"
#import "IBeaconViewController.h"
#import "UIWebViewController.h"
#import "MultiThreadVC.h"
#import "NetworkingVC.h"

@interface RootViewController ()

@end


@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"iOS8Fundamentals";
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
    [advanced setObject:@"openMultithreadVC" forKey:@"Threaded Programming"];
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
//    [self presentViewController:vc animated:YES completion:nil];
//    [self.navigationController presentViewController:vc animated:YES completion:nil];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)openWebViewVC
{
    UIWebViewController * vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"UIWebViewVC"];
    [self.navigationController pushViewController:vc animated:YES];
    
//    YourViewControllerClass *viewController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
}

- (void)openMultithreadVC
{
    MultiThreadVC *vc = [[MultiThreadVC alloc] initWithNibName:@"MultiThreadView" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)openFilesAndNetworking
{
    NetworkingVC *vc = [[NetworkingVC alloc] initWithNibName:@"NetworkingView" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try {
        NSString         *key = [[items allKeys] objectAtIndex:indexPath.section];
        NSDictionary    *dict = [items objectForKey:key];
        NSString *strSelector = [dict objectForKey:[[dict allKeys] objectAtIndex:indexPath.row]];
        
        SEL         signatureSel = NSSelectorFromString(strSelector);
        
        if ([self respondsToSelector:signatureSel]) {
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:signatureSel]];
            
            [invocation setTarget:self];
            [invocation setSelector:signatureSel];
            [invocation invoke];
            
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"WARNING" message:@"This functionality is not implemented!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction    *action = [UIAlertAction actionWithTitle:@"Accept" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
    } @catch (NSException *err) {
        NSLog(@"An error has occurred :%@", [err description]);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR" message:[err description] delegate:nil cancelButtonTitle:@"Accept" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"RootViewCellView";
    UITableViewCell   *cellView = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cellView) {
        cellView = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    NSString     *key  = [[items allKeys] objectAtIndex:indexPath.section];
    NSDictionary *dict = [items objectForKey:key];
    NSString    *label = [[dict allKeys] objectAtIndex:indexPath.row];
    
    [cellView.textLabel setText:label];
    
    return cellView;
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
