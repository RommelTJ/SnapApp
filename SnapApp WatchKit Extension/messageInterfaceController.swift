//
//  messageInterfaceController.swift
//  SnapApp
//
//  Created by Rommel Rico on 4/26/15.
//  Copyright (c) 2015 Rommel Rico. All rights reserved.
//

import WatchKit
import Foundation


class messageInterfaceController: WKInterfaceController {

    @IBOutlet weak var fromLabel: WKInterfaceLabel!
    @IBOutlet weak var messageContentLabel: WKInterfaceLabel!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        if let response = context as? [String: String] {
            if let sender = response["sender"] {
                if let messageContent = response["messageContent"] {
                    fromLabel.setText("From: \(sender)")
                    messageContentLabel.setText(messageContent)
                }
            }
        }
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
