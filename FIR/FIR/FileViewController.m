//
//  FirstViewController.m
//  FIR
//
//  Created by Vijay on 03/12/15.
//  Copyright © 2015 Vijay. All rights reserved.
//

#import "FileViewController.h"
#import "ImageViewCell.h"
#import "UIImage+Resize.h"
#import "TextExtractor.h"
#import "SubmitViewController.h"
#import "FIRAccidentMetaData.h"
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>
#import "DataSource.h"

typedef NS_ENUM(NSUInteger,ImagePickerMode) {
    
    ImagePickerModeSpot,
    ImagePickerModeVictim,
    ImagePickerModeDocument
};

@interface FileViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *spotCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *victimCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *documentCollectionView;

@property (nonatomic, strong) NSMutableArray *spotImages;
@property (nonatomic, strong) NSMutableArray *victimImages;
@property (nonatomic, strong) NSMutableArray *documentImages;

@property (nonatomic, assign)ImagePickerMode pickerMode;
@property (nonatomic, assign) CGFloat lattitude;
@property (nonatomic, assign) CGFloat longitude;
@property (nonatomic, strong) NSMutableSet *detectedTexts;

@property (nonatomic, strong)CLLocationManager *locationManager;

@end

@implementation FileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.spotCollectionView registerNib:[UINib nibWithNibName:@"ImageViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    [self.victimCollectionView registerNib:[UINib nibWithNibName:@"ImageViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    [self.documentCollectionView registerNib:[UINib nibWithNibName:@"ImageViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    
    self.victimImages = [[NSMutableArray alloc] init];
    self.documentImages = [[NSMutableArray alloc] init];
    self.spotImages = [[NSMutableArray alloc] init];
    self.detectedTexts = [[NSMutableSet alloc] init];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    
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



- (IBAction)uploadVictimImage:(id)sender {
    self.pickerMode = ImagePickerModeVictim;
    [self presentImagePicker];
}

- (IBAction)uploadSpotImage:(id)sender {
    self.pickerMode = ImagePickerModeSpot;
    [self presentImagePicker];

}

- (IBAction)uploadDocumentImage:(id)sender {
    self.pickerMode = ImagePickerModeDocument;
    [self presentImagePicker];

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (collectionView == self.spotCollectionView) {
        return self.spotImages.count;
    } else if(collectionView == self.victimCollectionView) {
        return self.victimImages.count;
    } else if(collectionView ==  self.documentCollectionView) {
        return self.documentImages.count;
    }
    else return 1;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
   ImageViewCell *cell =  (ImageViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    if (collectionView == self.spotCollectionView) {
        cell.imageView.image = [UIImage imageWithContentsOfFile:self.spotImages[indexPath.row]];
    
    } else if(collectionView == self.victimCollectionView) {
        cell.imageView.image = [UIImage imageWithContentsOfFile:self.victimImages[indexPath.row]];

        
    } else if(collectionView ==  self.documentCollectionView) {
        cell.imageView.image = [UIImage imageWithContentsOfFile:self.documentImages[indexPath.row]];
 
    }
    
    return  cell;
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
    
    switch (self.pickerMode) {
        case ImagePickerModeSpot:
            [self.spotImages addObject:filePath];
            [self.spotCollectionView reloadData];
            break;
            
        case ImagePickerModeVictim: {
            [self.victimImages addObject:filePath];
            [self.victimCollectionView reloadData];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSString *text = [TextExtractor textFromImage:image];
                [self.detectedTexts addObject:text];
            });
        }
            break;
            
        case ImagePickerModeDocument:
            [self.documentImages addObject:filePath];
            [self.documentCollectionView reloadData];
            
            break;
            
        default:
            break;
    }
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
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    self.lattitude = currentLocation.coordinate.latitude;
    self.longitude = currentLocation.coordinate.longitude;
    

}

- (void)createAccidentObject {
    
    FIRAccidentMetaData *metadata = [[FIRAccidentMetaData alloc] init];
    metadata.date = [NSDate date];
    metadata.longitude = self.longitude;
    metadata.lattitude = self.lattitude;
    metadata.spotImages = self.spotImages;
    metadata.victimImages = self.victimImages;
    metadata.documentsImages = self.documentImages;
    metadata.vehicleNumbers = self.detectedTexts;
    //As of now assume only one in future we need to support multiple
    
    [[DataSource sharedDataSource].accidentMetaDataArry addObject:metadata];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.destinationViewController isKindOfClass:[SubmitViewController class]]) {
        [self createAccidentObject];
        
    }
}

@end
