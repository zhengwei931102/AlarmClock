//
//  AppDelegate.m
//  AlarmClock
//
//  Created by zw on 2019/7/5.
//  Copyright © 2019 zw. All rights reserved.
//

#import "AppDelegate.h"
// iOS10.0 需要导入
#import <UserNotifications/UserNotifications.h>
@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
   
    [self registerLocalNotification];
    
    return YES;
}


// 注册通知
- (void)registerLocalNotification {
    
    if (@available(iOS 10.0, *)) { // iOS10 以上
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound + UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            
        }];
    } else {// iOS8.0 以上
        UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
    }
}
#pragma mark - iOS8 推送代理
//在后台情况下点击本地推送  或者   在前台收到本地通知都会触发这个方法
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"didReceiveLocalNotification notification");
    // 更新显示的badge个数
    NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
    badge--;
    badge = badge >= 0 ? badge : 0;
    application.applicationIconBadgeNumber = badge;
    
}
#pragma mark - iOS10 推送代理

//不实现，通知不会有提示
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    //应用在前台收到通知
    NSLog(@"========%@", notification);
    
    //    UNNotificationRequest *request = notification.request; // 原始请求
    //    NSDictionary * userInfo = notification.request.content.userInfo;//userInfo数据
    //    UNNotificationContent *content = request.content; // 原始内容
    //    NSString *title = content.title;  // 标题
    //    NSString *subtitle = content.subtitle;  // 副标题
    //    NSNumber *badge = content.badge;  // 角标
    //    NSString *body = content.body;    // 推送消息体
    //    UNNotificationSound *sound = content.sound;  // 指定的声音
    //建议将根据Notification进行处理的逻辑统一封装，后期可在Extension中复用~
    //如果需要在应用在前台也展示通知
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 回调block，将设置传入
    
}
// 对通知进行响应
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler {
    
    // 根据类别标识符处理目标反应
    if ([response.notification.request.content.categoryIdentifier isEqualToString:@"categoryIdentifier"]) {
        [self handleResponse:response];
        
        //        UNNotificationRequest *request = response.notification.request; // 原始请求
        //        UNNotificationContent *content = request.content; // 原始内容
        //        NSString *title = content.title;  // 标题
        //        NSString *subtitle = content.subtitle;  // 副标题
        //        NSNumber *badge = content.badge;  // 角标
        //        NSString *body = content.body;    // 推送消息体
        //        UNNotificationSound *sound = content.sound;
        //在此，可判断response的种类和request的触发器是什么，可根据远程通知和本地通知分别处理，再根据action进行后续回调
        
    }
    completionHandler();
}

- (void)handleResponse:(UNNotificationResponse *)response {
    
    NSString *actionIndentifier = response.actionIdentifier;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    NSLog(@"%@",@"处理通知");
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    // 更新显示的badge个数,每次进入我都设置为0
    application.applicationIconBadgeNumber = 0;
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
