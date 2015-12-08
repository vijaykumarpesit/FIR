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



@interface SubmitViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *vehicleNo1;

@property (weak, nonatomic) IBOutlet UITextField *vehicleNo2;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *images;
@end

@implementation SubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:NO];
    self.vehicleNo1.text = @"KA-03-HY-3266";
    
    [self.collectionView registerClass:[FIRImageCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];

    self.images = [[NSMutableArray alloc] init];
    FIRAccidentMetaData *metadata = [[[DataSource sharedDataSource] accidentMetaDataArry] firstObject];
    
    for (ImageMetaData*imageMetaData in metadata.images) {
        switch (imageMetaData.imageType) {
            case AccidentImageTypeNumberPlate:
                [self.images addObject:imageMetaData];
                break;
            case AccidentImageTypeVictim:
                [self.images addObject:imageMetaData];
                break;
            default:
                break;
        }
   
    }
    
    // Do any additional setup after loading the view.
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
    
    FIRAccidentMetaData *metadata = [[[DataSource sharedDataSource] accidentMetaDataArry] firstObject];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Accident"];
    [query whereKey:@"vehicleNumbers" containedIn:metadata.vehicleNumbers.allObjects];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (objects.count) {
            
            //Already found update the item//TODO
            
        } else {
            //Craete PF Object
            
            PFObject* accident = [PFObject objectWithClassName:@"Accident"];
            accident[@"date"] = metadata.date;
            PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:metadata.lattitude longitude:metadata.longitude];
            accident[@"geoPoint"] = geoPoint;
            accident[@"reportedByPhoneNOs"] = [NSMutableArray arrayWithObject:[[[DataSource sharedDataSource] currentUser] phoneNumber]];
            
            
            NSMutableArray *spotArray = [NSMutableArray array];
            NSMutableArray *victimArray = [NSMutableArray array];
            NSMutableArray *vehicleNoArray = [NSMutableArray array];
            
            
            for (ImageMetaData*imageMetaData in metadata.images) {
                @autoreleasepool {
                    UIImage *image = [UIImage imageWithContentsOfFile:imageMetaData.filePath];
                    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
                    PFFile *file = [PFFile fileWithData:imageData];
                    [file saveInBackground];
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


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FIRImageCollectionViewCell *cell =  (FIRImageCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell"
                                                                                                                forIndexPath:indexPath];
    UIImage *image = nil;
    ImageMetaData *metaData = self.images[indexPath.row];
    image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@-thumb",metaData.filePath]];
    
    cell.imageView.image = image;
    return  cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - 8)/3;
    return CGSizeMake(width, width);
}

@end
