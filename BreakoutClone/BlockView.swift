//
//  BlockView.swift
//  BreakoutClone
//
//  Created by Andrew Goettler on 10/15/16.
//  Copyright © 2016 Andrew Goettler. All rights reserved.
//

import UIKit

class BlockView: UIView
{
    let scoreValue: Int
    
    override init(frame: CGRect)
    {
        self.scoreValue = 0
        
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        self.scoreValue = 0
        
        super.init(coder: aDecoder)
        
        setup()
    }
    
    init(frame: CGRect, pointValue: Int)
    {
        self.scoreValue = pointValue
        
        super.init(frame: frame)
        
        setup()
    }
    
    func setup()
    {
        
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) 
    {
        // Drawing code
    }
    */
}
