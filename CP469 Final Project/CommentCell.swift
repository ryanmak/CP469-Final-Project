//
//  CommentCell.swift
//  CP469 Final Project
//
//  Created by Jonathan Wu on 2018-04-08.
//  Copyright © 2018 Mak & Wu Collaborative. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    @IBOutlet weak var Author: UILabel!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var points: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
