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

@implementation HGOtherController

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
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    
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
    
//    //倒计时时间
//    __block int timeout = 3;
//    //延迟执行
//    int delayInSeconds = 3;
//    //创建队列
//    //dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    //创建timer
//    dispatch_source_t timerSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
//    //设置1s触发一次，0.1s的误差
//    dispatch_source_set_timer(timerSource,dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC),1 * NSEC_PER_SEC, NSEC_PER_SEC / 10); //每秒执行
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
    
//    dispatch_group_t group = dispatch_group_create();
//    dispatch_semaphore_t semaphore = dispatch_semaphore_create(10);
//    for (int i = 0; i < 100; i++){
//        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//        dispatch_group_async(group, queue, ^{
//            NSLog(@"%i",i);
//            sleep(2);
//            dispatch_semaphore_signal(semaphore);
//        });
//    }
//    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    
//    __block int product = 0;
//    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
//    dispatch_async(queue, ^{ //消费者队列
//        while (YES) {
//            if(!dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER)){
//                usleep(500000);
//                NSLog(@"消费%d产品",product);
//                product--;
//            };
//        }
//    });
//    dispatch_async(queue, ^{ //生产者队列
//        while (YES) {
//            sleep(1); //wait for a while
//            product++;
//            NSLog(@"生产%d产品",product);
//            dispatch_semaphore_signal(sem);
//        }
//    });
    
    
}
- (void)checkForFile {
    
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
