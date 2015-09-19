//
//  NetworkingVC.m
//  iOSWorkshop
//
//  Created by Pedro Ontiveros on 6/13/15.
//  Copyright (c) 2015 Pedro Ontiveros. All rights reserved.
//

#import "NetworkingVC.h"
#import "UIPingVC.h"
#import "WebViewContainer.h"
#import "PickerImageHelper.h"


@interface NetworkingVC ()

@end

@implementation NetworkingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Files & Networking";
#if TARGET_IPHONE_SIMULATOR
    self.stringURL = @"http://localhost/uploadfiledashboard/uploadfile.php";
#else
    self.stringURL = @"http://192.168.1.27/uploadfiledashboard/uploadfile.php";
#endif
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

- (IBAction)onTouchPing:(id)sender
{
    UIPingVC *vc = [[UIPingVC alloc] initWithNibName:@"UIPingView" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onTouchWKWebView:(id)sender
{
    WebViewContainer *wvc = [[WebViewContainer alloc] initWithNibName:@"WebViewContainer" bundle:nil];
    [self.navigationController pushViewController:wvc animated:YES];
}

- (IBAction)onTouchUpload:(id)sender
{
    self.imageHelper = [[PickerImageHelper alloc] initWithViewController:self];
    __weak NetworkingVC *pSelf = self;
    __weak UIButton *button = (UIButton*)sender;
    
    [self.imageHelper selectImageWithCompletionHandler:^(UIImage *image, NSError *error) {
        if (image) {
            if (button.tag == 1) {
                [pSelf sendImageByNSURLSession:image];
            } else {
                [pSelf sendImageByNSURLConnection:image];
            }
        } else {
            NSLog(@"Error: %@", [error description]);
        }
    }];
}

- (void)sendImageByNSURLConnection:(UIImage*)image
{
    NSData   *imageData = UIImageJPEGRepresentation(image, .6);
    NSString   *boudary = @"0xKhTmLbOuNdArY";
    
    NSAssert(imageData, @"Image data should not be null.");
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30.0];
    [request setHTTPMethod:@"POST"];
    
    // Set Content-Type in HTTP Header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boudary];
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    // Post Body
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boudary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"uploadfile\";filename=\"image.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Type: image/jpeg\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:imageData];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boudary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body]; // Set body to Request
    [request setURL:[NSURL URLWithString:self.stringURL]];
    
    __weak NetworkingVC *pSelf = self;
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (!error) {
                                   NSString *payload = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                   NSLog(@"RESPONSE PAYLOAD: %@", payload);
                               } else {
                                   NSLog(@"ERROR: %@", [error description]);
                               }
                               
                               UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Network"
                                                                                              message:@"Connection has finished."
                                                                                       preferredStyle:UIAlertControllerStyleAlert];
                               
                               UIAlertAction *action = [UIAlertAction actionWithTitle:@"Accept"
                                                                                style:UIAlertActionStyleDefault
                                                                              handler:nil];
                               [alert addAction:action];
                               [pSelf presentViewController:alert animated:YES completion:nil];
                           }];
}

- (void)sendImageByNSURLSession:(UIImage*)image
{
    // Build the request body
    NSString *boundary  = @"-------------------0xB0und4ry7657234";
    NSData  *imageData  = UIImageJPEGRepresentation(image, 0.6);
    NSAssert(imageData, @"Image data should not be null.");
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"uploadfile\"; filename=\"image.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Type: image/jpeg\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:imageData];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Setup the session
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfiguration.HTTPAdditionalHeaders = @{@"Content-Type":[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary]};
    
    // Create the session
    // We can use the delegate to track upload progress
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:nil delegateQueue:nil];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:self.stringURL]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];
  
    __weak NetworkingVC *pSelf = self;
    NSURLSessionDataTask *uploadTask = [session dataTaskWithRequest:request
                                                  completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                      if (!error) {
                                                          NSLog(@"RESPONSE: %@", [response description]);
                                                          NSString *payload = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                          NSLog(@"PAYLOAD: %@", payload);
                                                      } else {
                                                          NSLog(@"ERROR: %@", [error description]);
                                                      }
                                                      UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Upload by NSURLSession"
                                                                                                                     message:@"Upload has been finished."
                                                                                                              preferredStyle:UIAlertControllerStyleAlert];
                                                      
                                                      UIAlertAction *action = [UIAlertAction actionWithTitle:@"Accept"
                                                                                                       style:UIAlertActionStyleDefault
                                                                                                     handler:nil];
                                                      [alert addAction:action];
                                                      
                                                      [pSelf presentViewController:alert animated:YES completion:nil];
                                                  }];
    [uploadTask resume];
}
@end
