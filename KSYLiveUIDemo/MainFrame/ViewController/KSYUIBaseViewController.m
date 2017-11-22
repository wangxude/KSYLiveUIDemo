//
//  KSYUIBaseViewController.m
//  KSYLiveUIDemo
//
//  Created by 王旭 on 2017/11/15.
//  Copyright © 2017年 王旭. All rights reserved.
//

#import "KSYUIBaseViewController.h"
#import "KSYPictureAndLabelModel.h"

@interface KSYUIBaseViewController ()<UIImagePickerControllerDelegate>

@property(nonatomic,strong)NSDictionary* allModelDic;

@end

@implementation KSYUIBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化模型数据
    YYCache *cache = [YYCache cacheWithName:@"mydb"];
    NSArray* dataArray ;
    KSYPictureAndLabelModel* model;
    
    dataArray = [self.allModelDic valueForKey:@"混响"];
    model= [KSYPictureAndLabelModel modelWithDictionary:dataArray[0]];
    [cache setObject:model forKey:@"混响"];
    
    dataArray = [self.allModelDic valueForKey:@"变声"];
    model = [KSYPictureAndLabelModel modelWithDictionary:dataArray[0]];
    [cache setObject:model forKey:@"变声"];
    
    dataArray = [self.allModelDic valueForKey:@"LOGO"];
    model = [KSYPictureAndLabelModel modelWithDictionary:dataArray[0]];
    [cache setObject:model forKey:@"LOGO"];
    
    dataArray = [self.allModelDic valueForKey:@"背景音乐"];
    model = [KSYPictureAndLabelModel modelWithDictionary:dataArray[0]];
    [cache setObject:model forKey:@"背景音乐"];
    
    dataArray = [self.allModelDic valueForKey:@"美颜"];
    model = [KSYPictureAndLabelModel modelWithDictionary:dataArray[0]];
    [cache setObject:model forKey:@"美颜"];
    
    dataArray = [self.allModelDic valueForKey:@"滤镜"];
    model = [KSYPictureAndLabelModel modelWithDictionary:dataArray[0]];
    [cache setObject:model forKey:@"滤镜"];
    
    dataArray = [self.allModelDic valueForKey:@"贴纸"];
    model = [KSYPictureAndLabelModel modelWithDictionary:dataArray[0]];
    [cache setObject:model forKey:@"贴纸"];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - save Image
// 将UIImage 保存到path对应的文件
+ (void)saveImage: (UIImage *)image
               to: (NSString*)path {
    NSString * dir = [NSHomeDirectory() stringByAppendingString:@"/Documents/"];
    NSString * file = [dir stringByAppendingPathComponent:path];
    NSData *imageData = UIImagePNGRepresentation(image);
    BOOL ret = [imageData writeToFile:file atomically:YES];
    NSLog(@"write %@ %@", file, ret ? @"OK":@"failed");
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    if (error == nil) {
        UIAlertView *toast = [[UIAlertView alloc] initWithTitle:@"O(∩_∩)O~~"
                                                        message:@"图像已保存至手机相册"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [toast show];
        
    }else{
        
        UIAlertView *toast = [[UIAlertView alloc] initWithTitle:@"￣へ￣"
                                                        message:@"图像保存手机相册失败！"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [toast show];
    }
}

+ (void)saveImageToPhotosAlbum:(UIImage *)image
{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}


#pragma mark - 保存视频
//保存视频到相簿
- (void) saveVideoToAlbum: (NSString*) path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path)) {
            SEL onDone = @selector(video:didFinishSavingWithError:contextInfo:);
            UISaveVideoAtPathToSavedPhotosAlbum(path, self, onDone, nil);
        }
    });
}
//保存mp4文件完成时的回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo {
    NSString *message;
    if (!error) {
        message = @"Save album success!";
    }
    else {
        message = @"Failed to save the album!";
    }
    [self toast:message time:3];
}
#pragma mark-删除文件
//删除文件,保证保存到相册里面的视频时间是最新的
+(void)deleteFile:(NSString *)file{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:file]) {
        [fileManager removeItemAtPath:file error:nil];
    }
}

- (void) toast:(NSString*)message
          time:(double)duration
{
    UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [toast show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [toast dismissWithClickedButtonIndex:0 animated:YES];
    });
}


//-(void)viewDidDisappear:(BOOL)animated{
//    [super viewDidDisappear:YES];
//
//
//}

-(NSDictionary*)allModelDic{
    if (!_allModelDic) {
        NSString* path = [[NSBundle mainBundle] pathForResource:@"ArrayResourceList.plist" ofType:nil];
        _allModelDic = [NSDictionary dictionaryWithContentsOfURL:[NSURL fileURLWithPath:path]];
    }
    return _allModelDic;
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
