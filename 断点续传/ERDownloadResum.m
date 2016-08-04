//
//  ERDownloadResum.m
//  断点续传
//
//  Created by 扆佳梁 on 16/8/2.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "ERDownloadResum.h"
#import "ERTaskOperation.h"

static ERDownloadResum *instance = nil;
@interface ERDownloadResum ()

@property(nonatomic,strong)NSMutableDictionary *operationManager;


@end

@implementation ERDownloadResum



#pragma mark - 重写的方法




#pragma mark - 公有方法

+(instancetype)shareERDownloadResum{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        instance = [[self alloc]init];

    });
    return instance;
}

-(id)init{
    self = [super init ];
    if (self) {

    }
    return self;
}





#pragma mark - 私有方法

-(NSMutableDictionary *)operationManager{
    if (!_operationManager) {
        _operationManager = [NSMutableDictionary dictionary];
    }
    return _operationManager;
}





#pragma mark - 公有方法

-(ERTaskOperation *)downLoadWithURL:(NSString *)urlStr
              progress:(progressBlock)progressBlock
               success:(successBlock)successBlock
                 failure:(nonnull failureBlock)failureBlock{
    
    ERTaskOperation *operation = self.operationManager[urlStr];
    if (operation) { //如果只是暂停,可以继续下载.
        [operation resume];
        return operation;
    }
    ERTaskOperation *newOperation = [[ERTaskOperation alloc]initWith:urlStr];
    newOperation.progressBlock = progressBlock;
    newOperation.successBlock = successBlock;
    newOperation.failedBlock = failureBlock;
    [newOperation start];
    self.operationManager[urlStr] = newOperation;
    
    return newOperation;

}


-(void)stopTaskOperation:(NSString *)urlStr{
    ERTaskOperation *operation = self.operationManager[urlStr];
    if (operation) {
        [operation stop];
    }
}






@end
