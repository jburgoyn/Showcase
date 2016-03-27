//
//  ViewController.swift
//  ShowcaseJB
//
//  Created by Jonny B on 2/6/16.
//  Copyright © 2016 Jonny B. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(true)
        
        if NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil {
            
            self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
        }
    }

    @IBAction func fbBtnPressed(sender: UIButton!) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logInWithReadPermissions(["email"], fromViewController: self) { (facebookResult:FBSDKLoginManagerLoginResult!, facebookError: NSError!) -> Void in
        
            if facebookError != nil {
                
                print("Facebook Login Failed: Error \(facebookError)")
                
            } else {
                
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                print("Successfully logged in with FB \(accessToken)")
                
                DataService.ds.REF_BASE.authWithOAuthProvider("facebook", token: accessToken, withCompletionBlock: {error, authData in
                    
                    if error != nil {
                        
                        print("login failed: \(error)")
                        
                    } else {
                        
                        print("logged in: \(authData)")
                        
                        let user = ["provider": authData.provider!]
                        DataService.ds.createFirebaseUser(authData.uid, user: user)
                        
                        NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: KEY_UID)
                        self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                    }
            
                })
                
            }
        }
        
    }
    
    // TODO: Need to get this going
    
    @IBAction func attemptLogin(sender: UIButton!) {
        
        if let email = emailField.text where email != "", let pwd = passwordField.text where pwd != "" {
            
            DataService.ds.REF_BASE.authUser(email, password: pwd, withCompletionBlock: { error, authData in
                
                if error != nil {
                    
                    print(error.code)
                    self.showErrorAlert("Something isn't quite right", msg: "Please check your email and password.")
                    
                    if error.code == STATUS_ACCOUNT_NONEXIST {
                        
                        DataService.ds.REF_BASE.createUser(email, password: pwd, withValueCompletionBlock: { error, result in
                            
                            if error != nil {
                                
                                self.showErrorAlert("Could not create account", msg: "Problem creating account. Try something else")
                            } else {
                                
                                NSUserDefaults.standardUserDefaults().setValue(result[KEY_UID], forKey: KEY_UID)
                                
                                DataService.ds.REF_BASE.authUser(email, password: pwd, withCompletionBlock: { err, authData in
                                    
                                    let user = ["provider": authData.provider!]
                                    DataService.ds.createFirebaseUser(authData.uid, user: user)
                                
                            })
                            
                                self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                                
                            }
                        })
                        
                    }
                } else {
                    
                    self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                }
            })
            
        } else {
            
            showErrorAlert("Email and passwoord reuquired.", msg: "Please enter email and password")
        }
    }
    
    func showErrorAlert(title: String, msg: String) {
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    
    
    
    
}

