//
//  QuadraticAnimationAlgorithm.swift
//  BLCircularProgress-Swift
//
//  Created by Boyi on 4/3/15.
//  Copyright (c) 2015 boyi. All rights reserved.
//

class QuadraticAnimationAlgorithm : AnimationProgressAlgorithm, AnimationProgressAlgorithmProtocol {
    override func easeIn(var currentTime: Double, startValue: Double, changeInValue: Double, duration: Double) -> Double {
        currentTime /= duration
        return changeInValue * currentTime * currentTime + startValue
    }
    
    override func easeOut(var currentTime: Double, startValue: Double, changeInValue: Double, duration: Double) -> Double {
        currentTime /= duration
        return -changeInValue * currentTime * (currentTime - 2) + startValue
    }
    
    override func easeInEaseOut(var currentTime: Double, startValue: Double, changeInValue: Double, duration: Double) -> Double {
        currentTime /= duration / 2
        if currentTime < 1 {
            return changeInValue / 2 * currentTime * currentTime + startValue
        }
        currentTime--
        return -changeInValue / 2 * (currentTime * (currentTime - 2) - 1) + startValue
    }
}
