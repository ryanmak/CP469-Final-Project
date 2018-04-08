//
//  pointCell.swift
//  CP469 Final Project
//
//  Created by Jonathan Wu on 2018-04-08.
//  Copyright © 2018 Mak & Wu Collaborative. All rights reserved.
//

import UIKit

class pointCell: UITableViewCell {
    let a = Authentication.sharedInstance

    @IBOutlet weak var points: UILabel!
    @IBOutlet weak var comments: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var upvote: UIButton!
    @IBOutlet weak var downvote: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        author.sizeToFit()
        comments.sizeToFit()
    }

    @IBAction func downDoot(_ sender: Any) {
        if (a.isAuthenticated) {
            upvote.setImage(UIImage(named:"up-arrow"), for: .normal)
            downvote.setImage(UIImage(named:"down-arrow copy"), for: .normal)
        }else{
            notLoggedInAlert()
        }
    }
    @IBAction func upDoot(_ sender: Any) {
        if (a.isAuthenticated) {
            upvote.setImage(UIImage(named:"up-arrow copy"), for: .normal)
            downvote.setImage(UIImage(named:"down-arrow"), for: .normal)
        }else{
            notLoggedInAlert()
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func notLoggedInAlert(){
        let alert = UIAlertController(title: "Not Logged In", message: "In order to vote/save a post, you need to log in", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }

}
