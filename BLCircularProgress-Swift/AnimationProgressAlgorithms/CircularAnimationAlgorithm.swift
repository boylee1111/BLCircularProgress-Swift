//
//  CircularAnimationAlgorithm.swift
//  BLCircularProgress-Swift
//
//  Created by Boyi on 4/11/15.
//  Copyright (c) 2015 boyi. All rights reserved.
//

import Foundation

class CircularAnimationAlgorithm : AnimationProgressAlgorithm, AnimationProgressAlgorithmProtocol {
    override func easeIn(var currentTime: Double, startValue: Double, changeInValue: Double, duration: Double) -> Double {
        currentTime /= duration
        return -changeInValue * (sqrt(1 - currentTime * currentTime) - 1) + startValue
    }
    
    override func easeOut(var currentTime: Double, startValue: Double, changeInValue: Double, duration: Double) -> Double {
        currentTime /= duration
        currentTime--
        return changeInValue * sqrt(1 - currentTime * currentTime) + startValue
    }
    
    override func easeInEaseOut(var currentTime: Double, startValue: Double, changeInValue: Double, duration: Double) -> Double {
        currentTime /= duration / 2
        if currentTime < 1 {
            return -changeInValue / 2 * (sqrt(1 - currentTime * currentTime) - 1) + startValue
        }
        currentTime -= 2
        return changeInValue / 2 * (sqrt(1 - currentTime * currentTime) + 1) + startValue
    }
}
