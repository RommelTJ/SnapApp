//
//  AppDelegate.swift
//  SnapApp
//
//  Created by Rommel Rico on 4/23/15.
//  Copyright (c) 2015 Rommel Rico. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        Parse.enableLocalDatastore()
        Parse.setApplicationId("REDACTED", clientKey: "REDACTED")
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, handleWatchKitExtensionRequest userInfo: [NSObject : AnyObject]?, reply: (([NSObject : AnyObject]!) -> Void)!) {
        if let request = userInfo as? [String:String] {
            if let content = request["content"] {
                if content == "isLoggedIn" {
                    if PFUser.currentUser() != nil {
                        reply(["content": true])
                    } else {
                        reply(["content": false])
                    }
                } else if content == "getMessages" {
                    let query = PFQuery(className: "phrases")
                    query.fromLocalDatastore()
                    var username = PFUser.currentUser()?.username
                    query.whereKey("username", equalTo: username!)
                    
                    query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
                        if error == nil && objects!.count > 0 {
                            if let object = objects![0] as? PFObject {
                                var messages = [String]()
                                if let message =  object["phrase1"] as? String {
                                    messages.append(message)
                                }
                                if let message =  object["phrase2"] as? String {
                                    messages.append(message)
                                }
                                if let message =  object["phrase3"] as? String {
                                    messages.append(message)
                                }
                                if let message =  object["phrase4"] as? String {
                                    messages.append(message)
                                }
                                reply(["content": messages])
                            }
                        }
                    }
                } else if content == "getUsers" {
                    var query = PFUser.query()
                    var users = [String]()
                    var username = PFUser.currentUser()?.username
                    query?.whereKey("username", notEqualTo: username!)
                    query?.orderByAscending("username")
                    query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                        if error == nil {
                            for object in objects! {
                                if let user = object as? PFUser {
                                    users.append(user.username!)
                                }
                            }
                            reply(["content":users])
                        } else {
                            println("Error getting users!")
                        }
                    })
                } else if content == "sendMessage" {
                    if let messageContent = request["messageContent"] {
                        if let user = request["user"] {
                            var message = PFObject(className: "messages")
                            message["messageContent"] = messageContent
                            message["to"] = user
                            message["from"] = PFUser.currentUser()?.username
                            message.saveInBackgroundWithBlock({ (success, error) -> Void in
                                if error == nil {
                                    reply(["content":success])
                                } else {
                                    reply(["content":false])
                                }
                            })
                        } else {
                            reply(["content":false])
                        }
                    } else {
                        reply(["content":false])
                    }
                } else if content == "checkMessages" {
                    var query = PFQuery(className: "messages")
                    var username = PFUser.currentUser()?.username
                    query.whereKey("to", equalTo: username!)
                    query.limit = 1
                    query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                        if error == nil && objects!.count > 0 {
                            if let message = objects![0] as? PFObject {
                                if let sender = message["from"] as? String {
                                    if let messageContent = message["messageContent"] as? String {
                                        message.deleteInBackgroundWithBlock({ (success, error) -> Void in
                                            if error == nil {
                                                if success == true {
                                                    reply(["sender": sender, "messageContent": messageContent])
                                                }
                                            }
                                        })
                                    }
                                }
                            }
                        }
                    })
                }
            }
        }
    }


}

