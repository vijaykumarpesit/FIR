//
//  SubmitViewController.m
//  FIR
//
//  Created by Vijay on 04/12/15.
//  Copyright © 2015 Vijay. All rights reserved.
//

#import "SubmitViewController.h"
#import <Parse/Parse.h>
#import "DataSource.h"
#import "FIRAccidentMetaData.h"
#import "ImageMetaData.h"
#import "FIRImageCollectionViewCell.h"
#import "UIImage+Resize.h"
#import "TextExtractor.h"
#import "FIRFaceDetector.h"
#import "UIImageView+AFNetworking.h"
#import "SAMTextView.h"


@interface SubmitViewController () <UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *vehicleNo1;

@property (weak, nonatomic) IBOutlet UITextField *vehicleNo2;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet SAMTextView *textView;

@property (nonatomic, strong) NSMutableArray *images;

@end

@implementation SubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:NO];
    
    [self.collectionView registerClass:[FIRImageCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    _images = [[NSMutableArray alloc] init];
    FIRAccidentMetaData *metadata = self.accidentMetdata;
    
    for (ImageMetaData*imageMetaData in metadata.images) {
        switch (imageMetaData.imageType) {
            case AccidentImageTypeNumberPlate:
                [self.images addObject:imageMetaData];
                break;
            case AccidentImageTypeVictim:
                [self.images addObject:imageMetaData];
                break;
            case AccidentImageTypeOther:
                if (self.isInEditMode) {
                    [self.images addObject:imageMetaData];
                }
                break;
            default:
                if (self.isInEditMode) {
                    [self.images addObject:imageMetaData];
                }
                break;
        }
        
    }
    UIColor *borderColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];
    self.textView.layer.borderColor = borderColor.CGColor;
    self.textView.layer.borderWidth = 1.0;
    self.textView.layer.cornerRadius = 5.0;
    [self.textView setBackgroundColor:[UIColor clearColor]];
    
    if (metadata.accidentDescription) {
        self.textView.text = metadata.accidentDescription;
    } else {
        self.textView.placeholder = @"Add Description to make investigation easy";
    }
    if (metadata.vehicleNumbers.count) {
        if (metadata.vehicleNumbers.count >1) {
            self.vehicleNo1.text = metadata.vehicleNumbers.allObjects[0];
            self.vehicleNo2.text = metadata.vehicleNumbers.allObjects[1];
        } else {
            self.vehicleNo1.text = metadata.vehicleNumbers.allObjects[0];

        }
    }
    
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
- (IBAction)sumbmitAccidentReport:(id)sender {
    
    FIRAccidentMetaData *metadata = self.accidentMetdata;
    
    PFQuery *query = [PFQuery queryWithClassName:@"Accident"];
    [query whereKey:@"vehicleNumbers" containedIn:metadata.vehicleNumbers.allObjects];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (objects.count) {
            
            PFObject* accident = (PFObject *)[objects lastObject];
            accident[@"reportedByPhoneNOs"] = [NSMutableArray arrayWithObject:[[[DataSource sharedDataSource] currentUser] phoneNumber]];
            accident[@"description"] = metadata.description;

            
            NSMutableArray *spotArray = [NSMutableArray array];
            NSMutableArray *victimArray = [NSMutableArray array];
            NSMutableArray *vehicleNoArray = [NSMutableArray array];
            
            
            for (ImageMetaData*imageMetaData in metadata.images) {
                
                @autoreleasepool {
                    PFFile *file = nil;
                    
                    if (imageMetaData.isLocallyPresent) {
                        UIImage *image = [UIImage imageWithContentsOfFile:imageMetaData.filePath];
                        NSData *imageData = UIImageJPEGRepresentation(image, 0.7);
                        file = [PFFile fileWithData:imageData];
                        [file saveInBackground];
                    } else {
                        file = imageMetaData.file;
                    }
                    
                    switch (imageMetaData.imageType) {
                        case AccidentImageTypeNumberPlate:
                            [vehicleNoArray addObject:file];
                            break;
                        case AccidentImageTypeVictim:
                            [victimArray addObject:file];
                            break;
                        case  AccidentImageTypeOther:
                            [spotArray addObject:file];
                        default:
                            break;
                    }
                }
            }
            
            
            accident[@"spotImages"] = spotArray;
            accident[@"victimImages"] = victimArray;
            accident[@"vehicleNoImages"] = vehicleNoArray;
            accident[@"vehicleNumbers"] = @[self.vehicleNo1.text,self.vehicleNo2.text];
            [accident saveInBackground];
        } else {
            //Craete PF Object
            
            PFObject* accident = [PFObject objectWithClassName:@"Accident"];
            accident[@"date"] = metadata.date;
            PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:metadata.lattitude longitude:metadata.longitude];
            accident[@"geoPoint"] = geoPoint;
            accident[@"reportedByPhoneNOs"] = [NSMutableArray arrayWithObject:[[[DataSource sharedDataSource] currentUser] phoneNumber]];
            accident[@"description"] = metadata.description;

            
            NSMutableArray *spotArray = [NSMutableArray array];
            NSMutableArray *victimArray = [NSMutableArray array];
            NSMutableArray *vehicleNoArray = [NSMutableArray array];
            
            
            for (ImageMetaData*imageMetaData in metadata.images) {
                @autoreleasepool {
                    PFFile *file = nil;
                    
                    if (imageMetaData.isLocallyPresent) {
                        UIImage *image = [UIImage imageWithContentsOfFile:imageMetaData.filePath];
                        NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
                        file = [PFFile fileWithData:imageData];
                        [file saveInBackground];
                    } else {
                        file = imageMetaData.file;
                    }
                  
                    switch (imageMetaData.imageType) {
                        case AccidentImageTypeNumberPlate:
                            [vehicleNoArray addObject:file];
                            break;
                        case AccidentImageTypeVictim:
                            [victimArray addObject:file];
                            break;
                        case  AccidentImageTypeOther:
                            [spotArray addObject:file];
                        default:
                            break;
                    }
                }
            }
            
            accident[@"spotImages"] = spotArray;
            accident[@"victimImages"] = victimArray;
            accident[@"vehicleNoImages"] = vehicleNoArray;
            accident[@"vehicleNumbers"] = @[self.vehicleNo1.text,self.vehicleNo2.text];
            [accident saveInBackground];
        }
        
    }];
    
    //Replace this with good UI
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Submission Successful" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    });
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {

    
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



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.isInEditMode) {
        return  self.images.count +1;
    }
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FIRImageCollectionViewCell *cell =  (FIRImageCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell"
                                                                                                                forIndexPath:indexPath];
    UIImage *image = nil;
    if (indexPath.row < self.images.count) {
        ImageMetaData *metaData = self.images[indexPath.row];
        
        if (metaData.isLocallyPresent) {
            image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@-thumb",metaData.filePath]];
            cell.imageView.image = image;

        } else {
            NSURL *fileURL = [NSURL URLWithString:metaData.filePath];
            [cell.imageView setImageWithURL:fileURL placeholderImage:[UIImage imageNamed:@"accidentPlaceHolder"]];

        }
    } else {
        image = [UIImage imageNamed:@"placeholder_small.png"];
        cell.imageView.image = image;

    }
    return  cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - 8)/3;
    return CGSizeMake(width, width);
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
    
    FIRAccidentMetaData *metadata = self.accidentMetdata;
    metadata.images = self.images;
    
}

- (NSString *)baseFilePath {
    NSString *documentsDirectoryPayh = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return documentsDirectoryPayh;
}


//if user is cancelling the camera
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *)GetUUID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return (__bridge NSString *)string;
}

@end
