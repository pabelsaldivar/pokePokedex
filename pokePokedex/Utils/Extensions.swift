//
//  Extensions.swift
//  pokePokedex
//
//  Created by Jonathan Pabel Saldivar Mendoza on 05/05/21.
//

import Foundation
import UIKit

extension String {
    
    var isEmail: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: [], range: NSMakeRange(0, self.count)) != nil
        }
        catch {
            return false
        }
    }
}

extension UIImageView {
    func roundCorners(cornerRadius: Double) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }
    
    private var activityIndicator: UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .large
        activityIndicator.tintColor = .blue
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color =  .blue
        self.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        let centerX = NSLayoutConstraint(item: self,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: activityIndicator,
                                         attribute: .centerX,
                                         multiplier: 1,
                                         constant: 0)
        let centerY = NSLayoutConstraint(item: self,
                                         attribute: .centerY,
                                         relatedBy: .equal,
                                         toItem: activityIndicator,
                                         attribute: .centerY,
                                         multiplier: 1,
                                         constant: 0)
        self.addConstraints([centerX, centerY])
        return activityIndicator
    }
    
    func downloadedFrom(link: String, contentMode mode: UIView.ContentMode = .scaleAspectFill) {
        guard let url = URL(string: link) else { return }
        contentMode = mode
        startAnimating()
        let activityIndicator = self.activityIndicator
        DispatchQueue.main.async {
            activityIndicator.startAnimating()
        }
        ImageManager.shared.downloadImage(url: url) { (dwnImage, error, isOnCache) in
            self.stopAnimating()
            if let error = error {
                self.image = UIImage(named: "pokeball2")
            } else {
                if let image = dwnImage {
                    DispatchQueue.main.async {
                        if isOnCache {
                            self.image = image
                        } else {
                            UIView.animate(withDuration: 0.2, animations: {
                                self.alpha = 0.0
                            }) { (_) in
                                self.image = image
                                UIView.animate(withDuration: 0.2, animations: {
                                    self.alpha = 1.0
                                })
                            }
                        }
                    }
                } else {
                    self.image = UIImage(named: "pokeball2")
                }
            }
            DispatchQueue.main.async {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
            }
        }
    }
    
    func startAnimating() {
        let pulseAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        pulseAnimation.duration = 0.75
        pulseAnimation.fromValue = 0.30
        pulseAnimation.toValue = 1.0
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = .greatestFiniteMagnitude
        self.layer.add(pulseAnimation, forKey: "animateOpacity")
    }
    
    func stopAnimating() {
        DispatchQueue.main.async {
            self.layer.removeAllAnimations()
        }
    }
}

extension UIStoryboard {
    func instantiateViewController<T: UIViewController>(ofType _: T.Type, withIdentifier identifier: String? = nil) -> T {
        let identifier = identifier ?? String(describing: T.self)
        return instantiateViewController(withIdentifier: identifier) as! T
    }
}
