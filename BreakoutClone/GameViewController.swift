//
//  GameViewController.swift
//  BreakoutClone
//
//  Created by Andrew Goettler on 10/13/16.
//  Copyright © 2016 Andrew Goettler. All rights reserved.
//

/*
 Blocks should be 80x40; arranged 4 blocks wide and 8 blocks high. A space of 7 or 8 should be left between each block Each band of color is two blocks in height.
From bottom to top:
    Row 0: Solarized Yellow
    Row 1: Solarized Green
    Row 2: Solarized Blue
    Row 3: Solarized Red
 
 */
import UIKit

class GameViewController: UIViewController, UICollisionBehaviorDelegate
{    
    // paddle should stay on screen; ball and blocks should be added and removed programmatically
    @IBOutlet weak var paddle: UIView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var ballCountLabel: UILabel!
    
    var ball: CircleView!
    
    var gameAnimator: UIDynamicAnimator!
    
    var paddleProps: UIDynamicItemBehavior!
    var ballProps: UIDynamicItemBehavior!
    var blockProps: UIDynamicItemBehavior!
    
    var gravityBehavior: UIGravityBehavior!
    var collisionBehavior: UICollisionBehavior!
    var ballPushBehavior: UIPushBehavior!

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
        
        createBall()
        
        initializeDynamics()
        
        startBall()
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
        
        ballProps = UIDynamicItemBehavior(items: [ball])
        ballProps.resistance = 0.0
        ballProps.elasticity = 1.0
        ballProps.friction = 0.0
        
        gameAnimator.addBehavior(ballProps)
        
        gravityBehavior = UIGravityBehavior(items: [ball])
        gravityBehavior.magnitude = 0.2
        
        gameAnimator.addBehavior(gravityBehavior)
        
        collisionBehavior = UICollisionBehavior(items: [ball, paddle])
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        collisionBehavior.collisionDelegate = self
        
        gameAnimator.addBehavior(collisionBehavior)
        
        ballPushBehavior = UIPushBehavior(items: [ball], mode: UIPushBehaviorMode.instantaneous)
        gameAnimator.addBehavior(ballPushBehavior)
    }
    
    @IBAction func handlePanGesture(_ sender: UIPanGestureRecognizer)
    {
        paddle.center.x += sender.translation(in: self.view).x
        
        // apparently this is important, otherwise the translation is cumulative - stuff flies off the screen!
        sender.setTranslation(CGPoint(x: 0, y: 0), in: self.view)
        
        gameAnimator.updateItem(usingCurrentState: paddle)
    }
    
    func createBall()
    {
        // create and position the ball at the paddle
        ball = CircleView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        ball.center.x = paddle.center.x
        ball.center.y = paddle.center.y - ball.bounds.height - 30
        self.view.addSubview(ball)
        
        
    }
    
    func startBall()
    {
        // give the ball a kick to start
        ballPushBehavior.magnitude = 0.5
        ballPushBehavior.angle = 90.0
        ballPushBehavior.active = true
    }
}
