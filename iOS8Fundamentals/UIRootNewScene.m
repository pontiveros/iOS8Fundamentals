//
//  UIRootNewScene.m
//  iOSWorkshop
//
//  Created by Pedro Ontiveros on 10/10/15.
//  Copyright © 2015 Pedro Ontiveros. All rights reserved.
//

#import "UIRootNewScene.h"
#import "VCOptimized.h"

@interface UIRootNewScene ()

@end

@implementation UIRootNewScene

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"New Scene";
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

- (IBAction)onTouchMe:(id)sender
{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Title"
//                                                    message:@"Message"
//                                                   delegate:nil
//                                          cancelButtonTitle:@"Accept"
//                                          otherButtonTitles:nil];
//    [alert show];
    // In iOS 8 and later Apple® recommends use UIAlertController, because it's the same class for popup and action sheet.
    // you just have to change the alert controller style.
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert Controller"
                                                                             message:@"Message in alert controller."
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Accept" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)openVCOptimized:(id)sender {
    VCOptimized *vc = [[VCOptimized alloc] initWithNibName:@"ViewOptimized" bundle:nil];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    NSLog(@"jajajaj... you are here ...%@", identifier);
}

@end
