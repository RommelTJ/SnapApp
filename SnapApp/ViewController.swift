//
//  ViewController.swift
//  SnapApp
//
//  Created by Rommel Rico on 4/23/15.
//  Copyright (c) 2015 Rommel Rico. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

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

