//
//  AnimationAndDownloadExtention.swift
//  NearMe
//
//  Created by Hos on 17/12/17.
//  Copyright © 2017 Hos. All rights reserved.
//

import Foundation
import  UIKit

extension LocationFinderViewController:URLSessionDownloadDelegate
{
    func addOverlayView()
    {
        overlayView = UIView(frame: view.frame)
        overlayView?.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6872324486)
        self.view.addSubview(overlayView!)
        setupCricularlayers()
        setupDownloadStatusLabel()

    }
    
    private func setupDownloadStatusLabel()
    {
        overlayView?.addSubview(downloadStatusLabel!)
        downloadStatusLabel?.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        downloadStatusLabel?.center = (overlayView?.center)!
    }
    
    private func createCircleShapelayer(strokeColor:UIColor, fillColor:UIColor) ->CAShapeLayer
    {
        let layer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: .zero,
                                        radius: 100,
                                        startAngle: 0,
                                        endAngle: 2 * CGFloat.pi,
                                        clockwise: true)
        layer.path = circularPath.cgPath
        layer.fillColor = fillColor.cgColor
        layer.strokeColor = strokeColor.cgColor
        layer.lineCap = kCALineCapRound
        layer.lineWidth = 20
        layer.position = overlayView!.center
        return layer
    }
    
    private func setupCricularlayers()
    {
        pulseLayer = createCircleShapelayer(strokeColor: .clear, fillColor: .pulsatingFillColor)
        overlayView?.layer.addSublayer(pulseLayer!)
        animatePulse()
        
        let dummylayer = createCircleShapelayer(strokeColor: .trackStrokeColor, fillColor: .backgroundColor)
        overlayView?.layer.addSublayer(dummylayer)
        
        trackLayer = createCircleShapelayer(strokeColor:.outlineStrokeColor , fillColor:.clear )
        trackLayer?.transform = CATransform3DMakeRotation(-CGFloat.pi / 2,
                                                          0,
                                                          0,
                                                          1)
        trackLayer?.strokeEnd = 0
        overlayView?.layer.addSublayer(trackLayer!)
        
    }
    
    private func animatePulse()
    {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 1.5
        animation.duration = 0.8
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        pulseLayer?.add(animation, forKey: "Pulsing")
        beginFileDownload()
    }
    
    private func removeOverlay()
    {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1.3,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut,
                           animations: {
                            //self.overlayView?.bounds = CGRect(x: 0, y: 0, width: 0, height: 0)
                            self.overlayView?.alpha = 0
            }) { (flag) in
                if flag
                {
                    self.overlayView?.isHidden = true
                   
                }
            }
        }
        DispatchQueue.main.async {
            self.addMarkerOnMap()
        }
    }
    
    private func beginFileDownload()
    {
        trackLayer?.strokeEnd = 0
        let sessionConfiguration = URLSessionConfiguration.default
        let operationQueue = OperationQueue()
        let urlSession = URLSession(configuration: sessionConfiguration, delegate: self, delegateQueue: operationQueue)
        guard let url = URL(string:downloadUrlString) else {return}
       let downloadTask = urlSession.downloadTask(with: url)
        downloadTask.resume()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64)
    {
        let percentage =  CGFloat(totalBytesWritten) / CGFloat( totalBytesExpectedToWrite)
        print(percentage)
        DispatchQueue.main.async {
            self.downloadStatusLabel?.text = "\(Int(percentage * 100))%"
            self.trackLayer?.strokeEnd = percentage
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL)
    {
        print("download Finished")
        removeOverlay()
        
    }
}


extension UIColor
{
    static func rgb(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    static let backgroundColor = UIColor.rgb(r: 21, g: 22, b: 33)
    static let outlineStrokeColor = UIColor.rgb(r: 234, g: 46, b: 111)
    static let trackStrokeColor = UIColor.rgb(r: 56, g: 25, b: 49)
    static let pulsatingFillColor = UIColor.rgb(r: 86, g: 30, b: 63)
}

