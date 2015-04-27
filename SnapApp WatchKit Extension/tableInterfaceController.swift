//
//  tableInterfaceController.swift
//  SnapApp
//
//  Created by Rommel Rico on 4/26/15.
//  Copyright (c) 2015 Rommel Rico. All rights reserved.
//

import WatchKit
import Foundation


class tableInterfaceController: WKInterfaceController {

    var messageContent = ""
    var users = [String]()
    @IBOutlet weak var table: WKInterfaceTable!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        if let messageString = context as? String {
            messageContent = context as! String
        }
        
        WKInterfaceController.openParentApplication(["content": "getUsers"], reply: { (reply, error) -> Void in
            if let response = reply as? [String: [String]] {
                if let content = response["content"] {
                    self.users = content
                    self.table.setNumberOfRows(self.users.count, withRowType: "tableRowController")
                    for (index, username) in enumerate(self.users) {
                        let row = self.table.rowControllerAtIndex(index) as? tableRowController
                        row?.tableRowLabel.setText(username)
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
    
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        WKInterfaceController.openParentApplication(["content": "sendMessage", "messageContent":messageContent, "user":users[rowIndex]], reply: { (reply, error) -> Void in
            if let response = reply as? [String: Bool] {
                if let content = response["content"] {
                    self.pushControllerWithName("IntefaceController", context: content)
                }
            }
        })
    }

}
