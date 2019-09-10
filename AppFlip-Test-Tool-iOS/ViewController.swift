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

class ViewController: UIViewController {

  @IBOutlet weak var clientIDField: UITextField!
  @IBOutlet weak var logField: UITextView!
  @IBOutlet weak var appLinkField: UITextField!
  @IBOutlet weak var scopeField: UITextField!
  @IBOutlet weak var stateField: UITextField!
  @IBOutlet weak var redirectUriField: UITextField!

  override func viewDidLoad() {
    super.viewDidLoad()
    var nsDictionary: NSDictionary?
    if let path = Bundle.main.path(forResource: "Config", ofType: "plist") {
      nsDictionary = NSDictionary(contentsOfFile: path)
    }
    clientIDField.delegate = self
    appLinkField.delegate = self
    scopeField.delegate = self
    stateField.delegate = self
    redirectUriField.delegate = self
    appLinkField.text = nsDictionary!["appFlipLinkAddress"] as? String
    clientIDField.text = nsDictionary!["clientID"] as? String
    scopeField.text = nsDictionary!["scope"] as? String
    stateField.text = nsDictionary!["state"] as? String
    redirectUriField.text = nsDictionary!["redirectUri"] as? String
    // To dismiss keyboard by tap on screen
    self.view.addGestureRecognizer(UITapGestureRecognizer(
      target: self.view, action: #selector(UIView.endEditing(_:))))
  }

  @IBAction func flipAction(flipButton: UIButton) {
    print("Flip button clicked!");
    if clientIDField.text == "" {
      let alert = UIAlertController(title: "What's your client ID?",
                                    message: "Please input clientID", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      self.present(alert, animated: true)
      return
    }

    logField.text = "Flipping to your app...\n"
    guard let url = URL(string: "\(appLinkField.text!)?client_id=\(clientIDField.text!)" +
      "&scope=\(scopeField.text!)&state=\(stateField.text!)&redirect_uri=\(redirectUriField.text!)")
      else {
        return
    }
    logField.text.append("URL sent to flip:\n\(url)\n\n")
    UIApplication.shared.open(url, options: ["universalLinksOnly":true], completionHandler: nil)
  }
}

extension ViewController : UITextFieldDelegate {
  // To dismiss keyboard by tap return
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
