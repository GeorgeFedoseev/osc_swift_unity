//
//  ViewController.swift
//  OSC_swift
//
//  Created by George Fedoseev on 2/12/17.
//  Copyright © 2017 George Fedoseev. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var trackpadView: UIView!
  
    var lastPoint: CGPoint = CGPoint(x: 0, y: 0)
    
    @IBOutlet weak var statusLabel: UILabel!
    
    
    var osc: Osc?
    
    var host: String?
    var port: Int?
    var oscAddress: String?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(OnPan))
        
        panGestureRecognizer.delegate = self
        
        
        trackpadView.addGestureRecognizer(panGestureRecognizer)
        
        trackpadView.isUserInteractionEnabled = true
        
        
        statusLabel.text = "Not connected"
        
        // load settings from user defaults or set default
        if let host = UserDefaults.standard.object(forKey: "host") {
            self.host = host as! String
        }else{
            host = "192.168.1.1"
        }
        
        if let port = UserDefaults.standard.object(forKey: "port") {
            self.port = port as! Int
        }else{
            port = 7000
        }
        
        if let oscAddress = UserDefaults.standard.object(forKey: "oscAddress") {
            self.oscAddress = oscAddress as! String
        }else{
            oscAddress = "/some"
        }
        
        
        
        
        
        SaveCurrentSettings()
        
        TryConnect(completion: {})
        
        
    }
    
    
    @IBAction func OnSetHostAndPort(_ sender: Any) {
        SetHost(completion: {
            self.SetPort(completion: {
                self.SetOscAddress(completion: {
                    
                    self.SaveCurrentSettings()
                    
                    self.TryConnect(completion: {
                        print("Connected!")
                    })
                })
            })
        })
        
        
    }
    
    
    func SetHost(completion: (() -> Void)?){
        var alertController:UIAlertController?
        alertController = UIAlertController(title: "Enter host",
                                            message: "enter host to connect to",
                                            preferredStyle: .alert)
        
        alertController!.addTextField(
            configurationHandler: {(textField: UITextField!) in
                textField.placeholder = "Host address"
                textField.text = self.host
        })
        
        let action = UIAlertAction(title: "Save",
                                   style: UIAlertActionStyle.default,
                                   handler: {[weak self]
                                    (paramAction:UIAlertAction!) in
                                    if let textFields = alertController?.textFields{
                                        let theTextFields = textFields as [UITextField]
                                        let enteredText = theTextFields[0].text
                                        self?.host = enteredText
                                        
                                        
                                        completion?()
                                    }
        })
        
        alertController?.addAction(action)
        self.present(alertController!,
                                   animated: true,
                                   completion: nil)
    }
    
    
    
    
    
    func SetPort(completion: (() -> Void)?){
        var alertController:UIAlertController?
        alertController = UIAlertController(title: "Enter port",
                                            message: "enter port to connect to",
                                            preferredStyle: .alert)
        
        alertController!.addTextField(
            configurationHandler: {(textField: UITextField!) in
                textField.placeholder = "Port"
                textField.text = "\(self.port!)"
        })
        
        let action = UIAlertAction(title: "Save",
                                   style: UIAlertActionStyle.default,
                                   handler: {[weak self]
                                    (paramAction:UIAlertAction!) in
                                    if let textFields = alertController?.textFields{
                                        let theTextFields = textFields as [UITextField]
                                        let enteredText = theTextFields[0].text
                                        self?.port = Int(enteredText!)
                                        
                                        completion?()
                                    }
        })
        
        alertController?.addAction(action)
        self.present(alertController!,
                     animated: true,
                     completion: nil)
    }
    
    
    func SetOscAddress(completion: (() -> Void)?){
        var alertController:UIAlertController?
        alertController = UIAlertController(title: "Enter OSC address",
                                            message: "enter osc address to connect to",
                                            preferredStyle: .alert)
        
        alertController!.addTextField(
            configurationHandler: {(textField: UITextField!) in
                textField.placeholder = "osc address"
                textField.text = self.oscAddress
        })
        
        let action = UIAlertAction(title: "Save",
                                   style: UIAlertActionStyle.default,
                                   handler: {[weak self]
                                    (paramAction:UIAlertAction!) in
                                    if let textFields = alertController?.textFields{
                                        let theTextFields = textFields as [UITextField]
                                        let enteredText = theTextFields[0].text
                                        self?.oscAddress = enteredText
                                       
                                        completion?()
                                    }
        })
        
        alertController?.addAction(action)
        self.present(alertController!,
                     animated: true,
                     completion: nil)
    }

    
    
    
    
    func SaveCurrentSettings(){
        UserDefaults.standard.set(self.host!, forKey: "host")
        UserDefaults.standard.set(self.port!, forKey: "port")
        UserDefaults.standard.set(self.oscAddress!, forKey: "oscAddress")
    }
    
    func TryConnect(completion: @escaping () -> Void){
        
        print("Try connect")
        
        osc = Osc()
        
        
        osc?.SetHost(host: host!) {
            print("osc host callback")
            
            self.osc?.SetPort(port: Int(self.port!))
            
            self.statusLabel.text = "Connected"
            completion()
            
        }
    }
    
    
    
    
    func SendRotation(rotY: Float){
        if self.osc != nil && self.osc!.IsReady() {
            self.osc!.PushAddress(adrs: "\(self.oscAddress!)")
            self.osc!.PushArg(arg: rotY)
            
            self.osc!.Send()
        }else{
            print("ERROR! OSC is not ready")
            statusLabel.text = "Not connected"
        }
    }
    
    
    func OnPan(g:UIPanGestureRecognizer){
        
        let translation = g.translation(in: trackpadView)
        
        
        let delta = CGPoint(x: translation.x - lastPoint.x, y: translation.y - lastPoint.y)
        
        print("pan \(delta.x) \(delta.y)")
        
        SendRotation(rotY: Float(delta.y))
        
        lastPoint = translation;
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

