//
//  CardView.swift
//  FinalProject
//
//  Created by Iuri Jikidze on 2/9/21.
//

import UIKit

class CardView: UICollectionViewCell {
//    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var childView: UIView!
    @IBOutlet weak var line1: UIView!
    @IBOutlet weak var line2: UIView!
    @IBOutlet weak var stackView: UIStackView!
    // first view
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var place: UILabel!
    @IBOutlet weak var wether: UILabel!
    
    
    private let gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor(named: "blue-gradient-start")?.cgColor ?? UIColor.blue.cgColor ,
            UIColor(named: "blue-gradient-end")?.cgColor ?? UIColor.red.cgColor
        ]
        return layer
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mainView.layer.cornerRadius = 30
        gradientLayer.frame = mainView.bounds
        gradientLayer.cornerRadius = 30
        self.childView.backgroundColor = .clear
        self.mainView.layer.insertSublayer(gradientLayer, at: 0)
//        mainView.layer.insertSublayer(gradientLayer, at: 0)
//        mainView.backgroundColor = .clear
        
    }
    
    override func layoutSubviews() {
        if (UIWindow.isLandscape) {
//            print("Landscape")
            line1.isHidden = true
            line2.isHidden = false
            stackView.axis = .horizontal
        } else {
//            print("Portrait")
            line1.isHidden = false
            line2.isHidden = true
            stackView.axis = .vertical
        }
        gradientLayer.frame = mainView.bounds
    }
    
    override var frame: CGRect {
        didSet {
            gradientLayer.frame = bounds
        }
    }

}
