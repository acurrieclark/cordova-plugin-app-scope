/*! Copyright 2017 Ayogo Health Inc. */

@objc(CDVAppScopePlugin)
class CDVAppScopePlugin : CDVPlugin {
    override func pluginInitialize() {
        NotificationCenter.default.addObserver(self,
                selector: #selector(CDVAppScopePlugin._didFinishLaunchingWithOptions(_:)),
                name: NSNotification.Name.UIApplicationDidFinishLaunching,
                object: nil);


        NotificationCenter.default.addObserver(self,
                selector: #selector(CDVAppScopePlugin._handleOpenURL(_:)),
                name: NSNotification.Name.CDVPluginHandleOpenURL,
                object: nil);
    }


    /* Application Launch URL handling ***************************************/

    @objc internal func _didFinishLaunchingWithOptions(_ notification : NSNotification) {
        let options = notification.userInfo;
        if options == nil {
            return;
        }

        if let incomingUrl = options?[UIApplicationLaunchOptionsKey.url] as? URL {
            NSLog("APPSCOPE-PLUGIN: Got launched with URL: \(incomingUrl)")

            NotificationCenter.default.post(name: NSNotification.Name.CDVPluginHandleOpenURL, object: incomingUrl);
        }
    }



    @objc internal func _handleOpenURL(_ notification : NSNotification) {
        guard let url = notification.object as? URL else {
            return
        }

        guard let scope = self.commandDelegate.settings["scope"] as? String else {
            return
        }

        if !url.absoluteString.hasPrefix(scope) {
            return
        }

        var remapped = String(url.absoluteString.dropFirst(scope.count))
        if remapped.hasPrefix("#") || remapped.hasPrefix("?") {
            remapped = "index.html" + remapped;
        }

        let startURL = URL(string: remapped)
        let startFilePath = self.commandDelegate.path(forResource: startURL?.path)

        var appURL = URL(fileURLWithPath: startFilePath!)

        if let r = remapped.rangeOfCharacter(from: CharacterSet(charactersIn: "?#")) {
            let queryAndOrFragment = String(remapped[r.lowerBound..<remapped.endIndex])
            appURL = URL(string: queryAndOrFragment, relativeTo: appURL)!
        }

        NSLog("APPSCOPE-PLUGIN: Loading with URL: \(appURL.absoluteString)")

        let appReq = URLRequest(url: appURL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 20.0)
        self.webViewEngine.load(appReq)
    }
}
