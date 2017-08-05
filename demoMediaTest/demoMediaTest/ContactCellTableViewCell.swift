//
//  ContactCellTableViewCell.swift
//  demoMediaTest
//
//  Created by Jack Warris on 01/08/2017.
//  Copyright © 2017 com.jackwarris. All rights reserved.
//

import UIKit

class ContactCellTableViewCell: UITableViewCell {

    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var contactAvatar: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
