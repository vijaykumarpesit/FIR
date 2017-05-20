//
//  TabbarViewController.m
//  FIR
//
//  Created by Sachin Vas on 12/4/15.
//  Copyright © 2015 Vijay. All rights reserved.
//

#import "TabbarViewController.h"
#import "ChatTableViewController.h"

@interface TabbarViewController () <UITabBarControllerDelegate>

@end

@implementation TabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *tabBarImages = @[@"Lend", @"Borrow", @"Chat"];
    
    for (int i = 0; i < 3; i++) {
        NSString *imageName = tabBarImages[i];
        self.tabBar.items[i].image = [UIImage imageNamed:imageName];
        self.tabBar.items[i].selectedImage = [UIImage imageNamed:imageName];
    }
    
    // Do any additional setup after loading the view.
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[ChatTableViewController class]]) {
        return NO;
    } else {
        return YES;
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

@end
