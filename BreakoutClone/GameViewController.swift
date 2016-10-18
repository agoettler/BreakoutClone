//
//  GameViewController.swift
//  BreakoutClone
//
//  Created by Andrew Goettler on 10/13/16.
//  Copyright © 2016 Andrew Goettler. All rights reserved.
//

/*
 Blocks should be 80x40; arranged 4 blocks wide and 8 blocks high. A space of 7 or 8 should be left between each block Each band of color is two blocks in height.
From top to bottom:
    Row 0: Solarized Red
    Row 1: Solarized Blue
    Row 2: Solarized Green
    Row 3: Solarized Yellow
 
 */
import UIKit

class GameViewController: UIViewController, UICollisionBehaviorDelegate
{
    var score: Int = 0
    
    var ballCount: Int = 3
    
    // paddle should stay on screen; ball and blocks should be added and removed programmatically
    @IBOutlet weak var paddle: UIView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var ballCountLabel: UILabel!
    
    var ball: CircleView!
    
    var blocks: [BlockView] = []
    let blockSize: CGSize = CGSize(width: 80.0, height: 40.0)
    let blockSpace: CGFloat = 8.0
    let cornerCoordinates: CGPoint = CGPoint(x: 16.0, y: 49.0 ) // (16,49)
    let blockRows = 8
    let blockColumns = 4
    let blockScores: [Int] = [4, 3, 2, 1]
    
    // UIColor uses color values between 0.0 and 1.0, requiring conversion
    let solarizedRed: UIColor = UIColor(red: 220.0/255.0, green: 50.0/255.0, blue: 47.0/255.0, alpha: 1.0)
    let solarizedBlue: UIColor = UIColor(red: 38.0/255.0, green: 139.0/255.0, blue: 210.0/255.0, alpha: 1.0)
    let solarizedGreen: UIColor = UIColor(red: 133.0/255.0, green: 153.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    let solarizedYellow: UIColor = UIColor(red: 181.0/255.0, green: 137.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    var blockColors: [UIColor]!
    
    var gameAnimator: UIDynamicAnimator!
    
    var paddleProps: UIDynamicItemBehavior!
    var ballProps: UIDynamicItemBehavior!
    var blockProps: UIDynamicItemBehavior!
    
    var gravityBehavior: UIGravityBehavior!
    var collisionBehavior: UICollisionBehavior!
    var ballPushBehavior: UIPushBehavior!
    
    // NSString identifiers for collision boundaries, because NSCopying is weird
    let topBoundary: NSString = "top"
    let leftBoundary: NSString = "left"
    let rightBoundary: NSString = "right"
    let bottomBoundary: NSString = "bottom"

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        print("GameViewController viewDidLoad")
        
        blockColors = [solarizedRed, solarizedBlue, solarizedGreen, solarizedYellow]
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        print("GameViewController viewDidAppear")
        
        createBall()
        
        createBlocks()
        
        initializeDynamics()
        
        report()
        
        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.report), userInfo: nil, repeats: true)
        
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
        // nested functions for organization
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
            collisionItems.append(contentsOf: blocks as [UIView])
            collisionBehavior = UICollisionBehavior(items: collisionItems)
            //collisionBehavior.translatesReferenceBoundsIntoBoundary = true
            
            //in order to detect collisions with the bottom boundary, need to define collision boundaries manually
            collisionBehavior.addBoundary(withIdentifier: topBoundary, from: self.view.bounds.origin, to: CGPoint(x: self.view.bounds.maxX, y: 0))
            collisionBehavior.addBoundary(withIdentifier: leftBoundary, from: self.view.bounds.origin, to: CGPoint(x: 0, y: self.view.bounds.maxY))
            collisionBehavior.addBoundary(withIdentifier: rightBoundary, from: CGPoint(x: self.view.bounds.maxX, y: 0), to: CGPoint(x: self.view.bounds.maxX, y: self.view.bounds.maxY))
            
            // try to define the bottom boundary below the display, so the ball can "drain"
            collisionBehavior.addBoundary(withIdentifier: bottomBoundary, from: CGPoint(x: 0, y: self.view.bounds.maxY + (2 * ball.bounds.height)), to: CGPoint(x: self.view.bounds.maxX, y: self.view.bounds.maxY + (2 * ball.bounds.height)))
            
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
        
        // configure behaviors and add them to the animator
        gameAnimator = UIDynamicAnimator(referenceView: self.view)
        
        // configure and add the paddle behavior
        configurePaddlePropsBehavior()
        gameAnimator.addBehavior(paddleProps)
        
        // configure and add the ball behavior
        configureBallPropsBehavior()
        gameAnimator.addBehavior(ballProps)
        
        // configure and add the gravity behavior
        gravityBehavior = UIGravityBehavior(items: [ball])
        gravityBehavior.magnitude = 0.0
        gameAnimator.addBehavior(gravityBehavior)
        
        // configure and add the collision behavior
        configureCollisionBehavior()
        gameAnimator.addBehavior(collisionBehavior)
        
        // configure and add the ball push behavior
        ballPushBehavior = UIPushBehavior(items: [ball], mode: UIPushBehaviorMode.instantaneous)
        gameAnimator.addBehavior(ballPushBehavior)
        
        // configure and add the block behavior
        configureBlockPropsBehaviors()
        gameAnimator.addBehavior(blockProps)
    }
    
    func report()
    {
        func reportBall()
        {
            print("ball origin: (\(ball.center.x), \(ball.center.y))", terminator: "")
        
            let ballVelocity: CGPoint = ballProps.linearVelocity(for: ball)
            
            print(", velocity: (\(ballVelocity.x), \(ballVelocity.y))")
        }
        
        func reportPaddle()
        {
            print("paddle origin: (\(paddle.center.x), \(paddle.center.y))", terminator: "")
            
            let paddleVelocity: CGPoint = paddleProps.linearVelocity(for: paddle)
            
            print(", velocity: (\(paddleVelocity.x), \(paddleVelocity.y))")
        }
        
        //reportBall()
        
        //reportPaddle()
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
        ballPushBehavior.magnitude = 0.2
        
        ballPushBehavior.angle = CGFloat.pi/2
        
        ballPushBehavior.active = true
    }
    
    func drainBall()
    {
        // decrement and update the ball counter
        ballCount -= 1
        
        ballCountLabel.text! = "Ball: \(ballCount)"
        
        // stop the ball
        //ballProps.addLinearVelocity(ballProps.linearVelocity(for: ball).applying(CGAffineTransform(scaleX: -1, y: -1)), for: ball)
        
        // dispose of the ball entirely
        collisionBehavior.removeItem(ball)
        ballProps.removeItem(ball)
        ballPushBehavior.removeItem(ball)
        gravityBehavior.removeItem(ball)
        
        ball.removeFromSuperview()
        
        // create a new ball
        createBall()
        collisionBehavior.addItem(ball)
        ballProps.addItem(ball)
        ballPushBehavior.addItem(ball)
        gravityBehavior.addItem(ball)
        startBall()
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
                
                blocks.append(BlockView(frame: CGRect(origin: newOrigin, size: blockSize), scoreValue: blockScores[row/2]))
                
                // integer division allows 0,1 to map to 0, 2,3 to map to 2, etc.
                blocks.last!.backgroundColor = blockColors![row/2]
                
                self.view.addSubview(blocks.last!)
            }
        }
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior, endedContactFor item1: UIDynamicItem, with item2: UIDynamicItem)
    {
        func handleBlockCollision(item: BlockView)
        {
            //print("Block detected a collision")
            
            collisionBehavior.removeItem(item)
            
            item.removeFromSuperview()
            
            self.score += item.scoreValue
            
            self.scoreLabel.text! = "Score: \(self.score)"
            
            
        }
        
        //print("\(item1.description) ended contact with \(item2.description)")
        
        // it's safe to cast the item as a BlockView, since the if statements test the class membership
        if item1.isMember(of: BlockView.self)
        {
            handleBlockCollision(item: item1 as! BlockView)
        }
        
        else if item2.isMember(of: BlockView.self)
        {
            handleBlockCollision(item: item2 as! BlockView)
        }
    }
    
    
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint)
    {
        if let boundary = identifier
        {
            if boundary as! NSString == bottomBoundary
            {
                print("Ball collided with bottom boundary")
                
                drainBall()
            }
        }
    }
    
}
