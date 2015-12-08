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


@interface FIRFileViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, assign) CGFloat lattitude;
@property (nonatomic, assign) CGFloat longitude;
@property (nonatomic, strong) NSMutableSet *detectedTexts;
@property (weak, nonatomic) IBOutlet UIImageView *cameraPlaceHolder;

@property (nonatomic, strong)CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet SAMTextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addImagesTopConstraint;

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
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    tapGestureRecognizer.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    UIColor *borderColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];
    
    self.textView.layer.borderColor = borderColor.CGColor;
    self.textView.layer.borderWidth = 1.0;
    self.textView.layer.cornerRadius = 5.0;
    self.textView.placeholder = @"Please provide us some information about accident.";
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
        image = [UIImage imageWithContentsOfFile:self.images[indexPath.row]];
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
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.6);
    NSMutableString *filePath =  [NSMutableString stringWithString:[self baseFilePath]];
    [filePath appendString:@"/"];
    [filePath appendString:[self GetUUID]];
    [imageData writeToFile:filePath atomically:YES];
    [self.images addObject:filePath];
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
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation *currentLocation = newLocation;
    
    self.lattitude = currentLocation.coordinate.latitude;
    self.longitude = currentLocation.coordinate.longitude;
    

}

- (void)createAccidentObject {
    
    FIRAccidentMetaData *metadata = [[FIRAccidentMetaData alloc] init];
    metadata.date = [NSDate date];
    metadata.longitude = self.longitude;
    metadata.lattitude = self.lattitude;
    metadata.images = self.images;
    metadata.vehicleNumbers = self.detectedTexts;
    //As of now assume only one in future we need to support multiple
    
    [[DataSource sharedDataSource].accidentMetaDataArry addObject:metadata];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.destinationViewController isKindOfClass:[SubmitViewController class]]) {
        [self createAccidentObject];
        
    }
}

- (void)cameraImageViewTapped:(UITapGestureRecognizer *)reco {
  [self presentImagePicker];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [UIView animateWithDuration:0.3 animations:^{
        self.addImagesTopConstraint.constant -= 175;
    }];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView isFirstResponder]) {
        [UIView animateWithDuration:0.3 animations:^{
            self.addImagesTopConstraint.constant += 175;
        }];
        [textView resignFirstResponder];
    }
}

- (void)tapped:(UIGestureRecognizer *)gestureReconginzer {
    if ([self.textView isFirstResponder]) {
        [self textViewDidEndEditing:self.textView];
    }
}

@end
