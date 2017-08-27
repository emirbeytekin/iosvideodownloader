//
//  CustomTableViewCell.swift
//  YtDownloader
//
//  Created by Emir Beytekin on 5.01.2017.
//  Copyright © 2017 Emir Beytekin. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var backgroundCell: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var videoThumb: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

