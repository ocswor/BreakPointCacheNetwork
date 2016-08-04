//
//  ERTaskOperation.h
//  断点续传
//
//  Created by 扆佳梁 on 16/8/3.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^progressBlock)(CGFloat progress);
typedef void(^successBlock)(NSString *fileStorePath);
typedef void(^failureBlock)(NSError *error);

@interface ERTaskOperation : NSObject

@property (copy,nonatomic) successBlock  successBlock;
@property (copy,nonatomic) failureBlock  failedBlock;
@property (copy,nonatomic) progressBlock  progressBlock;


@property(nonatomic,copy)NSString *fileStorePath;

/**
 *  初始化一个TaskOperation
 *
 *  @param url url
 *
 *  @return 返回对象实例
 */
-(instancetype)initWith:(NSString *)url;



/**
 *  开始
 */
-(void)start;


/**
 *  暂停
 */
-(void)stop;


/**
 *  恢复
 */
-(void)resume;
@end
