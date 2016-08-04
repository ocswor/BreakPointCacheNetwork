//
//  ERTableViewController.m
//  断点续传
//
//  Created by 扆佳梁 on 16/8/3.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "ERTableViewController.h"
#import "ERDownloadResum.h"
#import "ERTaskOperation.h"

@interface ERTableViewController ()

@property (weak, nonatomic) IBOutlet UILabel *progressLabel_one;

@property (weak, nonatomic) IBOutlet UILabel *progressLabel_two;

@property (weak, nonatomic) IBOutlet UILabel *progressLabel_three;

@property (weak, nonatomic) IBOutlet UILabel *progressLabel_four;



@property(nonatomic,strong)ERDownloadResum *erDownload;



@end

@implementation ERTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getter / setter


-(ERDownloadResum *)erDownload{
    
    if (nil == _erDownload) {
        _erDownload = [ERDownloadResum shareERDownloadResum];
    }
    return _erDownload;
}


#pragma mark - 私有方法

- (IBAction)startDownload:(UIButton *)sender {
    
    NSString *urlStr;
    switch (sender.tag) {
        case 0:
        {
            urlStr = @"http://localhost/test.pkg";

            [self handleDownload:sender withUrlStr:urlStr withLabel:_progressLabel_one];
        }
            break;
        case 1:
        {
            urlStr = @"http://localhost/test1.pkg";
            
            [self handleDownload:sender withUrlStr:urlStr withLabel:_progressLabel_two];

        }
            break;
        case 2:
        {
            urlStr = @"http://localhost/test2.pkg";
            
            [self handleDownload:sender withUrlStr:urlStr withLabel:_progressLabel_three];

        }
            break;
        case 3:
        {
            urlStr = @"http://localhost/test3.pkg";
            
            [self handleDownload:sender withUrlStr:urlStr withLabel:_progressLabel_four];

        }
            break;
        case 4:
        {
            urlStr = @"http://localhost/test4.pkg";
            
            [self handleDownload:sender withUrlStr:urlStr withLabel:nil];

            
        }
            break;
        case 5:
        {
            
        }
            break;
        case 6:
        {
            
        }
            break;
            
        default:
            break;
    }
    
}


-(void)handleDownload:(UIButton *)sender withUrlStr:(NSString *)urlStr withLabel:(UILabel *)progressLabel{
    
    if (!sender.selected) {
        //执行 继续开始
        [self.erDownload downLoadWithURL:urlStr progress:^(CGFloat progress) {
            NSLog(@"%f",progress);
            dispatch_async(dispatch_get_main_queue(), ^{
                progressLabel.text = [NSString stringWithFormat:@"%f",progress];

            });
        } success:^(NSString *fileStorePath) {
            NSLog(@"--%@",fileStorePath);
        } failure:^(NSError *error) {
            NSLog(@"--%@------%ld",error.userInfo[NSLocalizedDescriptionKey],(long)sender.tag);
        }];
        sender.selected = !sender.selected;

        
        
    }else{
        //暂停
        
        [self.erDownload stopTaskOperation:urlStr];
        
        sender.selected = !sender.selected;

    }
    
    
}

// 收到通知调用的方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(NSProgress *)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"%f",1.0 * object.completedUnitCount / object.totalUnitCount);
    // 回到主队列刷新UI
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.progressLabel_one.text = [NSString stringWithFormat:@"%f",1.0 * object.completedUnitCount / object.totalUnitCount];
    });
}

#pragma mark - 功能方法




#pragma mark - 需要重写的方法




#pragma mark - 外部调用的接口




#pragma mark - Model 模型事件




#pragma mark - View 事件


#pragma mark - Table view data source


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:; forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
