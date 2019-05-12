//
//  AppointmentNewCell.swift
//  Appointments
//
//  Created by Aalim Mulji on 5/12/19.
//  Copyright © 2019 Aalim Mulji. All rights reserved.
//

import UIKit

class AppointmentNewCell: UITableViewCell {

    @IBOutlet weak var profPictureImageView: UIImageView! {
        didSet {
            profPictureImageView.layer.cornerRadius = 30
        }
    }
    @IBOutlet weak var viewBlock: DesignableView!
    @IBOutlet weak var appointmentDateTimeLabel: UILabel!
    @IBOutlet weak var professorNameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
