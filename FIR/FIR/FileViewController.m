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

typedef NS_ENUM(NSUInteger,ImagePickerMode) {
    
    ImagePickerModeSpot,
    ImagePickerModeVictim,
    ImagePickerModeDocument
};

@interface FileViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *spotCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *victimCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *documentCollectionView;

@property (nonatomic, strong) NSMutableArray *spotImages;
@property (nonatomic, strong) NSMutableArray *victimImages;
@property (nonatomic, strong) NSMutableArray *documentImages;

@property (nonatomic, assign)ImagePickerMode pickerMode;

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
    
    [self.navigationController.navigationBar setHidden:YES];
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
            
        case ImagePickerModeVictim:
            [self.victimImages addObject:filePath];
            [self.victimCollectionView reloadData];

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

- (IBAction)submitReport:(id)sender {

}

@end
