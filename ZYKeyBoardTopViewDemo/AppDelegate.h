//
//  AppDelegate.h
//  ZYKeyBoardTopViewDemo
//
//  Created by yao on 2018/3/2.
//  Copyright © 2018年 王智垚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

