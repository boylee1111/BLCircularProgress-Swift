//
//  ExponentialAnimationAlgorithm.swift
//  BLCircularProgress-Swift
//
//  Created by Boyi on 4/11/15.
//  Copyright (c) 2015 boyi. All rights reserved.
//

import Foundation

class ExponentialAnimationAlgorithm : AnimationProgressAlgorithm, AnimationProgressAlgorithmProtocol {
    override func easeIn(currentTime: Double, startValue: Double, changeInValue: Double, duration: Double) -> Double {
        return changeInValue * pow(2, 10 * (currentTime / duration - 1)) + startValue
    }
    
    override func easeOut(currentTime: Double, startValue: Double, changeInValue: Double, duration: Double) -> Double {
        return changeInValue * (-pow(2, -10 * currentTime / duration) + 1) + startValue
    }
    
    override func easeInEaseOut(var currentTime: Double, startValue: Double, changeInValue: Double, duration: Double) -> Double {
        currentTime /= duration / 2
        if currentTime < 1 {
            return changeInValue / 2 * pow(2, 10 * (currentTime - 1)) + startValue
        }
        currentTime--
        return changeInValue / 2 * (pow(2, -10 * currentTime) + 2) + startValue
    }
}
