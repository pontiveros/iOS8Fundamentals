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
    
    [self.imageHelper selectImageWithCompletionHandler:^(UIImage *image, NSError *error) {
        if (image) {
            [pSelf sendImageByNSURLSession2:image];
        } else {
            NSLog(@"Error: %@", [error description]);
        }
    }];
}

- (void)sendImageByNSURLConnection:(UIImage*)image
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                           }];
}

- (void)sendImageByNSURLSession:(UIImage*)image
{
    NSData *imageData = UIImageJPEGRepresentation(image, 0.6);
    
    // 1
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.HTTPMaximumConnectionsPerHost = 1;
    [config setHTTPAdditionalHeaders:@{@"Content-Type":@"application/json"}];
//    [config setHTTPAdditionalHeaders:@{@"Authorization": [Dropbox apiAuthorizationHeader]}];
    
    // 2
    NSURLSession *upLoadSession = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:nil];
    
    // for now just create a random file name, dropbox will handle it if we overwrite a file and create a new name..
    NSURL *url = [NSURL URLWithString:@"http://localhost/storemobile"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    // 3
    NSURLSessionUploadTask *uploadTask = [upLoadSession uploadTaskWithRequest:request
                                                                     fromData:imageData
                                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                                                if (!error) {
                                                                    NSString *payload = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                    NSLog(@"RESPONSE: %@", [response description]);
                                                                    NSLog(@"PAYLOAD: %@", payload);
                                                                } else {
                                                                    NSLog(@"ERROR: %@", [error description]);
                                                                }
                                                            }];
    
    // 4
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    // 5
    [uploadTask resume];
}
- (void)sendImageByNSURLSession2:(UIImage*)image
{
//    NSString *deviceID = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceID"];
//    NSString *textContent = @"This is a new note";
    
    // Build the request body
    NSString *boundary = @"-------------------123456789000000";
    NSMutableData *body = [NSMutableData data];
//    // Body part for "deviceId" parameter. This is a string.
//    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"deviceId"] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[NSString stringWithFormat:@"%@\r\n", deviceID] dataUsingEncoding:NSUTF8StringEncoding]];
//    // Body part for "textContent" parameter. This is a string.
//    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"textContent"] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[NSString stringWithFormat:@"%@\r\n", textContent] dataUsingEncoding:NSUTF8StringEncoding]];
    // Body part for the attachament. This is an image.
    NSData *imageData = UIImageJPEGRepresentation(image, 0.6);
    
    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", @"image"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Type: multipart/form-data; boundary=%@", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:[[NSString stringWithFormat:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Setup the session
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfiguration.HTTPAdditionalHeaders = @{
//                                                   @"api-key"       : @"55e76dc4bbae25b066cb",
//                                                   @"Accept"        : @"application/json",
//                                                   @"Content-Type"  : [NSString stringWithFormat:@"application/octet-stream; boundary=%@", boundary]
                                                   @"Content-Type"  : [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary]
                                                   };
    
    // Create the session
    // We can use the delegate to track upload progress
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:nil delegateQueue:nil];
    
    // Data uploading task. We could use NSURLSessionUploadTask instead of NSURLSessionDataTask if we needed to support uploads in the background
    NSURL *url = [NSURL URLWithString:@"http://localhost/storemobile"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.HTTPBody   = body;
    
    NSURLSessionDataTask *uploadTask = [session dataTaskWithRequest:request
                                                  completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                      if (!error) {
                                                          NSLog(@"RESPONSE: %@", [response description]);
                                                          NSString *payload = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                          NSLog(@"PAYLOAD: %@", payload);
                                                      } else {
                                                          NSLog(@"ERROR: %@", [error description]);
                                                      }
                                                  }];
    [uploadTask resume];
}
@end
