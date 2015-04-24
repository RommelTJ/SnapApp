//
//  LoggedInViewController.swift
//  SnapApp
//
//  Created by Rommel Rico on 4/24/15.
//  Copyright (c) 2015 Rommel Rico. All rights reserved.
//

import UIKit

class LoggedInViewController: UIViewController {

    @IBOutlet weak var phrase1: UITextField!
    @IBOutlet weak var phrase2: UITextField!
    @IBOutlet weak var phrase3: UITextField!
    @IBOutlet weak var phrase4: UITextField!
    @IBOutlet weak var successLabel: UILabel!
    
    @IBAction func doUpdate(sender: AnyObject) {
    }
    
    @IBAction func doLogout(sender: AnyObject) {
        PFUser.logOut()
        performSegueWithIdentifier("showViewController", sender: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
