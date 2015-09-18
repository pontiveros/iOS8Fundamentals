//
//  ImageHelper.m
//  DeloitteContainer
//
//  Created by Pedro Ontiveros on 9/11/15.
//  Copyright (c) 2015 Infopulse. All rights reserved.
//

#import "PickerImageHelper.h"

void (^imageCompletionHandler)(UIImage *image, NSError *error);

@implementation PickerImageHelper

- (id)initWithViewController:(UIViewController *)viewController
{
    return [self initWithViewController:viewController menuPosition:CGPointMake(0, 0)];
}

- (id)initWithViewController:(UIViewController *)viewController menuPosition:(CGPoint)point
{
    if (self = [super init]) {
        self->hostViewController = viewController;
        self.position = point;
    }
    
    return self;
}

- (void)dealloc
{
    Block_release(imageCompletionHandler);
    [super dealloc];
}

- (void)openImagePickController:(IMAGEPICKCONTROLLER_TYPE)type
{
    UIImagePickerController *picker = [[[UIImagePickerController alloc] init] autorelease];
    picker.delegate = self;
    
    switch (type) {
        case IMAGEPICKCONTROLLER_TYPE_CAMERA: {
#if TARGET_IPHONE_SIMULATOR
            picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
#else
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
#endif
        } break;
        case IMAGEPICKCONTROLLER_TYPE_GALLERY: {
            picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        } break;
        default: NSLog(@"PickerController: Unknown option.");break;
    }
    
    [self->hostViewController presentViewController:picker animated:YES completion:nil];
}

- (void)selectImageWithCompletionHandler:(void (^)(UIImage *, NSError *))completionHandler
{
    imageCompletionHandler = Block_copy(completionHandler);
    
    if ([UIAlertController class]) {
        [self selectImageByAlertController];
    } else {
        [self selectImageByActionSheet];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"info: %@", [info description]);
    assert(imageCompletionHandler);
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    dispatch_queue_t queue = dispatch_queue_create("com.deloitte.mobile.sendImage", DISPATCH_QUEUE_SERIAL);
    
    UIImage *image = [[info objectForKey:UIImagePickerControllerOriginalImage] retain];
    if (image) {
        dispatch_async(queue, ^{
            imageCompletionHandler(image, nil);
            dispatch_release(queue);
        });
    } else {
        NSLog(@"Error.");
        dispatch_async(queue, ^{
            imageCompletionHandler(nil, [[NSError alloc] initWithDomain:@"There is an error trying to get the image." code:1 userInfo:nil]);
            dispatch_release(queue);
        });
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UINavigationController
- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    
}

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController 
                    animated:(BOOL)animated
{
    
}
- (void)selectImageByAlertController
{
    UIAlertController *menuOption = [UIAlertController alertControllerWithTitle:nil
                                                                        message:nil
                                                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction    *openCamera  = [UIAlertAction actionWithTitle:@"Open Camera"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction *action) {
                                                               [self openImagePickController:IMAGEPICKCONTROLLER_TYPE_CAMERA];
                                                           }];
    
    UIAlertAction *openGallery = [UIAlertAction actionWithTitle:@"Open Gallery"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
                                                            [self openImagePickController:IMAGEPICKCONTROLLER_TYPE_GALLERY];
                                                        }];
    
    UIAlertAction  *cancelBtn = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [menuOption addAction:openCamera];
    [menuOption addAction:openGallery];
    [menuOption addAction:cancelBtn];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        [menuOption setModalPresentationStyle:UIModalPresentationPopover];
        UIPopoverPresentationController *popPresenter = [menuOption popoverPresentationController];
        popPresenter.sourceView = self->hostViewController.view;
        CGRect rect = CGRectMake((self.position.x - 5.0), (self.position.y - 5.0), 10.0, 10.0);
        popPresenter.sourceRect = rect;
    }
    
    [self->hostViewController presentViewController:menuOption animated:YES completion:nil];
}

- (void)selectImageByActionSheet
{
    UIActionSheet *actionSheet = [[[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Open Camera", @"Open Gallery", nil] autorelease];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        CGRect rect = CGRectMake((self.position.x - 5.0), (self.position.y - 5.0), 10.0, 10.0);
        [actionSheet showFromRect:rect inView:self->hostViewController.view animated:YES];
    } else {
        [actionSheet showInView:self->hostViewController.view];
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0: { [self openImagePickController:IMAGEPICKCONTROLLER_TYPE_CAMERA];  } break;
        case 1: { [self openImagePickController:IMAGEPICKCONTROLLER_TYPE_GALLERY]; } break;
        case 2: { NSLog(@"Cancel"); } break;
        default: { NSLog(@"Unknown option."); } break;
    }
}

@end
