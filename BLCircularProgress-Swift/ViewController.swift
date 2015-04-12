//
//  ViewController.swift
//  BLCircularProgress-Swift
//
//  Created by Boyi on 4/3/15.
//  Copyright (c) 2015 boyi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, BLCircularProgressViewProtocol {
    
    @IBOutlet weak var circularProgress: BLCircularProgressView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.circularProgress.progress = 30
        self.circularProgress.maximaProgress = 90
        self.circularProgress.minimaProgress = 20
        self.circularProgress.delegate = self;
        
        NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "updateProgress", userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func updateProgress() {
        var randomValue = self.randomDoubleBetween(0, bigValue: 100)
        println("random value = \(randomValue)")
        self.circularProgress.animateProgress(randomValue, completion: nil)
    }
    
    func randomDoubleBetween(smallValue: Double, bigValue: Double) -> Double {
        var diff = bigValue - smallValue
        return Double(arc4random_uniform(UInt32(diff))) + smallValue
    }
    
    func circularAnimationBegan(circularProgressView: BLCircularProgressView, progress: Double) {
        println("Animation Began")
    }
    
    func circularAnimationDuring(circularProgressView: BLCircularProgressView, progress: Double) {
        println("Animation During, Current Progress = \(progress)")
    }
    
    func circularAnimationEnded(circularProgressView: BLCircularProgressView, progress: Double) {
        println("Animation Ended")
    }
}

