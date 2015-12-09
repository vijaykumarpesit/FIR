//
//  FirstViewController.m
//  FIR
//
//  Created by Vijay on 03/12/15.
//  Copyright © 2015 Vijay. All rights reserved.
//

#import "FIRFileViewController.h"
#import "FIRImageCollectionViewCell.h"
#import "UIImage+Resize.h"
#import "TextExtractor.h"
#import "SubmitViewController.h"
#import "FIRAccidentMetaData.h"
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>
#import "DataSource.h"
#import "FIRFileCollectionViewFooter.h"
#import "SAMTextView.h"
#import "ImageMetaData.h"
#import "UIImage+Resize.h"
#import "FIRFaceDetector.h"


@interface FIRFileViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate, UITextViewDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, assign) CGFloat lattitude;
@property (nonatomic, assign) CGFloat longitude;
@property (nonatomic, strong) NSMutableSet *detectedTexts;
@property (weak, nonatomic) IBOutlet UIImageView *cameraPlaceHolder;

@property (nonatomic, strong)CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet SAMTextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addImagesTopConstraint;
@property (nonatomic, strong) UIToolbar *toolBar;
@property (nonatomic, strong) UIAlertView *alertView;

@end

@implementation FIRFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerClass:[FIRImageCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    self.images = [[NSMutableArray alloc] init];
    self.detectedTexts = [[NSMutableSet alloc] init];
    UITapGestureRecognizer *tapReco = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cameraImageViewTapped:)];
    [self.cameraPlaceHolder addGestureRecognizer:tapReco];
    self.title = @"File FIR";
 
    UIColor *borderColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];
    
    self.textView.layer.borderColor = borderColor.CGColor;
    self.textView.layer.borderWidth = 1.0;
    self.textView.layer.cornerRadius = 5.0;
    self.textView.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f];
    self.textView.placeholder = @"Please provide us some information about accident.";
    
    
    self.toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    self.toolBar.barStyle = UIBarStyleBlackOpaque;
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(btnClickedDone:)];
    [self.toolBar setItems:[NSArray arrayWithObject:btnDone]];

}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.collectionView.hidden = self.images.count > 0 ? NO : YES;
    self.cameraPlaceHolder.hidden = self.images.count > 0 ? YES : NO;

}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





- (IBAction)uploadImage:(id)sender {
    [self presentImagePicker];

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.images.count > 0) {
        return self.images.count +1;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
   FIRImageCollectionViewCell *cell =  (FIRImageCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell"
                                                                                                               forIndexPath:indexPath];
    UIImage *image = nil;
    if (indexPath.row < self.images.count) {
        ImageMetaData *metaData = self.images[indexPath.row];
        image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@-thumb",metaData.filePath]];
    } else {
        image = [UIImage imageNamed:@"placeholder_small.png"];
    }
    cell.imageView.image = image;
    return  cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - 8)/3;
    return CGSizeMake(width, width);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.images.count) {
        [self presentImagePicker];
    }
}

- (void)presentImagePicker {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = NO;
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo: (NSDictionary *)info
{
    // Access the uncropped image from info dictionary
    NSMutableString *filePath =  [NSMutableString stringWithString:[self baseFilePath]];
    [filePath appendString:@"/"];
    [filePath appendString:[self GetUUID]];
    
    ImageMetaData *metaData = [[ImageMetaData alloc] init];
    metaData.filePath = filePath;
    
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    UIImage *thumbnailImage = [image thumbnailImage:200 interpolationQuality:0];
    NSData *thumbnailData = UIImageJPEGRepresentation(thumbnailImage, 0.6);
    [thumbnailData writeToFile:[NSString stringWithFormat:@"%@-thumb",filePath] atomically:YES];
    
    //Do it parallely
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *imageData = UIImageJPEGRepresentation(image, 0.6);
        [imageData writeToFile:filePath atomically:YES];
    });
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *text = [TextExtractor textFromImage:thumbnailImage];
        if (text && text.length > 5 && metaData.imageType != AccidentImageTypeVictim) {
            metaData.text = text;
            metaData.imageType = AccidentImageTypeNumberPlate;

        }
    });
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        BOOL isFacePresent =  [FIRFaceDetector isFaceDetectedInImage:image];
        if (isFacePresent) {
            metaData.imageType = AccidentImageTypeVictim;
        }
    });
    metaData.isLocallyPresent = YES;
    [self.images addObject:metaData];
    self.collectionView.hidden = NO;
    [self.collectionView reloadData];
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.images.count inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}


//if user is cancelling the camera
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *)baseFilePath {
    NSString *documentsDirectoryPayh = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return documentsDirectoryPayh;
}

- (NSString *)GetUUID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return (__bridge NSString *)string;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    if (!self.alertView) {
        self.alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [self.alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    self.alertView = nil;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation *currentLocation = newLocation;
    
    self.lattitude = currentLocation.coordinate.latitude;
    self.longitude = currentLocation.coordinate.longitude;
    

}

- (FIRAccidentMetaData *)createAccidentObject {
    
    FIRAccidentMetaData *metadata = [[FIRAccidentMetaData alloc] init];
    metadata.date = [NSDate date];
    metadata.longitude = self.longitude;
    metadata.lattitude = self.lattitude;
    metadata.images = self.images;
    metadata.vehicleNumbers = self.detectedTexts;
    metadata.accidentDescription = self.textView.text;
    
    
    //As of now assume only one in future we need to support multiple
    
    [[DataSource sharedDataSource].accidentMetaDataArry addObject:metadata];
    return metadata;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.destinationViewController isKindOfClass:[SubmitViewController class]]) {
        SubmitViewController *submitVC = (SubmitViewController *)segue.destinationViewController;
        submitVC.accidentMetdata = [self createAccidentObject];
        
        if ([self.textView isFirstResponder]) {
            self.addImagesTopConstraint.constant += 220;
            [UIView animateWithDuration:0.3 animations:^{
                [self.view layoutIfNeeded];
            }];
            [self.textView resignFirstResponder];
        }
    }
}

- (void)cameraImageViewTapped:(UITapGestureRecognizer *)reco {
  [self presentImagePicker];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [textView setInputAccessoryView:self.toolBar];
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.addImagesTopConstraint.constant -= 220;
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
    
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView isFirstResponder]) {
        self.addImagesTopConstraint.constant += 220;
        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];
        }];
        [textView resignFirstResponder];
    }
}

- (void)btnClickedDone:(id)sender {
    
    if ([self.textView isFirstResponder]) {
        self.addImagesTopConstraint.constant += 220;
        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];
        }];
        [self.textView resignFirstResponder];
    }
}

@end
