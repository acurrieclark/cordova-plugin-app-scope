/*! Copyright 2017 Ayogo Health Inc. */

@objc(CDVAppScopePlugin)
class CDVAppScopePlugin : CDVPlugin {
    override func pluginInitialize() {
        NSLog("CORDOVA-PLUGIN: Initialized")
    }
}
