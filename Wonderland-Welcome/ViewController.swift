//
//  ViewController.swift
//  Wonderland-Welcome
//
//  Created by JaminZhou on 2017/3/26.
//  Copyright © 2017年 Hangzhou Tomorning Technology Co., Ltd. All rights reserved.
//

import UIKit
import pop
import Shimmer

class ViewController: UIViewController {
    
    @IBOutlet weak var view0: UIView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var view5: UIView!
    @IBOutlet weak var view6: UIView!
    @IBOutlet weak var view7: UIView!
    @IBOutlet weak var view8: UIView!
    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var enterButton: UIButton!
    
    var shimmeringView: FBShimmeringView!
    let numerical = 21092
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        showSpectialAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addShimmeringView()
        showAnimation()
    }
    
    func configView() {
        for i in 1...9 {
            let view = logoView.viewWithTag(i)!
            view.alpha = 0.0
        }
    }
    
    func addShimmeringView() {
        shimmeringView = FBShimmeringView(frame: welcomeLabel.frame)
        shimmeringView.isShimmering = false
        shimmeringView.shimmeringSpeed = 80
        shimmeringView.contentView = welcomeLabel
        shimmeringView.alpha = 0.0
        welcomeLabel.alpha = 1.0
        view.addSubview(shimmeringView)
    }
    
    func showAnimation() {
        var delayInSeconds = 0.0
        let random = randomBubble()
        for i in 0..<9 {
            DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds) {
                if i < 8 {
                    let view = self.logoView.viewWithTag(random[i])
                    self.showBubbleAnimation(view!)
                } else {
                    self.showSpectialAnimation()
                }
            }
            delayInSeconds += 0.08
        }
        magicNumber()
    }
    
    func showBubbleAnimation(_ view: UIView) {
        let scaleAnimation = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)!
        scaleAnimation.springBounciness = 15
        scaleAnimation.fromValue = CGPoint(x: 0.0, y: 0.0)
        scaleAnimation.toValue = CGPoint(x: 1.0, y: 1.0)
        
        let opacityAnimation = POPBasicAnimation(propertyNamed: kPOPLayerOpacity)!
        opacityAnimation.toValue = NSNumber(value: 1.0)
        
        view.layer.pop_add(scaleAnimation, forKey: "scaleAnimation")
        view.layer.pop_add(opacityAnimation, forKey: "opacityAnimation")
    }
    
    func showSpectialAnimation() {
        let scaleAnimation = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)!
        scaleAnimation.springBounciness = 25
        scaleAnimation.fromValue = CGPoint(x: 0.0, y: 0.0)
        scaleAnimation.toValue = CGPoint(x: 1.0, y: 1.0)
        
        let opacityAnimation = POPBasicAnimation(propertyNamed: kPOPLayerOpacity)!
        opacityAnimation.toValue = 1.0
        
        view8.layer.pop_add(scaleAnimation, forKey: "scaleAnimation")
        view8.layer.pop_add(opacityAnimation, forKey: "opacityAnimation")
    }
    
    func randomBubble() -> [Int] {
        var startArray = [1,2,3,4,5,6,7,8]
        var resultArray = [0,0,0,0,0,0,0,0]
        let count = startArray.count
        for i in 0..<count {
            let t = Int(arc4random())%startArray.count
            resultArray[i] = startArray[t]
            startArray.remove(at: t)
        }
        return resultArray
    }
    
    func magicNumber() {
        let numProp = POPAnimatableProperty.property(withName: "num") { (prop: POPMutableAnimatableProperty!) in
            prop.writeBlock = { obj, values in
                let label = obj as! UILabel
                label.text = "\(Int(values![0]))"
            }
        }
        
        let numberAnimatin = POPBasicAnimation.easeInEaseOut()!
        numberAnimatin.property = numProp as! POPAnimatableProperty
        numberAnimatin.fromValue = 0
        numberAnimatin.toValue = numerical
        numberAnimatin.duration = 2
        numberAnimatin.completionBlock = { anim, finished in
            self.endNumerAnimation()
        }
        
        let opacityAnimation = POPBasicAnimation(propertyNamed: kPOPLayerOpacity)!
        opacityAnimation.toValue = 1.0
        
        numLabel.pop_add(numberAnimatin, forKey: "numberAnimatin")
        numLabel.layer.pop_add(opacityAnimation, forKey: "opacityAnimation")
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
            self.totalLabel.alpha = 1.0
        }, completion: nil)
    }
    
    func endNumerAnimation() {
        let rect = numLabel.frame
        let imageView = UIImageView(frame: CGRect(x: rect.origin.x, y: rect.origin.y+rect.size.height, width: 0, height: 5))
        imageView.image = #imageLiteral(resourceName: "tutorial_swip_end")
        view.addSubview(imageView)
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
            imageView.frame.size.width = rect.size.width
        }) { (value) in
            UIView.animate(withDuration: 0.8, delay: 0.8, options: .curveEaseInOut, animations: {
                self.enterButton.alpha = 1.0
                self.shimmeringView.alpha = 1.0
            }) { (value) in
                self.shimmeringView.isShimmering = true
            }
        }
    }
    
}
