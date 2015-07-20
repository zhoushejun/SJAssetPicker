//
//  SJRootCollectionViewController.m
//  SJAssetPicker
//
//  Created by shejun.zhou on 15/7/4.
//  Copyright (c) 2015年 shejun.zhou. All rights reserved.
//

#import "SJRootCollectionViewController.h"
#import "SJAssetGroupsTableViewController.h"

@interface SJRootCollectionViewController ()

@property (nonatomic, strong) NSMutableArray *arrayPhotos;

@end

@implementation SJRootCollectionViewController

static NSString * const SJCollectionViewPhotoCellReuseIdentifier = @"SJCollectionViewPhotoCell";
static NSString * const SJCollectionViewAddCellReuseIdentifier = @"SJCollectionViewAddCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    _arrayPhotos = [[NSMutableArray alloc] init];
//    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:SJCollectionViewPhotoCellReuseIdentifier];
//    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:SJCollectionViewAddCellReuseIdentifier];
    
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

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_arrayPhotos count] + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = nil;
    if (indexPath.row == _arrayPhotos.count) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:SJCollectionViewAddCellReuseIdentifier forIndexPath:indexPath];

    }else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:SJCollectionViewPhotoCellReuseIdentifier forIndexPath:indexPath];

    }
    
    // Configure the cell
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _arrayPhotos.count) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SJAssetPicker" bundle:nil];
        UINavigationController *groupsVC = [storyboard instantiateViewControllerWithIdentifier:@"SJAssetPickerNavigationController"];
        
        [self presentViewController:groupsVC animated:YES completion:nil];
    }
}


@end
