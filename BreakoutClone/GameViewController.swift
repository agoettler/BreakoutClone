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
    
    var blocks: [UIView] = []
    let blockSize: CGSize = CGSize(width: 80.0, height: 40.0)
    let blockSpace: CGFloat = 8.0
    let cornerCoordinates: CGPoint = CGPoint(x: 16.0, y: 49.0 ) // (16,49)
    let blockRows = 8
    let blockColumns = 4
    
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
        
        createBlocks()
        
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
        func configurePaddlePropsBehavior()
        {
            paddleProps = UIDynamicItemBehavior(items: [paddle])
            paddleProps.resistance = 0.0
            paddleProps.elasticity = 1.0
            paddleProps.friction = 0.0
            paddleProps.isAnchored = true
            paddleProps.allowsRotation = false
        }
        
        func configureBallPropsBehavior()
        {
            ballProps = UIDynamicItemBehavior(items: [ball])
            ballProps.resistance = 0.0
            ballProps.elasticity = 1.0
            ballProps.friction = 0.0
        }
        
        func configureCollisionBehavior()
        {
            var collisionItems: [UIView] = [ball, paddle]
            collisionItems.append(contentsOf: blocks)
            collisionBehavior = UICollisionBehavior(items: collisionItems)
            collisionBehavior.translatesReferenceBoundsIntoBoundary = true
            collisionBehavior.collisionDelegate = self
        }
        
        func configureBlockPropsBehaviors()
        {
            blockProps = UIDynamicItemBehavior(items: blocks)
            blockProps.resistance = 0.0
            blockProps.elasticity = 1.0
            blockProps.friction = 0.0
            blockProps.isAnchored = true
            blockProps.allowsRotation = false
        }
        
        gameAnimator = UIDynamicAnimator(referenceView: self.view)
        
        configurePaddlePropsBehavior()
        gameAnimator.addBehavior(paddleProps)
        
        configureBallPropsBehavior()
        gameAnimator.addBehavior(ballProps)
        
        gravityBehavior = UIGravityBehavior(items: [ball])
        gravityBehavior.magnitude = 0.2
        gameAnimator.addBehavior(gravityBehavior)
        
        configureCollisionBehavior()
        gameAnimator.addBehavior(collisionBehavior)
        
        ballPushBehavior = UIPushBehavior(items: [ball], mode: UIPushBehaviorMode.instantaneous)
        gameAnimator.addBehavior(ballPushBehavior)
        
        configureBlockPropsBehaviors()
        gameAnimator.addBehavior(blockProps)
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
        ballPushBehavior.angle = CGFloat.pi/2
        ballPushBehavior.active = true
    }
    
    func createBlocks()
    {
        for row in 0..<blockRows
        {
            for column in 0..<blockColumns
            {
                let newOrigin: CGPoint = CGPoint(x: cornerCoordinates.x + ((blockSize.width + blockSpace) * CGFloat(column)), y: cornerCoordinates.y + ((blockSize.height + blockSpace) * CGFloat(row)))
                
                //print("Creating new block at: (\(newOrigin.x),\(newOrigin.y))")
                //print("Creating new block at row: \(row), column: \(column)")
                
                blocks.append(UIView(frame: CGRect(origin: newOrigin, size: blockSize)))
                
                blocks.last!.backgroundColor = UIColor.red
                
                self.view.addSubview(blocks.last!)
            }
        }
    }
}
