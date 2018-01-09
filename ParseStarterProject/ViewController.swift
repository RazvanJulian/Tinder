/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

class ViewController: UIViewController {
    
    
    var activityIndicator = UIActivityIndicatorView()

    @IBOutlet var usernameTextField: UITextField!
    
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var enterButton: UIButton!
    
    @IBOutlet var errorLabel: UILabel!
    
    
    func createAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alert) in
            self.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    var signupMode = false
    
    @IBAction func enterAction(_ sender: Any) {
        
        if usernameTextField.text == "" && passwordTextField.text == "" {
            createAlert(title: "Error in form", message: "Please enter an email and password")
            
            
            
        } else {
            
            activityIndicator = UIActivityIndicatorView(frame: CGRect(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2, width: 50, height: 50))
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            self.view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            
        
            if !signupMode {
                // Sign Up Mode
                let user = PFUser()
                user.username = usernameTextField.text
                user.password = passwordTextField.text
                
                let acl = PFACL()
                
                acl.getPublicWriteAccess = true
                acl.getPublicReadAccess = true
                
                user.acl = acl
                
                user.signUpInBackground(block: { (success, error) in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    
                    if error != nil {
                        
                        var displayErrorMesage = "Please try again later!"
                        if let errorMessage = (error! as NSError).userInfo["error"] as? String {
                            displayErrorMesage = errorMessage
                            self.errorLabel.text = displayErrorMesage
                        }
                        
                        
                        self.createAlert(title: "Sign Up Error", message: displayErrorMesage)
                        
                    }else{
                        
                        print("Signed up")
                        
                        self.performSegue(withIdentifier: "showProfile", sender: self)

                        
                    }
                })
                
                
                
                
            } else {
                
                
                
                // Log In Mode
                PFUser.logInWithUsername(inBackground: usernameTextField.text!, password: passwordTextField.text!, block: { (user, error) in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    if error != nil {
                        
                        var displayErrorMesage = "Please try again later!"
                        if let errorMessage = (error! as NSError).userInfo["error"] as? String {
                            displayErrorMesage = errorMessage
                            self.errorLabel.text = displayErrorMesage
                        }
                        
                        
                        self.createAlert(title: "Login Error", message: displayErrorMesage)
                    
                    } else {
                        
                        print("Logged In")
                        
                        self.redirectUser()
                        
                    }
                })
                
                
                

            }
        
        }
        
    }
    
    @IBOutlet var accountMessage: UILabel!
    @IBOutlet var switchButton: UIButton!
    
    @IBAction func switchAction(_ sender: Any) {
        
        if signupMode{
            // Sign Up Mode
            enterButton.setTitle("Sign Up", for: [])
            switchButton.setTitle("Log In", for: [])
            print("Sign Up Mode")
            
        }else{
            // Log In Mode
            enterButton.setTitle("Log In", for: [])
            switchButton.setTitle("Sign Up", for: [])
            print("Log In Mode")
        
        }
        
        signupMode = !signupMode
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        redirectUser()
        
    }
    
    func redirectUser() {
        
        if PFUser.current() != nil {
            
            
            if PFUser.current()?["isFemale"] != nil && PFUser.current()?["isInterestedInWomen"] != nil && PFUser.current()?["photo"] as? PFFile != nil{
                
                performSegue(withIdentifier: "swipeFromInitialSegue", sender: self)
                
            } else {
                
                self.performSegue(withIdentifier: "showProfile", sender: self)
                
                
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        enterButton.layer.cornerRadius = 10
        
        
        
        
        //let testObject = PFObject(className: "TestObject2")
        
//        testObject["foo"] = "bar"
//
//        testObject.saveInBackground { (success, error) -> Void in
//
//             added test for success 11th July 2016
//
//            if success {
//
//                print("Object has been saved.")
//
//            } else {
        
//                if error != nil {
//
//                    print (error)
//
//                } else {
//
//                    print ("Error")
//                }
//
//            }
//
//        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
