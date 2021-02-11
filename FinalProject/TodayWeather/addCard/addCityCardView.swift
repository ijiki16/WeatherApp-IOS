//
//  addCityCardView.swift
//  FinalProject
//
//  Created by Iuri Jikidze on 2/11/21.
//

import UIKit

class addCityCardView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var textInput: UITextField!
    @IBOutlet weak var button: UIButton!
    
    
    //
    
    private let gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor(named: "green-gradient-start")?.cgColor ?? UIColor.blue.cgColor ,
            UIColor(named: "green-gradient-end")?.cgColor ?? UIColor.red.cgColor
        ]
        return layer
    }()
    
    let nibName = "addCityCardView"
        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        mainView.layer.cornerRadius = 30
        button.layer.cornerRadius = 25
//        mainView.backgroundColor = .blue
        
        self.addSubview(view)
    }
    
    
    func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    
    
    


}
