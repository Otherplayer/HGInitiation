//
//  HGWhateverController.m
//  HGInitiation
//
//  Created by __无邪_ on 2018/5/16.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "HGWhateverController.h"

extern uint64_t dispatch_benchmark(size_t count, void (^block)(void));

@interface HGWhateverController ()

@end

@implementation HGWhateverController


#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initiateDatas];
    [self initiateViews];
    
    [self testURITemplate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private method

- (void)test {
    
    static size_t const count = 1000;
    static size_t const iterations = 10;
    id object = @"🐷";
    CFTimeInterval startTime = CACurrentMediaTime();
    {
        for (size_t i = 0; i < iterations; i++) {
            @autoreleasepool {
                NSMutableArray *mutableArray = [NSMutableArray array];
                for (size_t j = 0; j < count; j++) {
                    [mutableArray addObject:object];
                }
            }
        }
    }
    CFTimeInterval endTime = CACurrentMediaTime();
    NSLog(@"Total Runtime: %g s", endTime - startTime);
    
    
    uint64_t t_0 = dispatch_benchmark(iterations, ^{
        @autoreleasepool {
            NSMutableArray *mutableArray = [NSMutableArray array];
            for (size_t i = 0; i < count; i++) {
                [mutableArray addObject:object];
            }
        }
    });
    NSLog(@"[[NSMutableArray array] addObject:] Avg. Runtime: %llu ns", t_0);
    
    __block int idx = 0;
    uint64_t t_1 = dispatch_benchmark(iterations, ^{
        NSLog(@"--%@",@(++idx));
        @autoreleasepool {
            NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:count];
            for (size_t i = 0; i < count; i++) {
                [mutableArray addObject:object];
            }
        }
    });
    NSLog(@"[[NSMutableArray arrayWithCapacity] addObject:] Avg. Runtime: %llu ns", t_1);
    
}

- (void)testURITemplate {
    NSString *template = @"http://example.org/{var}/{hello}/{undef}/{+var}/{+hello}/{+undef}/{+path}/{#var}/{#hello}/{#undef}/here/map?{x,y,z}/{+x,y,z}/{#x,y,z}/{.x,y}/{.var}{/var}{/var,x}/{;x,y}/{;x,y,empty}/{?x}/{?x,y}/{?x,y,empty}/{&x}/{&x,y,empty}";
    NSString *result = [template templateExpand:@{
                                                  @"hello":@"Hello World",
                                                  @"var":@"value",
                                                  @"path":@"foo/bar",
                                                  @"empty":@"",
                                                  @"x":@"1024",
                                                  @"y":@"768"
                                                  }];
    
    NSLog(@"%@",template);
    NSLog(@"%@",result);
}

#pragma mark - initiate

- (void)initiateDatas {
    
}
- (void)initiateViews {
    self.navigationItem.title = @"Whatever";
}



@end
