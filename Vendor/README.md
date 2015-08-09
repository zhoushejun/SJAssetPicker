# SJAssetPicker
选择相册照片

导入文件夹《SJAssetPicker》，引入头文件：#import "SJAssetGroupsTableViewController.h"

之后在需要的地方添加以下语句：

UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SJAssetPicker" bundle:nil];
UINavigationController *groupsVC = [storyboard instantiateViewControllerWithIdentifier:@"SJAssetPickerNavigationController"];
[self presentViewController:groupsVC animated:YES completion:nil];
