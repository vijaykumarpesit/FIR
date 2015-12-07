//
//  FirstViewController.m
//  FIR
//
//  Created by Vijay on 03/12/15.
//  Copyright © 2015 Vijay. All rights reserved.
//

#import "FIRFileViewController.h"
#import "ImageViewCell.h"
#import "UIImage+Resize.h"
#import "TextExtractor.h"
#import "SubmitViewController.h"
#import "FIRAccidentMetaData.h"
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>
#import "DataSource.h"


@interface FIRFileViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, assign) CGFloat lattitude;
@property (nonatomic, assign) CGFloat longitude;
@property (nonatomic, strong) NSMutableSet *detectedTexts;
@property (weak, nonatomic) IBOutlet UIImageView *cameraPlaceHolder;

@property (nonatomic, strong)CLLocationManager *locationManager;

@end

@implementation FIRFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"ImageViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ImageViewCell" bundle:nil]  forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    self.images = [[NSMutableArray alloc] init];
    self.detectedTexts = [[NSMutableSet alloc] init];
    UITapGestureRecognizer *tapReco = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cameraImageViewTapped:)];
    [self.cameraPlaceHolder addGestureRecognizer:tapReco];
    self.title = @"File FIR";
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
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
   ImageViewCell *cell =  (ImageViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
   cell.imageView.image = [UIImage imageWithContentsOfFile:self.images[indexPath.row]];
    return  cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width/3;
    return CGSizeMake(width, width);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width/3;
    return CGSizeMake(width, width);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    ImageViewCell *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    reusableView.imageView.image = [UIImage imageNamed:@"placeholder_large.png"];
    return  reusableView;
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

@end
