//
//  ViewController.swift
//  Toss
//
//  Created by Rudra Jikadra on 18/12/17.
//  Copyright © 2017 Rudra Jikadra. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var logo1: UIImageView!
    @IBOutlet weak var logo2: UIImageView!
    @IBOutlet weak var card1: UIImageView!
    @IBOutlet weak var card2: UIImageView!
    @IBOutlet weak var deal: UIButton!
    @IBOutlet weak var player1: UILabel!
    @IBOutlet weak var player2: UILabel!
    @IBOutlet weak var score1: UILabel!
    @IBOutlet weak var score2: UILabel!
    @IBOutlet weak var upperLayer: UIView!
    @IBOutlet weak var upperLayerText: UITextView!
    @IBOutlet weak var upperLayerBackground: UIImageView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    var effect:UIVisualEffect!
    
    var x = 0
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //random background
        let random = arc4random_uniform(2)
        if random == 0 {
            background.image = UIImage(named: "background")
            upperLayerBackground.image = UIImage(named: "background")
        } else {
            background.image = UIImage(named: "background-1")
            upperLayerBackground.image = UIImage(named: "background-1")
        }
        
        upperLayerText.alpha = 0
        upperLayerText.isEditable = false
        
        effect = visualEffectView.effect
        visualEffectView.effect = nil
        
        
        //Touch ID
        let myContext = LAContext()
        let myLocalizedReasonString = "Show Me Your Finger"
        
        var authError: NSError?
        if #available(iOS 8.0, macOS 10.12.1, *) {
            if myContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
                
                UIView.animate(withDuration: 1.4, animations: {
                    self.visualEffectView.effect = self.effect
                })
                
                myContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: myLocalizedReasonString) { success, evaluateError in
                    if success {
                        // User authenticated successfully, take appropriate action
                        
                        
                        DispatchQueue.main.async {
                            UIView.animate(withDuration: 1.5, animations: {
                                self.visualEffectView.effect = nil
                            })
                            //self.upperLayer.removeFromSuperview()
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            self.upperLayer.removeFromSuperview()
                        }
                        
                    } else {
                        // User did not authenticate successfully, look at error and take appropriate action
                        DispatchQueue.main.async {
                            UIView.animate(withDuration: 1, animations: {
                                self.upperLayerText.alpha = 1
                            })
                            
                        }
                    }
                }
            } else {
                // Could not evaluate policy; look at authError and present an appropriate message to user
                DispatchQueue.main.async {
                    self.upperLayer.removeFromSuperview()
                }
            }
        } else {
            // Fallback on earlier versions
            DispatchQueue.main.async {
                self.upperLayer.removeFromSuperview()
            }
        }
        
        
        
        //Motion parallex effect
        applyMotion(toView: background, magnitude: 15)
        applyMotion(toView: card1, magnitude: -30)
        applyMotion(toView: card2, magnitude: 30)
        
        rotateView2(targetView: logo2, duration: 3.0)
        rotateView1(targetView: logo1, duration: 1.0)
        
        Timer.scheduledTimer(timeInterval: 6.0, target: self, selector: #selector(ViewController.activateJarvis), userInfo: nil, repeats: true)
        
    }
    
    
    @objc func activateJarvis(){
        if x == 0 {
            rotateView2(targetView: logo1, duration: 3.0)
            rotateView1(targetView: logo2, duration: 1.0)
            x = 1
        }else{
            rotateView1(targetView: logo1, duration: 3.0)
            rotateView2(targetView: logo2, duration: 1.0)
            x = 0
        }
    }
    
    func rotateView1(targetView: UIImageView, duration: Double) {
        UIImageView.animate(withDuration: duration, delay: 0.0, options: .curveLinear, animations: {
            targetView.transform = targetView.transform.rotated(by: CGFloat(Double.pi))
        }) { finished in
            self.rotateView1(targetView: targetView, duration: 3.0)
        }
    }
    
    func rotateView2(targetView: UIImageView, duration: Double) {
        UIImageView.animate(withDuration: duration, delay: 0.0, options: .curveLinear, animations: {
            targetView.transform = targetView.transform.rotated(by: CGFloat(360 - Double.pi))
        }) { finished in
            self.rotateView2(targetView: targetView, duration: 1.0)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dealOn(_ sender: Any) {
        
        let card1Random = arc4random_uniform(13) + 2
        let card2Random = arc4random_uniform(13) + 2
        
        card1.image = UIImage(named: "card\(card1Random)")
        card2.image = UIImage(named: "card\(card2Random)")
        
        UIView.transition(with: card1, duration: 0.8, options: .transitionFlipFromRight, animations: nil, completion: nil)
        UIView.transition(with: card2, duration: 0.8, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        
        updateScore(prio1: card1Random, prio2: card2Random)
        
    }
    
    func updateScore(prio1:UInt32, prio2:UInt32){
        
        score1.textColor = UIColor.black
        score2.textColor = UIColor.black
        
        if prio1 > prio2 {
            score1.textColor = UIColor.white
            score1.text = String(Int(score1.text!)! + 1)
        }
        else if prio1 < prio2{
            score2.textColor = UIColor.white
            score2.text = String(Int(score2.text!)! + 1)
        }
        else{
            
        }
        
    }
    
    //parallex motion effect
    func applyMotion(toView view:UIView, magnitude:Float) {
        let xMotion = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        xMotion.minimumRelativeValue = -magnitude
        xMotion.maximumRelativeValue = magnitude
        
        let yMotion = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        yMotion.minimumRelativeValue = -magnitude
        yMotion.maximumRelativeValue = magnitude
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [xMotion, yMotion]
        
        view.addMotionEffect(group)
    }
    
}


