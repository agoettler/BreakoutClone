//
//  CircleView.swift
//  BreakoutClone
//
//  Created by Andrew Goettler on 10/14/16.
//  Copyright © 2016 Andrew Goettler. All rights reserved.
//

import UIKit

class CircleView: UIView
{
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    func setup()
    {
        // make the background transparent
        self.isOpaque = false
    }
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect)
    {
        // Drawing code
        UIColor.black.setFill()
        
        let circle: UIBezierPath = UIBezierPath(ovalIn: rect)
        circle.addClip()
        circle.fill()
    }
    
    override var collisionBoundsType: UIDynamicItemCollisionBoundsType
    {
        return .ellipse
    }
}
