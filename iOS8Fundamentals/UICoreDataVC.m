//
//  UICoreDataVC.m
//  iOSWorkshop
//
//  Created by Pedro Ontiveros on 10/4/15.
//  Copyright © 2015 Pedro Ontiveros. All rights reserved.
//

#import "UICoreDataVC.h"
#import "QSyncManager.h"


@interface UICoreDataVC ()

@end


@implementation UICoreDataVC

- (id)initWithViewMode:(UICOREDATA_VIEW_MODE)mode
{
    if (self = [super init]) {
        self.mode = mode;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    switch (self.mode) {
        case UICOREDATA_MODE_ROOT: {
            self.title = @"Core Data";
            self.items = [NSArray arrayWithObjects:@{@"label" : @"Customer List", @"command" : @"openCustomerList"},
                                                   @{@"label" : @"Moc List", @"command" : @"openMocList"}, nil];
        } break;
        case UICOREDATA_MODE_MOCLIST: {
            self.title = @"Moc List";
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sync"
                                                                                      style:UIBarButtonItemStylePlain
                                                                                     target:self
                                                                                     action:@selector(syncMoc)];
            [self loadFromURL:@"http://localhost/getmoclist?size=50"];
        } break;
        case UICOREDATA_MODE_CUSTOMER: self.title = @"Customer";  break;
    }
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshList)
                                                 name:@"NSManagedObjectContextDidSaveNotification"
                                                object:nil];
}

- (void)refreshList
{
    NSLog(@"wowowowowow *************************");
}

- (void)syncMoc
{
    QSyncManager *sync = [[QSyncManager alloc] initWithMode:SYNC_MODE_MOC];
    [sync downloadDataFrom:@"http://localhost/getmoclist?size=50"];
}

- (void)loadFromURL:(NSString*)urlString
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfiguration.HTTPAdditionalHeaders = @{@"Content-Type":[NSString stringWithFormat:@"application/json;"]};
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    
    NSURLSessionDataTask *uploadTask = [session dataTaskWithRequest:request
                                                  completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                      if (data) {
                                                          NSError *err = nil;
                                                          NSArray *result = [NSJSONSerialization JSONObjectWithData:data
                                                                                                            options:NSJSONReadingMutableContainers
                                                                                                              error:&err];
                                                          if (err == nil) {
                                                              self.items = [NSArray arrayWithArray:result];
                                                              NSLog(@"%@", result);
                                                              
                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                  [self.tableView reloadData];
                                                              });
                                                              
                                                          }
                                                          
                                                      } else {
                                                          NSLog(@"ERROR: WTF ?");
                                                      }
                                                  }];
    
    [uploadTask resume];

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.mode) {
        case UICOREDATA_MODE_ROOT: {
            NSLog(@"mode root");
            NSString *command = [[self.items objectAtIndex:indexPath.row] objectForKey:@"command"];
            SEL   signatureSel = NSSelectorFromString(command);
            
            if ([self respondsToSelector:signatureSel]) {
                NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:signatureSel]];
                [invocation setTarget:self];
                [invocation setSelector:signatureSel];
                [invocation invoke];
            }
        } break;
        case UICOREDATA_MODE_CUSTOMER: {
            
        } break;
        case UICOREDATA_MODE_MOCLIST: {
            
        } break;
    }
}

- (void)openMocList
{
    UICoreDataVC *vc = [[UICoreDataVC alloc] initWithViewMode:UICOREDATA_MODE_MOCLIST];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)openCustomerList
{
    UICoreDataVC *vc = [[UICoreDataVC alloc] initWithViewMode:UICOREDATA_MODE_CUSTOMER];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UITableViewCell*)cellForModeViewRoot:(UITableView *)tableView forIndexPath:(NSIndexPath*)indexPath
{
    static NSString *cellIdentifier = @"defaultCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [self.items[indexPath.row] objectForKey:@"label"];

    return cell;
}

- (UITableViewCell*)cellForModeViewCustomer:(UITableView *)tableView forIndexPath:(NSIndexPath*)indexPath
{
    return nil;
}

- (UITableViewCell*)cellForModeViewMocList:(UITableView *)tableView forIndexPath:(NSIndexPath*)indexPath
{
    static NSString *cellIdentifier = @"mocDefaultCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [self.items[indexPath.row] objectForKey:@"cus"];
    
    NSString *detail = [NSString stringWithFormat:@"ID: %@", [self.items[indexPath.row] objectForKey:@"id"]];
    cell.detailTextLabel.text = detail;
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    switch (self.mode) {
        case UICOREDATA_MODE_ROOT:     cell = [self cellForModeViewRoot:tableView forIndexPath:indexPath];     break;
        case UICOREDATA_MODE_CUSTOMER: cell = [self cellForModeViewCustomer:tableView forIndexPath:indexPath]; break;
        case UICOREDATA_MODE_MOCLIST:  cell = [self cellForModeViewMocList:tableView forIndexPath:indexPath];  break;
    }
    return cell;
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
