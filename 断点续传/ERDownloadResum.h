//
//  ERDownloadResum.h
//  断点续传
//
//  Created by 扆佳梁 on 16/8/2.
//  Copyright © 2016年 Eric. All rights reserved.
//


/**
 *  一个实现类
 */

#import <UIKit/UIKit.h>
#import "ERTaskOperation.h"

NS_ASSUME_NONNULL_BEGIN


@interface ERDownloadResum : NSObject


/**
 *  初始化一个单例
 *
 *  @return 返回创建的对象
 */
+(instancetype)shareERDownloadResum;




-(ERTaskOperation *)downLoadWithURL:(NSString *)URL
              progress:(progressBlock)progressBlock
               success:(successBlock)successBlock
               failure:(failureBlock)failureBlock;

/**
 *  暂停一个下载
 *
 *  @param urlStr 需要下载的url 
 */
-(void)stopTaskOperation:(NSString *)urlStr;
@end
NS_ASSUME_NONNULL_END




