//
//  GameViewController.swift
//  BreakoutClone
//
//  Created by Andrew Goettler on 10/13/16.
//  Copyright © 2016 Andrew Goettler. All rights reserved.
//

import UIKit

class GameViewController: UIViewController
{
    // paddle should stay on screen; ball and blocks should be added and removed programmatically
    @IBOutlet weak var paddle: UIView!

    
    var gameAnimator: UIDynamicAnimator!
    
    var paddleProps: UIDynamicItemBehavior!
    var ballProps: UIDynamicItemBehavior!
    var blockProps: UIDynamicItemBehavior!
    
    var gravityBehavior: UIGravityBehavior!
    var collisionBehavior: UICollisionBehavior!

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        print("GameViewController viewDidLoad")
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        print("GameViewController viewDidAppear")
        
        initializeDynamics()
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
    
    func initializeDynamics()
    {
        gameAnimator = UIDynamicAnimator(referenceView: self.view)
        
        paddleProps = UIDynamicItemBehavior(items: [paddle])
        paddleProps.resistance = 0.0
        paddleProps.elasticity = 1.0
        paddleProps.friction = 0.0
        paddleProps.isAnchored = true
        paddleProps.allowsRotation = false
        
        gameAnimator.addBehavior(paddleProps)
    }
    
    @IBAction func handlePanGesture(_ sender: UIPanGestureRecognizer)
    {
        paddle.center.x += sender.translation(in: self.view).x
        
        // apparently this is important, otherwise the translation is cumulative - stuff flies off the screen!
        sender.setTranslation(CGPoint(x: 0, y: 0), in: self.view)
        
        gameAnimator.updateItem(usingCurrentState: paddle)
    }
    
}
