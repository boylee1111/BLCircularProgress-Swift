//
//  AnimationProgressAlgorithm.swift
//  BLCircularProgress-Swift
//
//  Created by Boyi on 4/3/15.
//  Copyright (c) 2015 boyi. All rights reserved.
//

import Foundation

let abstractionMethodMsg = "This is an abstraction method, must be overridden"

public enum AnimationAlgorithm {
    case AnimationAlgorithmSimpleLinear
    case AnimationAlgorithmQuadratic
    case AnimationAlgorithmCubic
    case AnimationAlgorithmQuartic
    case AnimationAlgorithmQuintic
    case AnimationAlgorithmSinusoidal
    case AnimationAlgorithmExponential
    case AnimationAlgorithmCircular
}

public enum AnimationType {
    case AnimationTypeEaseIn((Double, Double, Double, Double) -> Double)
    case AnimationTypeEaseOut((Double, Double, Double, Double) -> Double)
    case AnimationTypeEaseInEaseOut((Double, Double, Double, Double) -> Double)
}

protocol AnimationProgressAlgorithmProtocol {
    func easeIn(currentTime: Double, startValue: Double, changeInValue: Double, duration: Double) -> Double
    func easeOut(currentTime: Double, startValue: Double, changeInValue: Double, duration: Double) -> Double
    func easeInEaseOut(currentTime: Double, startValue: Double, changeInValue: Double, duration: Double) -> Double
}

class AnimationProgressAlgorithm {
    func easeIn(currentTime: Double, startValue: Double, changeInValue: Double, duration: Double) -> Double {
        fatalError(abstractionMethodMsg)
    }
    
    func easeOut(currentTime: Double, startValue: Double, changeInValue: Double, duration: Double) -> Double {
        fatalError(abstractionMethodMsg)
    }
    
    func easeInEaseOut(currentTime: Double, startValue: Double, changeInValue: Double, duration: Double) -> Double {
        fatalError(abstractionMethodMsg)
    }
    
    func animationAlgorithm(animationType: AnimationType) -> (Double, Double, Double, Double) -> Double {
        switch animationType {
        case .AnimationTypeEaseIn:
            return easeIn;
        case .AnimationTypeEaseOut:
            return easeOut;
        case .AnimationTypeEaseInEaseOut:
            return easeInEaseOut;
        }
    }
}