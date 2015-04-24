//
//  InterfaceController.swift
//  SnapApp WatchKit Extension
//
//  Created by Rommel Rico on 4/23/15.
//  Copyright (c) 2015 Rommel Rico. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet weak var logInLabel: WKInterfaceLabel!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        WKInterfaceController.openParentApplication(["content": "isLoggedIn"], reply: { (reply, error) -> Void in
            if let response = reply as? [String: Bool] {
                if let content = response["content"] {
                    if content == true {
                        println("User is logged in")
                    } else {
                        self.logInLabel.setHidden(false)
                        self.logInLabel.setText("Not logged in")
                    }
                }
            }
        })
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
