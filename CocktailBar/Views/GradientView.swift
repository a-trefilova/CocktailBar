//
//  GradientView.swift
//  CocktailBar
//
//  Created by Константин Сабицкий on 29.06.2020.
//  Copyright © 2020 Константин Сабицкий. All rights reserved.
//

import UIKit

class GradientView: UIView {
    
    @IBInspectable private var startColor: UIColor? {
        didSet {
            setUpGradienColor()
        }
    }
    @IBInspectable private var endColor: UIColor?{
        didSet {
            setUpGradienColor()
        }
    }
    private let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUPGradient()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    func setUPGradient() {
        self.layer.addSublayer(gradientLayer)
        setUpGradienColor()
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
    }
    
    func setUpGradienColor() {
        if let startColor = startColor, let endColor = endColor {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
           
        }
    }
    
}
