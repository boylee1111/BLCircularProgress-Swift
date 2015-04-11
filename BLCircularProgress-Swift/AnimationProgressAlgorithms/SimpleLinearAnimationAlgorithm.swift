//
//  SimpleLinearAnimationAlgorithm.swift
//  BLCircularProgress-Swift
//
//  Created by Boyi on 4/11/15.
//  Copyright (c) 2015 boyi. All rights reserved.
//

class SimpleLinearAnimationAlgorithm : AnimationProgressAlgorithm, AnimationProgressAlgorithmProtocol {
    override func easeIn(currentTime: Double, startValue: Double, changeInValue: Double, duration: Double) -> Double {
        return changeInValue * currentTime / duration + startValue;
    }
    
    override func easeOut(currentTime: Double, startValue: Double, changeInValue: Double, duration: Double) -> Double {
        return changeInValue * currentTime / duration + startValue;
    }
    
    override func easeInEaseOut(currentTime: Double, startValue: Double, changeInValue: Double, duration: Double) -> Double {
        return changeInValue * currentTime / duration + startValue;
    }
}
