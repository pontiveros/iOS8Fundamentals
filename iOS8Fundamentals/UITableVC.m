//
//  UITableVC.m
//  iOSWorkshop
//
//  Created by Pedro Ontiveros on 7/22/15.
//  Copyright (c) 2015 Pedro Ontiveros. All rights reserved.
//

#import "UITableVC.h"

@interface UITableVC ()

@end

@implementation UITableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"Table VC";
    self.items = [[NSMutableArray alloc] init];
//    for (int i = 0; i < 1000; i++) {
//        [self.items addObject:[NSString stringWithFormat:@"Item order %d", (i + 1)]];
//    }
    
    [self downloadItemsInBackground];
    
// self.items = @[@"Item 1", @"Item 2", @"Item 3", @"Item 4", @"Item 5", @"Item 6", @"Item 7", @"Item 8"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"myCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    NSDictionary *item = self.items[indexPath.row];
    cell.textLabel.text = [item objectForKey:@"title"];
    
//    __weak UITableVC *pSelf = self;
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        NSDictionary *dict = [pSelf.items objectAtIndex:indexPath.row];
//        NSString *url = [dict objectForKey:@"url"];
//        UIImage  *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
//        [cell.imageView setImage:img];
//        [pSelf.tableView reloadData];
//    });
    
    return cell;
}

- (void)downloadItemsInBackground
{
    if (!self.backgroundQueue) {
        self.backgroundQueue = dispatch_queue_create("com.qbxsoft.backgroundQueue", DISPATCH_QUEUE_SERIAL);
    }

    [self.items removeAllObjects];
    
    __weak UITableVC *pSelf = self;
    
    dispatch_async(self.backgroundQueue, ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:REMOTE_URL]
                                                 cachePolicy:NSURLRequestUseProtocolCachePolicy
                                             timeoutInterval:2400000.0]; // TimeOut set on 4 mins.
        NSURLResponse *response = nil;
        NSError *error = nil;
        NSData   *data = [NSURLConnection sendSynchronousRequest:request
                                               returningResponse:&response
                                                           error:&error];

        if (!error) {
            id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            
            if (!error) {
                NSArray *dict = (NSArray*)json;
                
                for (NSDictionary *item in dict) {
                    [pSelf.items addObject:item];
                    NSLog(@"%@", item);
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [pSelf.tableView reloadData];
                    });
#ifdef DELAY_UITABLEVC
                    sleep(1);
#endif
                }
                
            } else {
                NSLog(@"There's an error trying to get data from remote: %@", [error description]);
            }
        } else {
            NSLog(@"Error requesting data: %@", [error description]);
        }
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSLog(@"Array has been loaded!");
    });
}

- (void)downloadItems
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:REMOTE_URL]
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:2400000.0];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               if (!error) {
                                   id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                   NSArray *dict = (NSArray*)json;
                                   
                                   for (NSDictionary *item in dict) {
                                       [self.items addObject:item];
                                       NSLog(@"%@", item);
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           [self.tableView reloadData];
                                       });
                                   }
//                                   dispatch_async(dispatch_get_main_queue(), ^{
//                                        [self.tableView reloadData];
//                                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//                                   });
                               } else {
                                   UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"ERROR"
                                                                                                  message:[error description]
                                                                                           preferredStyle:UIAlertControllerStyleAlert];
                                   
                                   UIAlertAction *action = [UIAlertAction actionWithTitle:@"Accept"
                                                                                    style:UIAlertActionStyleDefault
                                                                                  handler:nil];
                                   [alert addAction:action];
                                   
                                   [self presentViewController:alert animated:YES completion:nil];
                                   NSLog(@"ERROR: %@", [error description]);
//                                   [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                               }
                               
                               [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                           }];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
