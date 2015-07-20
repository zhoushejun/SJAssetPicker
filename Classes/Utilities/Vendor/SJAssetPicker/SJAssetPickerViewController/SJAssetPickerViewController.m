//
//  SJAssetPickerViewController.m
//  SJAssetPicker
//
//  Created by shejun.zhou on 15/7/4.
//  Copyright (c) 2015年 shejun.zhou. All rights reserved.
//


#import "SJAssetPickerViewController.h"
#import "SJAssetPickerModel.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface SJAssetPickerViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) SJAssetPickerModel *model;
@property (nonatomic, strong) NSMutableArray *assetsArray;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation SJAssetPickerViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _assetsArray = [[NSMutableArray alloc] init];
    _model = [SJAssetPickerModel shareManager];
    for (int i = 0; i < [_model.selectedAssetsArray count]; i++) {
        ALAsset *result = _model.selectedAssetsArray[i];
        NSURL *url= (NSURL*) [[result defaultRepresentation]url];
        NSLog(@"url:%@", url.description);
    }
    [self loadAllPictures];
}

- (void)viewDidDisappear:(BOOL)animated {

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
        for (NSString *p in files) {
            NSError *error;
            NSString *path = [cachPath stringByAppendingPathComponent:p];
            if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
            }
        }
    });
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_assetsArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellectionViewCellIdentifier" forIndexPath:indexPath];
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];
    UIImageView *imgView = (UIImageView *)[cell viewWithTag:101];
    imgView.hidden = YES;
    ALAsset *result = _assetsArray[indexPath.row];
    UIImage *image = [UIImage imageWithCGImage: result.thumbnail];
    imageView.image = image;

    if ([_model.selectedURLsArray containsObject:[result defaultRepresentation].url]) {
        imgView.hidden = NO;
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ALAsset *result = _assetsArray[indexPath.row];
    if ([_model.selectedURLsArray containsObject:[result defaultRepresentation].url]) {
        [_model.selectedAssetsArray removeObject:result];
        [_model.selectedURLsArray removeObject:[result defaultRepresentation].url];
    }else {
        [_model.selectedAssetsArray addObject:result];
        [_model.selectedURLsArray addObject:[result defaultRepresentation].url];
    }
    [collectionView reloadData];
}

-(void)loadAllPictures{
    
    void (^assetEnumerator)( ALAsset *, NSUInteger, BOOL *) = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if(result != nil) {
            if([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
/*                NSURL *url= (NSURL*) [[result defaultRepresentation]url];
                UIImage *image = [UIImage imageWithCGImage: result.thumbnail];
                if (!image) {
                    image = [UIImage imageWithCGImage:[[result defaultRepresentation] fullScreenImage]];
                }
                if (image) {
                    [_imageArray addObject:image];
                }
                if (![_imageURLArray containsObject:url]) {
                    [_imageURLArray addObject:url];
                    [self.collectionView reloadData];
                }
 */
                if (![_assetsArray containsObject:result]) {
                    [_assetsArray addObject:result];
                    [self.collectionView reloadData];
                }
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
    
    [_model.library enumerateGroupsWithTypes:ALAssetsGroupAll
                            usingBlock:assetGroupEnumerator
                          failureBlock:^(NSError *error) {NSLog(@"There is an error");}];
}

- (IBAction)tappedFinishedItemAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end