//
//  ERTaskOperation.m
//  断点续传
//
//  Created by 扆佳梁 on 16/8/3.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "ERTaskOperation.h"
#import "NSString+Hash.h"

// 文件名（沙盒中的文件名），使用md5哈希url生成的，这样就能保证文件名唯一
#define  Filename  self.fileHasStr
// 文件的存放路径（caches）
#define  FileCacheStorePath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent: Filename]

// 使用plist文件存储文件的总字节数
#define  TotalLengthPlist [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"totalLength.plist"]


@interface ERTaskOperation ()<NSURLSessionDataDelegate>


@property(nonatomic,strong)NSURLSessionTask *task;

@property(nonatomic,strong)NSURLSession *session;


@property(nonatomic,assign)NSInteger fileTotalLength;


@property(nonatomic,strong)NSOutputStream *stream;

@property(nonatomic,copy)NSString *fileHasStr;//文件的唯一标示



@end

@implementation ERTaskOperation



-(instancetype)initWith:(NSString *)url{
    self = [super init];
    if (self) {
        
        self.fileHasStr = url.md5String;
        if ([self fileHasDownloaded:_fileHasStr]) {
            //文件是否下载过
            
        }
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:url]];
        
        //开始设置请求头
        NSString *range = [NSString stringWithFormat:@"bytes=%zd-",[self getFileDownloadSize:_fileHasStr]];
        
        [request setValue:range forHTTPHeaderField:@"Range"];
        
        _task = [self.session dataTaskWithRequest:request];
        
    }
    return self;
}
#pragma mark - getter / setter


-(NSURLSession *)session{
    if (!_session) {
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[[NSOperationQueue alloc]init]];
    }
    return _session;
}


-(NSOutputStream *)stream{
    if (!_stream) {
        
        NSLog(@"%@",FileCacheStorePath);
        _stream = [NSOutputStream outputStreamToFileAtPath:FileCacheStorePath append:YES];
                   
    }
    return _stream;
}

#pragma mark - 私有方法




#pragma mark - 功能方法

/**
 *  判断文件是否已经下载
 *
 *  @param url 需要下载文件的标示
 
 *  @return 返回判断的结果
 */
-(BOOL)fileHasDownloaded:(NSString *)hasStr{
    
    NSInteger totalLength = [[NSDictionary dictionaryWithContentsOfFile: TotalLengthPlist][ Filename] integerValue];
    if (totalLength && [self getFileDownloadSize:_fileHasStr] == totalLength) {
        return YES;
    }
    return NO;}


/**
 *  获取已经下载文件的大小
 *
 *  @param hasStr 文件的标示
 *
 *  @return 返回文件的大小
 */
-(NSInteger)getFileDownloadSize:(NSString *)hasStr{
  
    return  [[[NSFileManager defaultManager] attributesOfItemAtPath: FileCacheStorePath error:nil][NSFileSize] integerValue];

}


/**
 *  保存文件的基本信息
 1.文件的名字,标示
 2.文件的大小
 */
-(void)saveFileInfo{
    
   
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithContentsOfFile:TotalLengthPlist];
    if(nil == dic){
        dic = [[NSMutableDictionary alloc]init];
    }
    dic[self.fileHasStr] = @(self.fileTotalLength);
    
    [dic writeToFile:TotalLengthPlist atomically:YES];
}


#pragma mark - Delegate

/**
 *  收到响应
 *
 *  @param session
 *  @param dataTask
 *  @param response
 *  @param completionHandler
 */

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSHTTPURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler{
    
    [self.stream open];
    
    self.fileTotalLength = [response.allHeaderFields[@"Content-Length"] integerValue] + [self getFileDownloadSize:_fileHasStr];
    
    //保存文件的信息  文件名 和 文件大小
    [self saveFileInfo];
    
    completionHandler(NSURLSessionResponseAllow);//允许接受服务器的数据
}

/**
 *  接收到数据
 *
 *  @param session
 *  @param dataTask
 *  @param data
 */
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    
    /**
     *  写入数据   不断的缓存到本地 防止内存溢出
     */
    [self.stream write:data.bytes maxLength:data.length];
    
    CGFloat progress = 1.0 * [self getFileDownloadSize:_fileHasStr]/self.fileTotalLength;
    
    if (self.progressBlock) {
        self.progressBlock(progress);
    }
}


/**
 *  接受完毕
 *
 *  @param session
 *  @param task
 *  @param error
 */
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    
    if (error) {
        if (self.failedBlock) {
            self.failedBlock(error);
        }
        self.stream = nil;
        self.task = nil;
    }else{
        if (self.successBlock) {
            if (self.fileStorePath) {
                [[NSFileManager defaultManager] moveItemAtPath:FileCacheStorePath toPath:self.fileStorePath error:nil];
            }else{
                self.fileStorePath = FileCacheStorePath;
            }
            self.successBlock(self.fileStorePath);
        }
        [self.stream close];
        self.stream = nil;
        self.task = nil;//清除任务
        
    }
}

#pragma mark - 外部调用的接口


-(void)start{
    [_task resume];
}

-(void)stop{
    [_task suspend];
}


-(void)resume{
    [_task resume];
}



@end
