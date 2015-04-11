//
//  ViewController.swift
//  BLCircularProgress-Swift
//
//  Created by Boyi on 4/3/15.
//  Copyright (c) 2015 boyi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var circularProgress: BLCircularProgressView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.circularProgress.progress = 30
        self.circularProgress.maximaProgress = 90
        self.circularProgress.minimaProgress = 20
        
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
}

