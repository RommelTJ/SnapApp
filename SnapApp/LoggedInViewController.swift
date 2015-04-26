//
//  LoggedInViewController.swift
//  SnapApp
//
//  Created by Rommel Rico on 4/24/15.
//  Copyright (c) 2015 Rommel Rico. All rights reserved.
//

import UIKit

class LoggedInViewController: UIViewController {

    var phrases = PFObject(className: "phrases")
    @IBOutlet weak var phrase1: UITextField!
    @IBOutlet weak var phrase2: UITextField!
    @IBOutlet weak var phrase3: UITextField!
    @IBOutlet weak var phrase4: UITextField!
    @IBOutlet weak var successLabel: UILabel!
    
    @IBAction func doUpdate(sender: AnyObject) {
        phrases["phrase1"] = phrase1.text
        phrases["phrase2"] = phrase2.text
        phrases["phrase3"] = phrase3.text
        phrases["phrase4"] = phrase4.text
        
        var query = PFQuery(className: "phrases")
        var username = PFUser.currentUser()?.username
        query.whereKey("username", equalTo: username!)
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil && objects!.count > 0 {
                if let storedPhrases = objects![0] as? PFObject {
                    storedPhrases["phrase1"] = self.phrase1.text
                    storedPhrases["phrase2"] = self.phrase2.text
                    storedPhrases["phrase3"] = self.phrase3.text
                    storedPhrases["phrase4"] = self.phrase4.text
                    
                    storedPhrases.saveInBackgroundWithBlock({ (success, error) -> Void in
                        if error == nil {
                            self.successLabel.text = "Phrases updated"
                        } else {
                            self.successLabel.text = "There was an error"
                        }
                    })
                    
                } else {
                    self.successLabel.text = "Please try again"
                }
            } else {
                let errorString = error!.userInfo?["error"] as? String
                self.successLabel.text = errorString
                NSLog("Error in Updating Phrases")
            }
        }
        phrases.pin()
    }
    
    @IBAction func doLogout(sender: AnyObject) {
        PFUser.logOut()
        performSegueWithIdentifier("showViewController", sender: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let query = PFQuery(className: "phrases")
        query.fromLocalDatastore()
        var username = PFUser.currentUser()?.username
        query.whereKey("username", equalTo: username!)
        
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil && objects!.count > 0 {
                if let object = objects![0] as? PFObject {
                    self.phrases = object
                }
            } else {
                self.phrases["username"] = PFUser.currentUser()?.username
                self.phrases["phrase1"] = "I'll be late!"
                self.phrases["phrase2"] = "You are awesome"
                self.phrases["phrase3"] = "I'm hungry"
                self.phrases["phrase4"] = "Talk to you later"
                self.phrases.save()
                self.phrases.pin()
            }
            
            self.phrase1.text = self.phrases["phrase1"] as! String
            self.phrase2.text = self.phrases["phrase2"] as! String
            self.phrase3.text = self.phrases["phrase3"] as! String
            self.phrase4.text = self.phrases["phrase4"] as! String
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
