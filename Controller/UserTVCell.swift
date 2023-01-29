//
//  UserTVCell.swift
//  Chat-Bee
//
//  Created by mac on 06/01/2023.
//

import UIKit

class UserTVCell: UITableViewCell {

    @IBOutlet weak var usersImageView: UIImageView!
    
    
    @IBOutlet weak var nameLBL: UILabel!
    
    
    @IBOutlet weak var emailLBL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .black
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
