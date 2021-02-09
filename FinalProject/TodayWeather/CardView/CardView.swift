//
//  CardView.swift
//  FinalProject
//
//  Created by Iuri Jikidze on 2/9/21.
//

import UIKit

class CardView: UICollectionViewCell {
    @IBOutlet weak var mainView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mainView.layer.cornerRadius = 8
        mainView.backgroundColor = .red
    }

}
