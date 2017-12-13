/*! Copyright 2017 Ayogo Health Inc. */

#import "CDVAppDelegate+AppScope.h"

@implementation CDVAppDelegate (appScope)

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray *restorableObjects))restorationHandler;
{
    if ([userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb]) {
        NSLog(@"APPSCOPE-PLUGIN: continueUserActivity with URL: %@", userActivity.webpageURL);

        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:CDVPluginHandleOpenURLNotification object:userActivity.webpageURL]];

        return YES;
    }

    return NO;
}

@end
