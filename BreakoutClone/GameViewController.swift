//
//  GameViewController.swift
//  BreakoutClone
//
//  Created by Andrew Goettler on 10/13/16.
//  Copyright © 2016 Andrew Goettler. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        print("GameViewController viewDidLoad")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func dismissPressed()
    {
        self.dismissGameViewController()
    }
    
    
    func dismissGameViewController()
    {
        dismiss(animated: true, completion: nil)
    }
}