//
//  ProfileInfoCell.swift
//  Appointments
//
//  Created by Aalim Mulji on 5/11/19.
//  Copyright © 2019 Aalim Mulji. All rights reserved.
//

import UIKit

class ProfileInfoCell: UITableViewCell {

    @IBOutlet weak var profileRowTitleLabel: UILabel!
    @IBOutlet weak var profileRowValueLabel: UILabel!
    @IBOutlet weak var rightArrowImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
