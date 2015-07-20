//
//  UIMemoryManagementVC.m
//  iOSWorkshop
//
//  Created by Pedro Ontiveros on 7/13/15.
//  Copyright (c) 2015 Pedro Ontiveros. All rights reserved.
//

#import "UIMemoryManagementVC.h"
#import "NSCustomer.h"

@interface UIMemoryManagementVC ()
{
    NSMutableString *mutableLabel;
}

@end

@implementation UIMemoryManagementVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Memory Management";
    mutableLabel = [[NSMutableString alloc] init];
    [mutableLabel appendString:@"Message from Extension."];

    // Do any additional setup after loading the view.
    
    ////////    ////////    ////////    ////////    ////////    ////////
    // If you want to see a deadlock, please uncomment next code
//    dispatch_sync(dispatch_get_main_queue(), ^{
//        [self showAlert];
//    });
    // Submits a block to a dispatch queue for synchronous execution.
    // Unlike dispatch_async, this function does not return until the block has finished.
    // Calling this function and targeting the current queue results in deadlock.
    ////////    ////////    ////////    ////////    ////////    ////////
}

- (void)dealloc
{
    [mutableLabel release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                    message:@"Deadlock working on..."
                                                   delegate:nil
                                          cancelButtonTitle:@"Accept"
                                          otherButtonTitles:nil];
    
    [alert show];
    [alert release];
}

- (IBAction)onTouchArray:(id)sender
{
//    [self arrayAllocation];
//    [self arrayFactory];
//    [self mutableArrayMemManagement];
//    [self circularReferenceMutableArray];
}

- (IBAction)onTouchSortingArray:(id)sender
{
//    [self testSortNSArrayWithNumbers];
//    [self sortNSArrayStringWithSelector];
    [self sortEntityArray];
    NSLog(@"Mutable String message: %@", mutableLabel);
//    [self showAlert];
}

- (IBAction)onTouchAutoreleasePool:(id)sender
{
    NSMutableString *message = nil;
    
    @autoreleasepool {
        message = [[[NSMutableString alloc] init] autorelease]; // message will be released after this block.
        [message appendString:@"Message from Autorelease pool."];
        NSLog(@"Message: %@", message);
    }
    
    NSLog(@"Message to delay the processor activity.");
    NSLog(@"Message: %@", message); // What will happen here ? (will crash!)
}

- (void)arrayAllocation
{
    NSString *p1 = @"Person 1";
    NSString *p2 = @"Person 2";
    NSString *p3 = @"Person 3";
    
    NSArray *arr = [[NSArray alloc] initWithObjects:p1, p2, p3, p1, nil];
    NSSet   *set = [[NSSet alloc] initWithObjects:p1, p2, p3, p1, nil];
    
    NSLog(@"NSArray count: %ld", [arr count]);
    NSLog(@"NSSet count: %ld", [set count]);
    
    for (NSString *item in arr) {
        NSLog(@"%@", item);
    }
    
    for (NSString *i in set) {
        NSLog(@"%@", i);
    }
    
    [arr release];
    [set release];

}

- (void)arrayFactory
{
    __block NSArray *arr = nil;
    
    NSString *person1 = @"perosn 1";
    NSString *person2 = @"person 2";
    NSString *person3 = @"person 3";
    
    arr = [NSArray arrayWithObjects:person1, person2, person3, nil];
    NSLog(@"NSArray factory: %ld", arr.count);
    
    // [arr release]; // Why I don't have to do this ?
    // Please explain it!
    
    NSLog(@"Array factory retain count: %ld", [arr retainCount]);
    
    dispatch_queue_t serialQueue1 = dispatch_queue_create("com.qbxsoft.mobile1", DISPATCH_QUEUE_SERIAL);

    dispatch_async(serialQueue1, ^{
        NSLog(@"Here we go ...");
        NSLog(@"Array factory retain count: %ld", [arr retainCount]);
    });
}

- (void)mutableArrayMemManagement
{
    NSMutableString *str1 = [[NSMutableString alloc] init]; // retain count 1
    NSMutableString *str2 = [[NSMutableString alloc] init];
    NSMutableString *str3 = [[NSMutableString alloc] init];
    
    NSMutableArray *arr1 = [[NSMutableArray alloc] init];
    
    [str1 appendFormat:@"person 1"];
    [str2 appendFormat:@"person 2"];
    [str3 appendFormat:@"person 3"];
    
    [arr1 addObject:str1]; // increment retainCount str1
    [arr1 addObject:str2]; // increment retainCount str2
    [arr1 addObject:str3]; // increment retainCount str3
    
    NSLog(@"str1 retainCount: %ld", [str1 retainCount]); // ?
    NSLog(@"str2 retainCount: %ld", [str2 retainCount]); // ?
    NSLog(@"str3 retainCount: %ld", [str3 retainCount]); // ?
    
    [str1 release];
    [str2 release];
    [str3 release];
    
    NSLog(@"str1 retainCount: %ld", [str1 retainCount]);
    NSLog(@"str2 retainCount: %ld", [str2 retainCount]);
    NSLog(@"str3 retainCount: %ld", [str3 retainCount]);
    
    [arr1 removeAllObjects];
    [arr1 release];
    
//    NSLog(@"str1 retainCount: %ld", [str1 retainCount]); // this will work ?
//    NSLog(@"str2 retainCount: %ld", [str2 retainCount]); // this will work ?
//    NSLog(@"str3 retainCount: %ld", [str3 retainCount]); // this will work ?
}

- (void)circularReferenceMutableArray
{
    NSMutableArray *arr1 = [[NSMutableArray alloc] init];
    NSMutableArray *arr2 = [[NSMutableArray alloc] init];
    
    [arr1 addObject:arr2];
    [arr2 addObject:arr1];
    
    NSLog(@"arr1 retainCount: %ld", [arr1 retainCount]); // retain count ?
    NSLog(@"arr2 retainCount: %ld", [arr2 retainCount]); // retain count ?
    
    [arr1 release];
    [arr2 release];
}

- (void)testSortNSArrayWithNumbers
{
    int max = 100;
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i = 0; i < max; i++) {
        [arr addObject:[NSNumber numberWithInt:rand() / 900000]];
    }
    
    [self printNumbers:arr];
    [self sortNSMutableArrayBySortDescriptor:arr];
    [self sortNSMutableArrayBySelector:arr];
    [self printNumbers:arr];
    
    [arr release];
}

- (void)printNumbers:(NSArray*)items
{
    for (NSNumber* item in items) {
        NSLog(@"%@", [item stringValue]);
    }
}

- (void)sortNSMutableArrayBySortDescriptor:(NSArray*)array
{
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
    NSArray *sortArray = [array sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor, nil]]; // This method creates a copy of array.
    [self printNumbers:sortArray];
    
    NSLog(@"array retain count: %ld", [array retainCount]);
    NSLog(@"sortArray retain count: %ld", [sortArray retainCount]);
}

- (void)sortNSMutableArrayBySelector:(NSArray*)array
{
    NSArray *sortArray = [array sortedArrayUsingSelector:@selector(compare:)];
    [self printNumbers:sortArray];
    NSLog(@"Finish.");
}

- (void)sortNSArrayStringWithSelector
{
    NSArray *array = @[@"Blue", @"Red", @"Black", @"Yellow", @"White", @"Brown", @"Green"];
    NSLog(@"Unsorted Array: %@", array);
    NSArray *sortedArray = [array sortedArrayUsingSelector:@selector(compare:)];
    NSLog(@"Sorted Array: %@", sortedArray);
}

- (void)sortEntityArray
{
    NSArray *sortedArray = nil;
    @autoreleasepool {
        NSMutableArray *custArray = [[NSMutableArray alloc] init];
    
        [custArray addObject:[[[NSCustomer alloc] initWithIdentification:[NSNumber numberWithInt:1] andName:@"Toshiba"] autorelease]];
        [custArray addObject:[[[NSCustomer alloc] initWithIdentification:[NSNumber numberWithInt:2] andName:@"Apple"] autorelease]];
        [custArray addObject:[[[NSCustomer alloc] initWithIdentification:[NSNumber numberWithInt:3] andName:@"Dell"] autorelease]];
        [custArray addObject:[[[NSCustomer alloc] initWithIdentification:[NSNumber numberWithInt:4] andName:@"Hewlet Packard"] autorelease]];
        [custArray addObject:[[[NSCustomer alloc] initWithIdentification:[NSNumber numberWithInt:5] andName:@"Samsung"] autorelease]];
        
        for (NSEntity *entity in custArray) {
            NSLog(@"%@", [entity description]);
        }
        
        sortedArray = [[custArray sortedArrayUsingSelector:@selector(compare:)] copy]; // where is implemented "compare:" method ?
        
        [custArray release];
    }
    
    for (NSEntity *entity in sortedArray) {
        NSLog(@"%@", [entity description]);
    }
    
    [sortedArray release];
}

/*
#pragma mark - Navigation
 
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
