//
//  HGOtherController.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/2/24.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "HGOtherController.h"

@interface HGOtherController ()
@property(nonatomic,strong) NSMutableArray *datas;
@end

@implementation HGOtherController{
    BOOL havePendingWork;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
//    [self funCopy];
    [self funGCDSource];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - funGCDSource

- (void)funGCDSource {
//    const char *myFile = [@"/Path/To/File" fileSystemRepresentation];
//    int fileDescriptor = open(myFile, O_EVTONLY);
//    dispatch_queue_t myQueue = dispatch_get_main_queue();
//    const uint64_t dispatchFlags = DISPATCH_VNODE_DELETE | DISPATCH_VNODE_WRITE;
//    dispatch_source_t mySource = dispatch_source_create(DISPATCH_SOURCE_TYPE_VNODE, fileDescriptor, dispatchFlags, myQueue);
//    dispatch_source_set_event_handler(mySource, ^{
//        [self checkForFile];
//    });
//    dispatch_resume(mySource);
    
    
//    //创建source，以DISPATCH_SOURCE_TYPE_DATA_ADD的方式进行累加，而DISPATCH_SOURCE_TYPE_DATA_OR是对结果进行二进制或运算
//    dispatch_source_t source = dispatch_source_create(DISPATCH_SOURCE_TYPE_DATA_ADD, 0, 0, dispatch_get_main_queue());
//    //事件触发后执行的句柄
//    dispatch_source_set_event_handler(source,^{
//        NSLog(@"监听函数：%lu",dispatch_source_get_data(source));
//    });
//    //开启source
//    dispatch_resume(source);
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^ {
//        dispatch_source_merge_data(source,1);
//    });
    
    
//    double delayInSeconds = 5.f;
//    dispatch_time_t delayInNanoSeconds = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//    // 得到全局队列
//    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    // 延期执行
//    dispatch_after(delayInNanoSeconds, concurrentQueue, ^(void){
//
//    });
    
//    //倒计时时间
//    __block int timeout = 3;
//    //延迟执行
//    double delayInSeconds = 3.f;
//    //创建队列
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    //创建timer
//    dispatch_source_t timerSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
//    //设置1s触发一次，0s的误差
//    dispatch_source_set_timer(timerSource,dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC),NSEC_PER_SEC, 0); //每秒执行
//    dispatch_source_set_event_handler(timerSource, ^{
//        if(timeout <= 0) { //倒计时结束，关闭
//            NSLog(@"over");
//            dispatch_source_cancel(timerSource);
//        }else {
//            timeout--;
//            NSLog(@"~~~~~~~~~~~~~~~~%d", timeout);
//        }
//    });
//    dispatch_resume(timerSource);
    
    
//    havePendingWork = NO;
//    dispatch_semaphore_t mySemaphore = dispatch_semaphore_create(0);
//    while (YES) {///*** Not Recommended ***/
//        dispatch_time_t timeout = dispatch_time(DISPATCH_TIME_NOW, 500 * NSEC_PER_SEC);
//        long semaphoreReturnValue = dispatch_semaphore_wait(mySemaphore, timeout);
//        if (havePendingWork) {
//            [self doPendingWork];
//        }
//    }
//    while (YES) {
//        dispatch_time_t timeout = DISPATCH_TIME_FOREVER;
//        long semaphoreReturnValue = dispatch_semaphore_wait(mySemaphore, timeout);
//        if (havePendingWork) {
//            [self doPendingWork];
//        }
//    }
    
}
- (void)checkForFile {
    
}
- (void)doPendingWork {
    NSLog(@"doPendingWork");
}




#pragma mark - Copy

- (void)funCopy {
    self.datas = [NSMutableArray.alloc init];
    NSMutableDictionary *info = [@{@"isSelected":@0,@"items":@[[@{@"666":@1} mutableCopy]]} mutableCopy];
    [self.datas addObject:info];
    NSMutableDictionary *item = self.datas[0];
    [item setValue:@1 forKey:@"isSelected"];
    
    NSMutableArray *items = [item objectForKey:@"items"];
    //    NSMutableDictionary *t666 = [items lastObject];
    //    [t666 setValue:@0 forKey:@"666"];
    [items enumerateObjectsUsingBlock:^(NSMutableDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setValue:@0 forKey:@"666"];
    }];
    NSLog(@"%@",self.datas);
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
