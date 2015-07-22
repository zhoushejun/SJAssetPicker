//
//  SJAssetPickerModel.h
//  SJAssetPicker
//
//  Created by shejun.zhou on 15/7/20.
//  Copyright (c) 2015年 shejun.zhou. All rights reserved.
//

/**
 @file      SJAssetPickerModel.h
 @abstract  读取相册model，同步已选择的相片对象
 @author    shejun.zhou
 @version   1.0 15/7/20 Creation
 */
#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

/**
 @class     SJAssetPickerModel
 @abstract  读取相册model
 */
@interface SJAssetPickerModel : NSObject

@property (nonatomic, strong) NSMutableArray *selectedAssetsArray;      ///< 确认选择的照片
@property (nonatomic, strong) NSMutableArray *selectedAssetsArrayTemp;  ///< 临时选择的照片
@property (nonatomic, strong) ALAssetsLibrary *library;                 ///< 相册库对象

+ (SJAssetPickerModel *)shareManager;

@end
