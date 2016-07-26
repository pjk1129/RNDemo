//
//  HomeViewController.m
//  RNDemo
//
//  Created by JK.PENG on 16/7/22.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "HomeViewController.h"
#import "RCTRootView.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    if ([self respondsToSelector:@selector(setExtendedLayoutIncludesOpaqueBars:)]) {
        self.extendedLayoutIncludesOpaqueBars = NO;
    }
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    NSURL *jsCodeLocation = [ NSURL URLWithString:@"http://localhost:8081/ReactComponent/home.ios.bundle?platform=ios&dev=true"];
                              
    RCTRootView  *rootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation
                                                         moduleName:@"RNDemo" initialProperties:nil launchOptions:nil];
    rootView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-64-49);
    [self.view addSubview:rootView];
    
}


@end
