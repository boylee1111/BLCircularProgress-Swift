//
//  BLCircularProgressView.swift
//  BLCircularProgress-Swift
//
//  Created by Boyi on 4/3/15.
//  Copyright (c) 2015 boyi. All rights reserved.
//

import UIKit

public enum CircularProgressStartAngle : Double {
    case CircularProgressStartAngleNorth = 270.0
    case CircularProgressStartAngleEast = 0.0
    case CircularProgressStartAngleSouth = 90.0
    case CircularProgressStartAngleWest = 180.0
}

enum SlideStatus {
    case SlideStatusNone
    case SlideStatusInBorder
    case SlideStatusOutOfBorderFromMinimumValue
    case SlideStatusOutOfBorderFromMaximumValue
}

public class BLCircularProgressView: UIView {

    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var progress: Double
    
    public var maxProgress: Double
    public var minProgress: Double
    public var maximaProgress: Double
    public var minimaProgress: Double
    
    public var clockwise: Bool
    public var startAngle: Double
    public var thicknessRadio: Double
    public var progressAnimationDuration: Double
    public var animationAlgorithm: AnimationAlgorithm
    public var animationType: AnimationType
    
    public var touchResponseOuterShiftValue: Double
    public var touchResponseInnerShiftValue: Double
    
    public var progressFillColor: UIColor?
    public var progressTopGradientColor: UIColor?
    public var progressBottomGradientColor: UIColor?

    override public class func initialize() {
        var appearance = self.appearance()
    }
    
    override public func drawRect(rect: CGRect) {
        // Drawing code
    }
    
    // MARK: - touches event
    
    public override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)
    }
    
    public override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        super.touchesMoved(touches, withEvent: event)
    }
    
    public override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        super.touchesEnded(touches, withEvent: event)
    }
    
    public override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
        super.touchesCancelled(touches, withEvent: event)
        
    }
}
