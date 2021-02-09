//
//  ForecastTableCell.swift
//  FinalProject
//
//  Created by Iuri Jikidze on 2/7/21.
//

import UIKit

class ForecastTableCell: UITableViewCell {
    
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var clock: UILabel!
    @IBOutlet weak var weather: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
