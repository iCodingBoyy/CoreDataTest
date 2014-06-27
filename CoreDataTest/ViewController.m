//
//  ViewController.m
//  CoreDataTest
//
//  Created by 马远征 on 14-6-17.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import "ViewController.h"
#import "CoreDataManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:CGRectMake(10, 100, 300, 44)];
    [button setTitle:@"切换账号" forState:UIControlStateNormal];
    [button setTitle:@"切换账号" forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(clickToLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSManagedObjectContextDidSaveNotification object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mergeChanges:) name:NSManagedObjectContextDidSaveNotification object:nil];
    
    [[CoreDataManager sharedInstance]insertMsg:@"小明" age:12 gender:1];
    NSLog(@"---dabase--%@",[[CoreDataManager sharedInstance]searchAllRecordOfFace]);
}

- (void)mergeChanges:(NSNotification *)notification {
    NSLog(@"通知%@",notification);
//#if DEBUG && CORE_DATA_ENVIR_SHOW_LOG
//    NSLog(@"%s [%@/%@] %@", __FUNCTION__, self.context, notification.object, [self currentDispatchQueueLabel]);
//#endif
}

- (void)clickToLogin
{
    [[CoreDataManager sharedInstance]changePersistentStoreCoordinator:@"dabse1"];
    NSLog(@"---dabse1--%@",[[CoreDataManager sharedInstance]searchAllRecordOfFace]);
    BOOL success =  [[CoreDataManager sharedInstance]insertMsg:@"小黑" age:13 gender:0];
    NSLog(@"---success--%d",success);
    success =  [[CoreDataManager sharedInstance]insertMsg:@"小黄" age:13 gender:0];
    NSLog(@"---success--%d",success);
    
    [[CoreDataManager sharedInstance]changePersistentStoreCoordinator:@"dabase2"];
    NSLog(@"---dabase2--%@",[[CoreDataManager sharedInstance]searchAllRecordOfFace]);
     success =  [[CoreDataManager sharedInstance]insertMsg:@"小丫" age:13 gender:0];
    NSLog(@"---success--%d",success);
    success =  [[CoreDataManager sharedInstance]insertMsg:@"小小" age:12 gender:1];
    NSLog(@"---success--%d",success);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
