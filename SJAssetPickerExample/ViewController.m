//
//  ViewController.m
//  SJAssetPickerExample
//
//  Created by shejun.zhou on 15/8/9.
//  Copyright (c) 2015年 shejun.zhou. All rights reserved.
//

#import "ViewController.h"
#import "SJAssetGroupsTableViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

#define kUpdateAssets @"UpdateAssets"

static NSString * const SJCollectionViewPhotoCellReuseIdentifier = @"SJCollectionViewPhotoCell";
static NSString * const SJCollectionViewAddCellReuseIdentifier = @"SJCollectionViewAddCell";

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *arrayAssets;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _arrayAssets = [[NSMutableArray alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadAssets:) name:kUpdateAssets object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_arrayAssets count] + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = nil;
    if (indexPath.row == _arrayAssets.count) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:SJCollectionViewAddCellReuseIdentifier forIndexPath:indexPath];
        
    }else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:SJCollectionViewPhotoCellReuseIdentifier forIndexPath:indexPath];
        ALAsset *result = [_arrayAssets objectAtIndex:indexPath.row];
        UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];
        imageView.image = [UIImage imageWithCGImage:result.thumbnail];
    }
    
    // Configure the cell
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _arrayAssets.count) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SJAssetPicker" bundle:nil];
        UINavigationController *groupsVC = [storyboard instantiateViewControllerWithIdentifier:@"SJAssetPickerNavigationController"];
        
        [self presentViewController:groupsVC animated:YES completion:nil];
    }
}

- (void)uploadAssets:(NSNotification *)notification {
    NSLog(@"notification:%@", notification);
    [_arrayAssets removeAllObjects];
    _arrayAssets = [[NSMutableArray alloc] initWithArray:notification.object];
    [self.collectionView reloadData];
}

@end
