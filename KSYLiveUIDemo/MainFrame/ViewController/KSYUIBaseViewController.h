//
//  KSYUIBaseViewController.h
//  KSYLiveUIDemo
//
//  Created by 王旭 on 2017/11/15.
//  Copyright © 2017年 王旭. All rights reserved.
//

#import <UIKit/UIKit.h>

//文件选择器
#import "KSYFileSelector.h"

#import "ZipArchive.h"

@interface KSYUIBaseViewController : UIViewController

//推流地址
@property(nonatomic,copy)NSURL* rtmpUrl;
//初始化推流地址
-(id)initWithUrl:(NSURL *)rtmpUrl;
//参数配置
@property(nonatomic,strong)NSDictionary* modelSenderDic;

//视频资源下载工具
@property(nonatomic,strong)KSYFileSelector * fileDownLoadTool;
//logo图片下载
@property(nonatomic,strong)KSYFileSelector* logoFileDownLoadTool;
//GPUResource资源的存储路径
@property(nonatomic,copy) NSString * gpuResourceDir;

//图片的数组
@property(nonatomic,strong)NSArray* filePathArray;




// 将UIImage 保存到path对应的文件
+ (void)saveImage: (UIImage *)image
               to: (NSString*)path;
+ (void)saveImageToPhotosAlbum:(UIImage *)image;
//保存视频到对应的位置
- (void) saveVideoToAlbum: (NSString*) path;
//提示
-(void) toast:(NSString*)message
          time:(double)duration;
//删除文件
+(void)deleteFile:(NSString *)file;

//下载滤镜资源
-(void)downloadGPUResource;
@end
