//
//  ScoreViewController.swift
//  BreakoutClone
//
//  Created by Andrew Goettler on 10/13/16.
//  Copyright © 2016 Andrew Goettler. All rights reserved.
//

import UIKit

class ScoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var highScores: [Int] = []
    
    let highScoreSize: Int = 5
    
    @IBOutlet weak var highScoreTable: UITableView!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        print("ScoreViewController viewDidLoad")
        
        if let storedScores = UserDefaults.standard.array(forKey: "highScores") as! [Int]?
        {
            highScores = storedScores
        }
        
        else
        {
            print("No list of high scores available")
        }
        
        self.highScoreTable.reloadData()
    }

    override func didReceiveMemoryWarning()
    {
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
    
    // required functions for UITableViewDataSource protocol
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return highScores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellNumber: Int = indexPath.row
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "scoreCell")! as UITableViewCell
        
        cell.textLabel!.text = "No. \(cellNumber + 1): \(highScores[cellNumber])"
        
        return cell
    }
    
    // two optional UITableViewDelegate functions
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath)
    {
        // some tutorials demonstrate issuing the segue from here; am confused
        print("Did select row: \(indexPath.row)")
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?
    {
        print("Will select row: \(indexPath.row)")
        
        return indexPath
    }

    @IBAction func dismissButtonPressed(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
}
