//
//  Buttons.swift
//  Shared
//
//  Created by Kankan Song on 26/04/20.
//  Copyright © 2020 queuesafe. All rights reserved.
//

import Foundation
import UIKit

class PositiveButton: RoundButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        setBackgroundImage(imageFromColor(color: UIColor(named: "PositiveButtonColor", in: Bundle(for: PositiveButton.self), compatibleWith: nil)), for: .normal)
        setTitleColor(UIColor.white, for: .normal)
    }
}

class NegativeButton: RoundButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        setBackgroundImage(imageFromColor(color: UIColor(named: "NegativeButtonColor", in: Bundle(for: PositiveButton.self), compatibleWith: nil)), for: .normal)
        setTitleColor(UIColor.black, for: .normal)
    }
}

class RoundButton: UIButton {
    override func layoutSubviews() {
           super.layoutSubviews()
           layer.cornerRadius = 3.0
           layer.masksToBounds = true
    }
}

public class CircleButton: UIButton {
    override public func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 0.5 * bounds.size.width
        layer.masksToBounds = true
    }
}

extension UIButton {
    func imageFromColor(color: UIColor?) -> UIImage? {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        if let context = UIGraphicsGetCurrentContext(), let color = color {
            context.setFillColor(color.cgColor)
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
            let colorImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return colorImage
        }
        return nil
    }
}

extension CALayer {
    public func configureGradientBackground(_ colors:[CGColor]){

       configureGradientBackground(cornerRadius: 0, colors)
    }
    
    public func configureCircleGradientBackground(_ colors:[CGColor]){
        
        configureGradientBackground(cornerRadius: self.bounds.width * 0.5, colors)
    }
    
    private func configureGradientBackground(cornerRadius: CGFloat, _ colors:[CGColor]){
        
        var gradientLayer: CAGradientLayer?
        self.sublayers?.forEach({ sublayer in
            if let layer = sublayer as? CAGradientLayer {
                gradientLayer = layer
            }
        })
        if let gradientLayer = gradientLayer {
            gradientLayer.removeFromSuperlayer()
        }
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.cornerRadius = cornerRadius
        gradient.colors = colors
        
        self.insertSublayer(gradient, at: 0)
    }
}
