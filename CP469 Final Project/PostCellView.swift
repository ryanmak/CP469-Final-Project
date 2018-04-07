//
//  PostCellView.swift
//  CP469 Final Project
//
//  Created by Ryan Mak on 2018-04-03.
//  Copyright © 2018 Mak & Wu Collaborative. All rights reserved.
//

import UIKit

class PostCellView: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var points: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    
    let a = Authentication.sharedInstance
    
    @IBOutlet weak var upBtn: UIButton!
    @IBAction func upvote(_ sender: Any) {
        if (a.isAuthenticated) {
            if upBtn.backgroundColor == UIColor.white {
                upBtn.backgroundColor = UIColor.orange
                upBtn.setTitleColor(UIColor.white, for: [])
            }
            else if upBtn.backgroundColor == UIColor.orange {
                upBtn.backgroundColor = UIColor.white
                upBtn.setTitleColor(UIColor.blue, for: [])
            }
        }
        else{
            notLoggedInAlert()
        }
    }
    
    @IBOutlet weak var downBtn: UIButton!
    @IBAction func downvote(_ sender: Any) {
        if (a.isAuthenticated) {
            if downBtn.backgroundColor == UIColor.white {
                downBtn.backgroundColor = UIColor.purple
                downBtn.setTitleColor(UIColor.white, for: [])
            }
            else if downBtn.backgroundColor == UIColor.purple {
                downBtn.backgroundColor = UIColor.white
                downBtn.setTitleColor(UIColor.blue, for: [])
            }
        }
        else{
            notLoggedInAlert()
        }
    }
    
    @IBOutlet weak var starBtn: UIButton!
    @IBAction func save(_ sender: Any) {
        if (a.isAuthenticated) {
            if starBtn.backgroundColor == UIColor.white {
                starBtn.backgroundColor = UIColor.yellow
                starBtn.setTitleColor(UIColor.white, for: [])
            }
            else if starBtn.backgroundColor == UIColor.yellow {
                starBtn.backgroundColor = UIColor.white
                starBtn.setTitleColor(UIColor.blue, for: [])
            }
        }
        else{
            notLoggedInAlert()
        }
    }
    
    @IBOutlet weak var commentBtn: UIButton!
    @IBAction func comment(_ sender: Any) {
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("loaded")
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
