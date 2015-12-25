//
//  VCOptimized.m
//  iOSWorkshop
//
//  Created by Pedro Ontiveros on 12/24/15.
//  Copyright © 2015 Pedro Ontiveros. All rights reserved.
//

#import "VCOptimized.h"

@implementation CProduct

@synthesize productName;
@synthesize productKind;
@synthesize price;
@synthesize stock;

- (NSString*)value {
    return [NSString stringWithFormat:@"%@ (%@) : $ %@", self.productName, self.productKind, [self.price description]];
}

@end

@interface VCOptimized ()

@end

@implementation VCOptimized

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.items = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 1000; i++) {
        CProduct *product = [[CProduct alloc] init];
        product.productName = [NSString stringWithFormat:@"Product Name Order %d", i];
        product.productKind = [NSString stringWithFormat:@"kind of %d", i];
        product.price       = [NSNumber numberWithFloat:rand() / 2.0];
        [self.items addObject:product];
        NSLog(@"a new product has been added");
    }
    NSLog(@"all products have been added.");
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

- (IBAction)tapClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)readItems:(id)sender {
    
}

- (void)clearTable {
    
}

- (void)fillTable {
    
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"CellReusable";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    CProduct *p = [self.items objectAtIndex:indexPath.row];
    [cell.textLabel setText:p.productName];
    return cell;
}

@end
