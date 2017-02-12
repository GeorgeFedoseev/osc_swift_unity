//
//  ViewController.swift
//  OSC_swift
//
//  Created by George Fedoseev on 2/12/17.
//  Copyright © 2017 George Fedoseev. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var trackpadView: UIImageView!
  
    var lastPoint: CGPoint = CGPoint(x: 0, y: 0)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(OnPan))
        
        panGestureRecognizer.delegate = self
        
        
        trackpadView.addGestureRecognizer(panGestureRecognizer)
        
        trackpadView.isUserInteractionEnabled = true
    }
    
    
    
    
    
    func OnPan(g:UIPanGestureRecognizer){
        
        let translation = g.translation(in: trackpadView)
        
        
        let delta = CGPoint(x: translation.x - lastPoint.x, y: translation.y - lastPoint.y)
        
        print("pan \(delta.x) \(delta.y)")
        
        lastPoint = translation;
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

