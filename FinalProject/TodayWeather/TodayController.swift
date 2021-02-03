//
//  TodayController.swift
//  FinalProject
//
//  Created by Iuri Jikidze on 2/3/21.
//

import UIKit

class TodayController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        var gradientLayer: CAGradientLayer!
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor(named: "bg-gradient-start")?.cgColor ?? UIColor.blue.cgColor , UIColor(named: "bg-gradient-end")?.cgColor ?? UIColor.red.cgColor]
        self.view.layer.addSublayer(gradientLayer)
        //        self.view.backgroundColor = .red
        
    }
    
    
}
