//
//  QuarticAnimationAlgorithm.swift
//  BLCircularProgress-Swift
//
//  Created by Boyi on 4/11/15.
//  Copyright (c) 2015 boyi. All rights reserved.
//

class QuarticAnimationAlgorithm : AnimationProgressAlgorithm, AnimationProgressAlgorithmProtocol {
    override func easeIn(var currentTime: Double, startValue: Double, changeInValue: Double, duration: Double) -> Double {
        currentTime /= duration
        return changeInValue * currentTime * currentTime * currentTime * currentTime + startValue
    }
    
    override func easeOut(var currentTime: Double, startValue: Double, changeInValue: Double, duration: Double) -> Double {
        currentTime /= duration
        currentTime--
        return -changeInValue * (currentTime * currentTime * currentTime * currentTime - 1) + startValue
    }
    
    override func easeInEaseOut(var currentTime: Double, startValue: Double, changeInValue: Double, duration: Double) -> Double {
        currentTime /= duration / 2
        if currentTime < 1 {
            return changeInValue / 2 * currentTime * currentTime * currentTime * currentTime + startValue
        }
        currentTime -= 2
        return -changeInValue / 2 * (currentTime * currentTime * currentTime * currentTime - 2) + startValue
    }
}
