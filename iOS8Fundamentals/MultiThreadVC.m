//
//  MultiThreadVC.m
//  iOS8Fundamentals
//
//  Created by Pedro Ontiveros on 5/30/15.
//  Copyright (c) 2015 Pedro Ontiveros. All rights reserved.
//

#import "MultiThreadVC.h"
#import "GrandCentralDispatchVC.h"

@interface MultiThreadVC ()

@end

@implementation MultiThreadVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Threaded Programming";
    
    if (!items) {
        items = @{@"Grand Central Dispatch" : @"openGCDVC",
                  @"NSThread Class" : @"openNSThreadVC",
                  @"NSRunLoop Class" : @"openNSRunLoppVC",
                  @"Synchronization" : @"openSyncVC"};
    }
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

- (void)openGCDVC
{
    GrandCentralDispatchVC *vc = [[GrandCentralDispatchVC alloc] initWithNibName:@"GrandCentralDispatchView" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return items.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MultiThreadCellView";
    UITableViewCell   *cellView = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cellView) {
        cellView = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cellView.textLabel.text = [[items allKeys] objectAtIndex:indexPath.row];
    return cellView;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try {
        NSString *strSelector = [items objectForKey:[[items allKeys] objectAtIndex:indexPath.row]];
        SEL      signatureSel = NSSelectorFromString(strSelector);
        
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

@end
