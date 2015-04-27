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

    var phrases = [String]()
    @IBOutlet weak var logInLabel: WKInterfaceLabel!
    @IBOutlet weak var button1: WKInterfaceButton!
    @IBOutlet weak var button2: WKInterfaceButton!
    @IBOutlet weak var button3: WKInterfaceButton!
    @IBOutlet weak var button4: WKInterfaceButton!
    @IBOutlet weak var successLabel: WKInterfaceLabel!
    
    @IBAction func message1() {
        buttonTapped(phrases[0])
    }
    
    @IBAction func message2() {
        buttonTapped(phrases[1])
    }
    
    @IBAction func message3() {
        buttonTapped(phrases[2])
    }
    
    @IBAction func message4() {
        buttonTapped(phrases[3])
    }
    
    func buttonTapped(phrase:String) {
        pushControllerWithName("tableInterfaceController", context: phrase)
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        WKInterfaceController.openParentApplication(["content": "checkMessages"], reply: { (reply, error) -> Void in
            if let response = reply as? [String: String] {
                if let sender = response["sender"] {
                    if let messageContent = response["messageContent"] {
                        self.pushControllerWithName("messageInterfaceController", context: response)
                    }
                }
            }
        })
        
        if let result = context as? Bool {
            if result == true {
                successLabel.setText("Message sent!")
            } else {
                successLabel.setText("Not sent!")
            }
            successLabel.setHidden(false)
        }
        
        WKInterfaceController.openParentApplication(["content": "isLoggedIn"], reply: { (reply, error) -> Void in
            if let response = reply as? [String: Bool] {
                if let content = response["content"] {
                    if content == true {
                        
                        WKInterfaceController.openParentApplication(["content": "getMessages"], reply: { (reply, error) -> Void in
                            if let response = reply as? [String: [String]] {
                                if let content = response["content"] {
                                    self.phrases = content
                                    if content.count > 0 {
                                        self.button1.setTitle(content[0])
                                        self.button1.setHidden(false)
                                    }
                                    if content.count > 1 {
                                        self.button2.setTitle(content[1])
                                        self.button2.setHidden(false)
                                    }
                                    if content.count > 2 {
                                        self.button3.setTitle(content[2])
                                        self.button3.setHidden(false)
                                    }
                                    if content.count > 3 {
                                        self.button4.setTitle(content[3])
                                        self.button4.setHidden(false)
                                    }
                                }
                            }
                        })
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
