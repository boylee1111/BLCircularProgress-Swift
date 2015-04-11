//
//  SinusoidalAnimationAlgorithm.swift
//  BLCircularProgress-Swift
//
//  Created by Boyi on 4/11/15.
//  Copyright (c) 2015 boyi. All rights reserved.
//

import Foundation

class SinusoidalAnimationAlgorithm : AnimationProgressAlgorithm, AnimationProgressAlgorithmProtocol {
    override func easeIn(currentTime: Double, startValue: Double, changeInValue: Double, duration: Double) -> Double {
        return -changeInValue * cos(currentTime / duration * M_PI_2) + changeInValue + startValue
    }
    
    override func easeOut(currentTime: Double, startValue: Double, changeInValue: Double, duration: Double) -> Double {
        return changeInValue * sin(currentTime / duration * M_PI_2) + startValue
    }
    
    override func easeInEaseOut(currentTime: Double, startValue: Double, changeInValue: Double, duration: Double) -> Double {
        return -changeInValue / 2 * (cos(M_PI * currentTime / duration) - 1) + startValue
    }
}
