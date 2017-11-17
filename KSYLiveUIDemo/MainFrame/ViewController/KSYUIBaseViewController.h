//
//  KSYUIBaseViewController.h
//  KSYLiveUIDemo
//
//  Created by 王旭 on 2017/11/15.
//  Copyright © 2017年 王旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KSYUIBaseViewController : UIViewController

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
@end
