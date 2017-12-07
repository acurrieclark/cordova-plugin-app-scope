/*! Copyright 2017 Ayogo Health Inc. */

extension CDVAppDelegate {

    func application(_ application: UIApplication, continue userActivity:NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        NSLog("CORDOVA-PLUGIN: Called continueUserActivity")

        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            return true
        }

        return false
    }
}
