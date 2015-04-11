//
//  Helper.swift
//  BLCircularProgress-Swift
//
//  Created by Boyi on 4/4/15.
//  Copyright (c) 2015 boyi. All rights reserved.
//

import CoreGraphics

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
