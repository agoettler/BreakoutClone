//
//  ViewController.swift
//  BreakoutClone
//
//  Created by Andrew Goettler on 10/11/16.
//  Copyright © 2016 Andrew Goettler. All rights reserved.
//
//

import UIKit

class ViewController: UIViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print("viewController viewDidLoad")
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        print("viewController viewDidAppear")
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

