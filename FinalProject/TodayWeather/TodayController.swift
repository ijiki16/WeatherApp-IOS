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
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = true
        self.title = "Today"
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"),
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(refersh))
        //
        var gradientLayer: CAGradientLayer!
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor(named: "bg-gradient-start")?.cgColor ?? UIColor.blue.cgColor , UIColor(named: "bg-gradient-end")?.cgColor ?? UIColor.red.cgColor]
        self.view.layer.addSublayer(gradientLayer)
        //        self.view.backgroundColor = .red
    }
    
    @objc func refersh() {
        print("refresh")
    }
    
}
