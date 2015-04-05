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
    case CircularProgressStartAngleEast  = 0.0
    case CircularProgressStartAngleSouth = 90.0
    case CircularProgressStartAngleWest  = 180.0
}

enum SlideStatus {
    case SlideStatusNone
    case SlideStatusInBorder
    case SlideStatusOutOfBorderFromMinimumValue
    case SlideStatusOutOfBorderFromMaximumValue
}

public class BLCircularProgressView: UIView {
    private var currentSlideStatus: SlideStatus = .SlideStatusNone
    private var circleCenter: CGPoint = CGPoint()
    private var circleRadius: Double = 0
    private var circleWidth: Double = 0
    
    private var currentSegmentNumber: Int = 0
    private var startProgressValue: Double = 0
    private var progressUpdateDiff: Double = 0
    
    public var progress: Double = 0{
        didSet {
            progress = min(maximaProgress, max(minimaProgress, progress))
            self.setNeedsDisplay()
        }
    }
    
    public var maxProgress: Double = 100 { didSet { self.setNeedsDisplay() } }
    public var minProgress: Double = 0 { didSet { self.setNeedsDisplay() } }
    public var maximaProgress: Double = 100 {
        didSet {
            if maximaProgress > maxProgress {
                maximaProgress = maxProgress
            }
            self.setNeedsDisplay()
        }
    }
    public var minimaProgress: Double = 0 {
        didSet {
            if minimaProgress < minProgress {
                minimaProgress = minProgress
            }
            self.setNeedsDisplay()
        }
    }
    
    public var clockwise: Bool = true { didSet { self.setNeedsDisplay() } }
    public var startAngle: Double = 0 {
        didSet {
            startAngle = fmod(startAngle, 360.0)
            if (startAngle < 0) {
                startAngle += 360.0
            }
            self.setNeedsDisplay()
        }
    }
    public var thicknessRadio: Double = 0.2 { didSet { self.setNeedsDisplay() } }
    public var progressAnimationDuration: Double = 0.8
    public var animationAlgorithm: AnimationAlgorithm = .AnimationAlgorithmSimpleLinear
    public var animationType: AnimationType
    
    public var touchResponseOuterShiftValue: Double = 5
    public var touchResponseInnerShiftValue: Double = 5
    
    public var progressFillColor: UIColor? = UIColor.blackColor() { didSet { self.setNeedsDisplay() } }
    public var progressTopGradientColor: UIColor? { didSet { self.setNeedsDisplay() } }
    public var progressBottomGradientColor: UIColor? { didSet { self.setNeedsDisplay() } }
    
    public required init(coder aDecoder: NSCoder) {
        func defaultFunction(a: Double, b: Double, c: Double, d: Double) -> Double { return 0 }
        self.animationType = .AnimationTypeEaseInEaseOut(defaultFunction)
        super.init(coder: aDecoder)
    }
    
    public override init(frame: CGRect) {
        func defaultFunction(a: Double, b: Double, c: Double, d: Double) -> Double { return 0 }
        self.animationType = .AnimationTypeEaseInEaseOut(defaultFunction)
        super.init(frame: frame)
    }
    
    // MARK: - Drawing
    
    override public func drawRect(rect: CGRect) {
        var progressAngle: Double;
        if clockwise {
            progressAngle = (progress - minProgress) / (maxProgress - minProgress) * 360.0 + startAngle
        } else {
            progressAngle = 360.0 - (progress - minProgress) / (maxProgress - minProgress) * 360.0 + startAngle
        }
        circleCenter = CGPoint(x: rect.size.width / 2.0, y: rect.size.height / 2.0)
        circleRadius = min(Double(rect.size.width), Double(rect.size.height)) / 2.0 - 1.0
        circleWidth = circleRadius * thicknessRadio
        
        self.backgroundColor = UIColor.clearColor()
        
        var square: CGRect
        if rect.size.width > rect.size.height {
            square = CGRect(x: (rect.size.width - rect.size.height) / 2.0, y: 0.0, width: rect.size.height, height: rect.size.height)
        } else {
            square = CGRect(x: 0.0, y: (rect.size.height - rect.size.width) / 2.0, width: rect.size.width, height: rect.size.width)
        }
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSaveGState(context)
        
        let path = UIBezierPath()
        
        path.appendPath(UIBezierPath(
            arcCenter: circleCenter,
            radius: CGFloat(circleRadius),
            startAngle: CGFloat(degreesToRadians(startAngle)),
            endAngle: CGFloat(degreesToRadians(progressAngle)),
            clockwise: clockwise))
        
        path.addArcWithCenter(
            circleCenter,
            radius: CGFloat(circleRadius - circleWidth),
            startAngle: CGFloat(degreesToRadians(progressAngle)),
            endAngle: CGFloat(degreesToRadians(startAngle)),
            clockwise: clockwise)
        
        path.closePath()
        
        if let progressFillColor = progressFillColor? {
            progressFillColor.setFill()
            path.fill()
        } else if progressTopGradientColor != nil && progressBottomGradientColor != nil {
            path.addClip()
            
            let backgroundColors = [progressTopGradientColor?.CGColor!, progressBottomGradientColor?.CGColor!]
            let cfBackgroundColors = CFArrayCreate(nil, UnsafeMutablePointer<UnsafePointer<Void>>(backgroundColors), backgroundColors.count, nil)
            let backgroundColorLocations: [CGFloat] = [0.0, 1.0]
            let rgb = CGColorSpaceCreateDeviceRGB()
            let backgroundGradient = CGGradientCreateWithColors(rgb, cfBackgroundColors, backgroundColorLocations)
            
            CGContextDrawLinearGradient(context, backgroundGradient, CGPoint(x: 0.0, y: square.origin.y), CGPoint(x: 0.0, y: square.size.height), 0)
        }
        
        CGContextSaveGState(context)
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
