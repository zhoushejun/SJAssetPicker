//
//  SJAssetPickerViewController.m
//  SJAssetPicker
//
//  Created by shejun.zhou on 15/7/4.
//  Copyright (c) 2015年 shejun.zhou. All rights reserved.
//


#import "SJAssetPickerViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface SJAssetPickerViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) ALAssetsLibrary *library;
@property (nonatomic, strong) NSMutableArray *mutableArray;
@property (nonatomic, strong) NSMutableArray *imageURL;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation SJAssetPickerViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _imageURL = [[NSMutableArray alloc] init];
    _imageArray = [[NSMutableArray alloc] init];
    [self loadAllPictures];
}

- (void)viewWillDisappear:(BOOL)animated {
    [_mutableArray removeAllObjects];
    [_imageURL removeAllObjects];
    [_imageArray removeAllObjects];
    _mutableArray = nil;
    _imageURL = nil;
    _imageArray = nil;
    _library = nil;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSLog(@"%@", cachPath);
        
        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
        NSLog(@"files :%ld",(long)[files count]);
        for (NSString *p in files) {
            NSError *error;
            NSString *path = [cachPath stringByAppendingPathComponent:p];
            if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
            }
        }
    });
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_imageURL count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellectionViewCellIdentifier" forIndexPath:indexPath];
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];
    
    if (_imageArray.count > indexPath.row) {
        UIImage *image = _imageArray[indexPath.row];
        imageView.image = image;
    }else {
        NSURL *url = _imageURL[indexPath.row];
        [_library assetForURL:url
                  resultBlock:^(ALAsset *asset) {
                      NSLog(@"row:%ld---url:%@", (long)indexPath.row, url.description);
                      UIImage *image = [UIImage imageWithCGImage: asset.thumbnail];
                      if (!image) {
                          image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
                      }
                      imageView.image = image;
                      if (image) {
                          [_imageArray addObject:image];
                      }
                  }
                 failureBlock:^(NSError *error){
                     NSLog(@"operation was not successfull!");
                 }];
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@", _imageURL[indexPath.row]);
}

-(void)loadAllPictures{
    //    __block NSMutableArray *assetURLArray = [[NSMutableArray alloc] init];
    _library = [[ALAssetsLibrary alloc] init];
    
    void (^assetEnumerator)( ALAsset *, NSUInteger, BOOL *) = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if(result != nil) {
            if([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                NSURL *url= (NSURL*) [[result defaultRepresentation]url];
                UIImage *image = [UIImage imageWithCGImage: result.thumbnail];
                if (!image) {
                    image = [UIImage imageWithCGImage:[[result defaultRepresentation] fullScreenImage]];
                }
                if (image) {
                    [_imageArray addObject:image];
                }
                if (![_imageURL containsObject:url]) {
                    [_imageURL addObject:url];
                    [self.collectionView reloadData];
                }
                //                [assetURLArray addObject:[result valueForProperty:ALAssetPropertyURLs]];
            }
        }
    };
    
    void (^ assetGroupEnumerator) ( ALAssetsGroup *, BOOL *)= ^(ALAssetsGroup *group, BOOL *stop) {
        if(group != nil) {
            NSString *strName = [NSString stringWithFormat:@"%@", [group valueForProperty:@"ALAssetsGroupPropertyName"]];
            if ([strName isEqualToString:self.title]) {
                [group enumerateAssetsUsingBlock:assetEnumerator];
            }
        }
    };
    
    [_library enumerateGroupsWithTypes:ALAssetsGroupAll
                            usingBlock:assetGroupEnumerator
                          failureBlock:^(NSError *error) {NSLog(@"There is an error");}];
}

@end