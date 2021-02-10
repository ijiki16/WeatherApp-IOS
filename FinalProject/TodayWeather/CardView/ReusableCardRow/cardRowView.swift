//
//  cardRowView.swift
//  FinalProject
//
//  Created by Iuri Jikidze on 2/10/21.
//

import UIKit

class cardRowView: UIView {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    @IBOutlet weak var dataType: UILabel!
    @IBOutlet weak var dataValue: UILabel!
    @IBOutlet weak var icon: UIImageView!
    //    @IBOutlet weak var containerView: UIView!
    //       @IBOutlet weak var footerText: UILabel!
    
    let nibName = "cardRowView"
    
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
        self.addSubview(view)
    }
    
    func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
}
