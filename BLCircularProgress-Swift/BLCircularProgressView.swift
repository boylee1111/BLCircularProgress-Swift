//
//  BLCircularProgressView.swift
//  BLCircularProgress-Swift
//
//  Created by Boyi on 4/3/15.
//  Copyright (c) 2015 boyi. All rights reserved.
//

import UIKit

let shiftPercentageWhenOutOfBoard: Double = 0.05
let progressUpdateAnimationFramesPerSecond: Double = 80

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

@objc public protocol BLCircularProgressViewProtocol: NSObjectProtocol {
    optional func circularTouchesBegan(circularProgressView: BLCircularProgressView, progress: Double)
    optional func circularTouchesMoved(circularProgressView: BLCircularProgressView, progress: Double)
    optional func circularTouchesEnded(circularProgressView: BLCircularProgressView, progress: Double)
    optional func circularTouchesCancelled(circularProgressView: BLCircularProgressView, progress: Double)
    
    optional func circularAnimationBegan(circularProgressView: BLCircularProgressView, progress: Double)
    optional func circularAnimationDuring(circularProgressView: BLCircularProgressView, progress: Double)
    optional func circularAnimationEnded(circularProgressView: BLCircularProgressView, progress: Double)
}

public class BLCircularProgressView: UIView {
    private var currentSlideStatus: SlideStatus = .SlideStatusNone
    private var circleCenter: CGPoint = CGPoint()
    private var circleRadius: Double = 0
    private var circleWidth: Double = 0
    
    private var currentSegmentNumber: Int = 0
    // A closure that animation update the progress, first return value is animation count, second is current value
    private var progressCalculateClosure: (() -> (segmengCount: Int, progressValue: Double))?
    private var animationProgressAlgorithm: AnimationProgressAlgorithm = CubicAnimationAlgorithm()
    
    weak public var delegate: BLCircularProgressViewProtocol?
    
    public var progress: Double = 0 {
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
    public var animationAlgorithm: AnimationAlgorithm = .AnimationAlgorithmCubic {
        didSet {
            self.setAnimationProgressAlgorithmWithAnimationAlgorithm(animationAlgorithm)
        }
    }
    public var animationType: AnimationType = .AnimationTypeEaseInEaseOut
    
    public var touchResponseOuterShiftValue: Double = 5
    public var touchResponseInnerShiftValue: Double = 5
    
    public var progressFillColor: UIColor? { didSet { self.setNeedsDisplay() } }
    public var progressTopGradientColor: UIColor? = UIColor(red: 0.992156863, green: 0.929411765, blue: 0.866666667, alpha: 1.0)
        { didSet { self.setNeedsDisplay() } }
    public var progressBottomGradientColor: UIColor? = UIColor(red: 0.97254902, green: 0.764705882, blue: 0.568627451, alpha: 1.0)
        { didSet { self.setNeedsDisplay() } }
    
    // MARK: - init
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public func updateStartAngleWithPresetValue(circularProgressStartAngle: CircularProgressStartAngle) {
        self.startAngle = circularProgressStartAngle.rawValue
    }
    
    public func animateProgress(var newProgress: Double, completion: ((Double) -> Void)?) {
        newProgress = min(self.maximaProgress, max(self.minimaProgress, newProgress))
        let startProgressValue = self.progress
        let progressUpdateDiff = newProgress - startProgressValue
        self.userInteractionEnabled = false
        currentSlideStatus = .SlideStatusNone
        
        progressCalculateClosure = self.makeProgressCalculateClosure(startProgressValue, changeInvalue: progressUpdateDiff)
        NSTimer.scheduledTimerWithTimeInterval(1 / progressUpdateAnimationFramesPerSecond, target: self, selector: "updateProgress:", userInfo: nil, repeats: true)
        
        self.delegate?.circularTouchesBegan?(self, progress: self.progress)
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
            clockwise: !clockwise)
        
        path.closePath()
        
        if let fillColor = progressFillColor{
            fillColor.setFill()
            path.fill()
        } else if let topColor = progressTopGradientColor, bottomColor = progressBottomGradientColor {
            path.addClip()
            
            let backgroundColors = [topColor.CGColor!, bottomColor.CGColor!]
            let cfBackgroundColors = CFArrayCreate(nil, UnsafeMutablePointer<UnsafePointer<Void>>(backgroundColors), backgroundColors.count, nil)
            let backgroundColorLocations: [CGFloat] = [0.0, 1.0]
            let rgb = CGColorSpaceCreateDeviceRGB()
            let backgroundGradient = CGGradientCreateWithColors(rgb, cfBackgroundColors, backgroundColorLocations)
            
            CGContextDrawLinearGradient(
                context,
                backgroundGradient,
                CGPoint(x: 0.0, y: square.origin.y),
                CGPoint(x: 0.0, y: square.size.height),
                0)
        }
        
        CGContextSaveGState(context)
    }
    
    // MARK: - Touches Events
    
    public override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        if let touch = touches.first as? UITouch {
            let touchLocation = touch.locationInView(self)
            
            if twoPointAbsoluteDistance(touchLocation, self.circleCenter) < self.circleRadius + self.touchResponseOuterShiftValue && twoPointAbsoluteDistance(touchLocation, self.circleCenter) > self.circleRadius - self.circleWidth - self.touchResponseInnerShiftValue {
                self.currentSlideStatus = .SlideStatusInBorder
            }
        }
        
        self.delegate?.circularTouchesBegan?(self, progress: self.progress)
        super.touchesBegan(touches, withEvent: event)
    }
    
    public override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        if let touch = touches.first as? UITouch {
            let touchLocation = touch.locationInView(self)
            let angle = fmod(angleFromNorth(self.circleCenter, touchLocation), 360.0)
            let angleDistanceFromStart = twoAngleAbsoluteDistance(self.startAngle, angle, self.clockwise)
            let progressTmp = (self.maxProgress - minProgress) * angleDistanceFromStart / 360.0 + self.minProgress
            
            switch currentSlideStatus {
            case .SlideStatusNone:
                return ;
            case .SlideStatusInBorder:
                let maximaProgressAngle = (self.maximaProgress - self.minProgress) / (self.maxProgress - self.minProgress) * 360 + self.startAngle
                let minimaProgressAngle = (self.minimaProgress - self.minProgress) / (self.maxProgress - self.minProgress) * 360 + self.startAngle
                // The absolution angle difference from target angle to maxima angle or minima angle
                let toMaximaProgressAngle = twoAngleAbsoluteDistance(angle, maximaProgressAngle, self.clockwise)
                let toMinimaProgressAngle = twoAngleAbsoluteDistance(angle, minimaProgressAngle, !self.clockwise)
                
                if progressTmp < self.maximaProgress && progressTmp > self.minimaProgress {
                    self.progress = progressTmp
                } else {
                    if (toMaximaProgressAngle <= toMinimaProgressAngle) {
                        self.progress = self.minimaProgress
                        currentSlideStatus = .SlideStatusOutOfBorderFromMinimumValue
                    } else {
                        self.progress = self.maximaProgress
                        currentSlideStatus = .SlideStatusOutOfBorderFromMaximumValue
                    }
                }
            case .SlideStatusOutOfBorderFromMinimumValue:
                if progressTmp >= self.minimaProgress && progressTmp < self.minimaProgress + shiftValueWhenOutOfBoard(self.maxProgress - self.minProgress) {
                    currentSlideStatus = .SlideStatusInBorder
                }
            case .SlideStatusOutOfBorderFromMaximumValue:
                if progressTmp <= self.maximaProgress && progressTmp > self.maximaProgress - shiftValueWhenOutOfBoard(self.maxProgress - self.minProgress) {
                    currentSlideStatus = .SlideStatusInBorder
                }
            }
        }
        
        self.delegate?.circularTouchesMoved?(self, progress: self.progress)
        super.touchesMoved(touches, withEvent: event)
    }
    
    public override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        currentSlideStatus = .SlideStatusNone
        
        self.delegate?.circularTouchesEnded?(self, progress: self.progress)
        super.touchesEnded(touches, withEvent: event)
    }
    
    public override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!) {
        currentSlideStatus = .SlideStatusNone
        
        self.delegate?.circularTouchesCancelled?(self, progress: self.progress)
        super.touchesCancelled(touches, withEvent: event)
    }
    
    // MARK: - Helper Methods
    
    func setAnimationProgressAlgorithmWithAnimationAlgorithm(animationAlgorithm: AnimationAlgorithm) {
        switch animationAlgorithm {
        case .AnimationAlgorithmSimpleLinear:
            animationProgressAlgorithm = SimpleLinearAnimationAlgorithm()
        case .AnimationAlgorithmQuadratic:
            animationProgressAlgorithm = QuadraticAnimationAlgorithm()
        case .AnimationAlgorithmCubic:
            animationProgressAlgorithm = CubicAnimationAlgorithm()
        case .AnimationAlgorithmQuartic:
            animationProgressAlgorithm = QuarticAnimationAlgorithm()
        case .AnimationAlgorithmQuintic:
            animationProgressAlgorithm = QuinticAnimationAlgorithm()
        case .AnimationAlgorithmSinusoidal:
            animationProgressAlgorithm = SinusoidalAnimationAlgorithm()
        case .AnimationAlgorithmExponential:
            animationProgressAlgorithm = ExponentialAnimationAlgorithm()
        case .AnimationAlgorithmCircular:
            animationProgressAlgorithm = CircularAnimationAlgorithm()
        }
    }
    
    // Function called by timer to update progress periodically
    func updateProgress(timer: NSTimer) {
        let calculateResult = progressCalculateClosure!()
        let segmentCount = calculateResult.0
        if segmentCount >= Int(progressUpdateAnimationFramesPerSecond * self.progressAnimationDuration) {
            self.userInteractionEnabled = true
            timer.invalidate()
            
            self.delegate?.circularAnimationEnded?(self, progress: self.progress)
            return ;
        }
        self.progress = calculateResult.1
    }
    
    // Generate the closure that calculate update count and update value
    func makeProgressCalculateClosure(value: Double, changeInvalue: Double) -> () -> (segmengCount: Int, progressValue: Double) {
        var runningValue = value
        var segmentCount = 0
        let startValue = value
        let calculateAlgorithmClosure = animationProgressAlgorithm.animationAlgorithm(self.animationType)
        
        func calculateStepClosure() -> (Int, Double) {
            segmentCount++
            runningValue = calculateAlgorithmClosure(Double(segmentCount) / progressUpdateAnimationFramesPerSecond, startValue, changeInvalue, self.progressAnimationDuration)
            
            self.delegate?.circularAnimationDuring?(self, progress: self.progress)
            return (segmentCount, runningValue)
        }
        return calculateStepClosure
    }
}

// Mark: - Helper Methods

func shiftValueWhenOutOfBoard(progressDiff: Double) -> Double {
    return progressDiff * shiftPercentageWhenOutOfBoard
}

postfix operator ** { } // square function

postfix func **(num: Double) -> Double{
    return num * num;
}

func degreesToRadians(degrees: Double) -> Double {
    return degrees / 180.0 * M_PI
}

func radiansToDegrees(radians: Double) -> Double {
    return radians * 180.0 / M_PI
}

func twoPointAbsoluteDistance(point1: CGPoint, point2: CGPoint) -> Double {
    return sqrt((Double((point1.x - point2.x))** + Double((point1.y - point2.y))**))
}

func twoAngleAbsoluteDistance(var fromAngle: Double, var toAngle: Double, clockwise: Bool) -> Double {
    fromAngle = fmod(fromAngle, 360.0)
    toAngle = fmod(toAngle, 360.0)
    var angleDifference = toAngle - fromAngle
    angleDifference = clockwise ? angleDifference : -angleDifference
    angleDifference = fmod(angleDifference, 360.0)
    return (angleDifference >= 0 ? angleDifference : angleDifference + 360.0)
}

func angleFromNorth(fromPoint: CGPoint, toPoint: CGPoint) -> Double {
    var v = CGPoint(x: toPoint.x - fromPoint.x, y: toPoint.y - fromPoint.y)
    var vmag: Double = sqrt(Double(v.x)** + Double(v.y)**), result: Double = 0
    v.x /= CGFloat(vmag)
    v.y /= CGFloat(vmag)
    var radians: Double = Double(atan2(v.y, v.x))
    result = radiansToDegrees(radians)
    return (result >= 0 ? result: result + 360.0)
}
