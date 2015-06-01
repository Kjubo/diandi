//
//  TourMainViewController.m
//  diandi
//
//  Created by kjubo on 15/4/16.
//  Copyright (c) 2015年 kjubo. All rights reserved.
//

#import "TourMainViewController.h"
#import "ELCImagePickerController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "DPhoto.h"

@interface TourMainViewController () <ELCImagePickerControllerDelegate>
@property (nonatomic, strong) ELCImagePickerController *imagePicker;
@end

@implementation TourMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"照片+" style:UIBarButtonItemStyleDone target:self action:@selector(choosePhoto)];
}

- (void)choosePhoto{
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

#pragma mark - ELCImagePickerControllerDelegate
- (ELCImagePickerController *)imagePicker{
    if(!_imagePicker){
        _imagePicker = [[ELCImagePickerController alloc] initImagePicker];
        _imagePicker.imagePickerDelegate = self;
        _imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    }
    return _imagePicker;
}


- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info{
    [self dismissViewControllerAnimated:YES completion:nil];
    for (NSDictionary *dict in info) {
        if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto){
            if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                NSURL *imageURL = [dict objectForKey:UIImagePickerControllerReferenceURL];
                ALAssetsLibrary *alib = [[ALAssetsLibrary alloc] init];
                [alib assetForURL:imageURL resultBlock:^(ALAsset *asset) {
                    CLLocation *loc = [asset valueForProperty:ALAssetPropertyLocation];
                    NSDate *timestamp = [asset valueForProperty:ALAssetPropertyDate];
                    DPhoto *ph = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([DPhoto class]) inManagedObjectContext:self.managedObjectContext];
                    ph.latitude = @(loc.coordinate.latitude);
                    ph.longitude = @(loc.coordinate.longitude);
                    ph.createTime = timestamp;
                    ph.uri = imageURL.absoluteString;
                    ph.uuid = [[NSUUID UUID] UUIDString];
                } failureBlock:^(NSError *error) {
                    
                }];
            } else {
                NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
            }
        } else {
            NSLog(@"Uknown asset type");
        }
        NSError *error;
        [self.managedObjectContext save:&error];
        NSAssert(!error, @"%@", error);
    }
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
