/*
 * Copyright 2019 Google
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions
    launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    return true
  }

  func application(_ application: UIApplication, continue userActivity: NSUserActivity,
                   restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
    print("Test Tool Handling Link");
    guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
      let incomingURL = userActivity.webpageURL,
      let components = NSURLComponents(url: incomingURL, resolvingAgainstBaseURL: true),
      let path = components.path,
      let params = components.queryItems else {
        return false
    }
    print("path = \(path)")
    if let state = params.first(where: { $0.name == "state" } )?.value,
      let authCode = params.first(where: { $0.name == "code" } )?.value {
      (window?.rootViewController as? ViewController)?.logField?.text.append(
        "App respond:\nAuth_code = \(authCode)\nstate = \(state)\n")
      print("AuthCode = \(authCode)")
      return true
    } else if let state = params.first(where: { $0.name == "state" } )?.value,
      let errMsg = params.first(where: { $0.name == "error" } )?.value {
      (window?.rootViewController as? ViewController)?.logField?.text.append(
        "App respond:\nError_msg = \(errMsg)\nstate = \(state)\n")
      print("Error Message = \(errMsg)")
      return true
    } else {
      print("Return URL syntax error")
      return false
    }
  }
}
