/*! Copyright 2017 Ayogo Health Inc. */

#import "Cordova/CDVAppDelegate.h"

@interface CDVAppDelegate (appScope)

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray *restorableObjects))restorationHandler;

@end
