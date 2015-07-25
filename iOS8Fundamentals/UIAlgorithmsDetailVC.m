//
//  UIAlgorithmsDetailVC.m
//  iOSWorkshop
//
//  Created by Pedro Ontiveros on 7/24/15.
//  Copyright (c) 2015 Pedro Ontiveros. All rights reserved.
//

#import "UIAlgorithmsDetailVC.h"


/*********************** NSString Caterory ***********************/
@interface NSString (CustomComparator)

- (NSComparisonResult)compareCustom:(NSString*)value;
- (NSComparisonResult)compareByLength:(NSString*)value;
@end

@implementation NSString (CustomComparator)
- (NSComparisonResult)compareCustom:(NSString*)value
{
    return [self compare:value] * -1;
}

- (NSComparisonResult)compareByLength:(NSString*)value
{
    return (self.length > value.length);
}

@end
/*****************************************************************/

@interface UIAlgorithmsDetailVC ()

@end

@implementation UIAlgorithmsDetailVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    switch (self.type) {
        case UIDETAIL_TYPE_A: {
            NSArray *tmp = @[@"New York", @"Boston", @"Chicago", @"Washington", @"San Antonio", @"Austin", @"Los Angeles", @"San Francisco", @"Miami", @"Jacksonville", @"Detroit", @"Indiana", @"Houston", @"Las Vegas", @"San Diego", @"Orlando", @"Cupertino", @"Seattle", @"Redmond", @"Denver", @"Atlanta"];
            
            self.items   = [tmp sortedArrayUsingSelector:@selector(compareByLength:)];
            self.options = @[@"By Length", @"Alphabetical", @"Alphabetical Reverse"];
        } break;
        case UIDETAIL_TYPE_B: {
            
        } break;
        default: {
            
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateTableView
{
    switch (self.sortBy) {
        case SORT_BY_ALPHABETICAL:         self.items = [self.items sortedArrayUsingSelector:@selector(compare:)];       break;
        case SORT_BY_ALPHABETICAL_REVERSE: self.items = [self.items sortedArrayUsingSelector:@selector(compareCustom:)]; break;
        case SORT_BY_INDEX:
        default: self.items = [self.items sortedArrayUsingSelector:@selector(compareByLength:)]; break;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tableView reloadData];
    });
}

#pragma mark - UITableViewControllerDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = self.items[indexPath.row];
    
    return cell;
}

#pragma mark - UIPickerViewDelegate
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.options[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (row) {
        case 0:  self.sortBy = SORT_BY_INDEX;                break;
        case 1:  self.sortBy = SORT_BY_ALPHABETICAL;         break;
        case 2:  self.sortBy = SORT_BY_ALPHABETICAL_REVERSE; break;
        default: self.sortBy = SORT_BY_INDEX;                break;
    }
    [self updateTableView];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.options.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

@end

