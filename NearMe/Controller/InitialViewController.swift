//
//  InitialViewController.swift
//  NearMe
//
//  Created by Hos on 16/12/17.
//  Copyright © 2017 Hos. All rights reserved.
//

import UIKit

class InitialViewController: BaseViewController
{
    var mask :CALayer?
    var overlay :UIView?
    override func viewDidLoad()
    {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        addOverlayView()
        configureMask()
        animateMask()
    }
    
    
    private func configureMask()
    {
        self.mask = CALayer()
        self.mask?.contents = UIImage(named: "twitterMask")?.cgImage
        self.mask?.contentsGravity  = kCAGravityResizeAspect
        self.mask?.bounds = CGRect(x: 0, y: 0, width: 1001, height: 100)
        self.mask?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.mask?.position = view.center
        view.layer.mask = mask
    }
    
    private func addOverlayView()
    {
        overlay = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: view.bounds.size.height))
        overlay?.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        self.view.addSubview(overlay!)
    }
    
    private func animateOverlayView()
    {
        
    }
    
    private func animateMask()
    {
        let keyframeAnimation = CAKeyframeAnimation(keyPath: "bounds")
        keyframeAnimation.delegate = self
        keyframeAnimation.duration = 1
        keyframeAnimation.beginTime = CACurrentMediaTime() + 1
        let intialbounds = mask?.bounds ?? CGRect(x: 0, y: 0, width: 0, height: 0)
        let secondBounds = CGRect(x: 0, y: 0, width: 87, height: 87)
        let finalBounds = CGRect(x: 0, y: 0, width: 1500, height: 1500)
        keyframeAnimation.values = [intialbounds,secondBounds,finalBounds]
        keyframeAnimation.keyTimes = [0,0.3,1]
        keyframeAnimation.timingFunctions = [CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)]
        mask?.add(keyframeAnimation, forKey: "bounds")
    }
    
    private func pushNextController()
    {
        let cVc = self.storyboard?.instantiateViewController(withIdentifier: "CatagoryViewController") as! CatagoryViewController
        self.navigationController?.pushViewController(cVc, animated: false)
    }
}

extension InitialViewController:CAAnimationDelegate
{
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool)
    {
        self.view.layer.mask = nil
        UIView.animate(withDuration: 1.0,
                       animations:
            {
                self.overlay?.alpha = 0
                self.pushNextController()

        }) {[weak self] (completionFlag) in
            self?.overlay?.isHidden = true
            self?.overlay = nil
            
        }
        
    }
}


