//
//  ViewController.swift
//  SnapApp
//
//  Created by Rommel Rico on 4/23/15.
//  Copyright (c) 2015 Rommel Rico. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBAction func doLoginOrSignUp(sender: AnyObject) {
        if username.text == "" {
            errorLabel.text = "Please enter a username"
        } else if password.text == "" {
            errorLabel.text = "Please enter a password"
        } else {
            //Try to log them in. If fail, sign them up.
            PFUser.logInWithUsernameInBackground(username.text, password:password.text) {
                (user: PFUser?, error: NSError?) -> Void in
                if user != nil {
                    // Do stuff after successful login.
                    self.errorLabel.text = "Successful login!"
                    self.performSegueWithIdentifier("showLoggedInViewController", sender: self)
                } else {
                    // The login failed. Check error to see why.
                    NSLog("error in login")
                    
                    var user = PFUser()
                    user.username = self.username.text
                    user.password = self.password.text
                    
                    user.signUpInBackgroundWithBlock {
                        (succeeded: Bool, error: NSError?) -> Void in
                        if error == nil {
                            // Hooray! Let them use the app now.
                            NSLog("Sign up successful!")
                            self.performSegueWithIdentifier("showLoggedInViewController", sender: self)
                        } else {
                            let errorString = error!.userInfo?["error"] as? String
                            self.errorLabel.text = errorString
                            NSLog("Error in Sign Up")
                        }
                    }
                }
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if PFUser.currentUser() != nil {
            NSLog("User is already logged in. Perform segue.")
            self.performSegueWithIdentifier("showLoggedInViewController", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var testObject = PFObject(className: "TestObject")
        testObject["foo"] = "bar";
        testObject.save()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

