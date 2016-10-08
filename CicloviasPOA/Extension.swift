//
//  Extension.swift
//  CicloviasPOA
//
//  Created by Eduardo Santi on 07/10/16.
//  Copyright © 2016 Eduardo Santi. All rights reserved.
//

import UIKit

// MARK: UIView
extension UIView {
    
    /**
     Helps to control the states of views
     
     */
    struct ActivityView {
        var loadingView = UIView()
        var container = UIView()
        let activityIndicator = UIActivityIndicatorView()
    }
    
    /**
     Displays a small screen loading
     
     */
    public class func showLoading() {
        let win: UIWindow = UIApplication.shared.delegate!.window!!
        var av = ActivityView()
        
        av.loadingView = UIView(frame: win.frame)
        av.loadingView.tag = 1
        av.loadingView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0)
        
        win.addSubview(av.loadingView)
        
        av.container = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        av.container.backgroundColor = UIColor.gray
        av.container.layer.cornerRadius = 10.0
        av.container.layer.borderColor = UIColor.gray.cgColor
        av.container.layer.borderWidth = 0.5
        av.container.clipsToBounds = true
        av.container.center = av.loadingView.center
        
        
        av.activityIndicator.frame = CGRect(x: 0, y: 0, width: win.frame.width/5, height: win.frame.width/5)
        av.activityIndicator.activityIndicatorViewStyle = .whiteLarge
        av.activityIndicator.center = av.loadingView.center
        
        
        av.loadingView.addSubview(av.container)
        av.loadingView.addSubview(av.activityIndicator)
        
        av.activityIndicator.startAnimating()
        
    }
    
    /**
     Remove a small screen loading
     
     */
    public class func removeLoading() {
        
        let av = ActivityView()
        
        UIView.animate(withDuration: 0.0, delay: 0.0, options: .curveEaseOut, animations: {
            av.container.alpha = 0.0
            av.loadingView.alpha = 0.0
            av.activityIndicator.stopAnimating()
            }, completion: { finished in
                av.activityIndicator.removeFromSuperview()
                av.container.removeFromSuperview()
                av.loadingView.removeFromSuperview()
                let win:UIWindow = UIApplication.shared.delegate!.window!!
                let removeView  = win.viewWithTag(1)
                removeView?.removeFromSuperview()
        })
        
    }
}
