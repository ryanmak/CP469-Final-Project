//
//  PostViewController.swift
//  CP469 Final Project
//
//  Created by Jonathan Wu on 2018-04-07.
//  Copyright © 2018 Mak & Wu Collaborative. All rights reserved.
//

import UIKit

class PostViewController: UITableViewController {
    
    var post: Post?
    let baseLink = "https://reddit.com"
    let authLink = "https://oauth.reddit.com"
    
    var urlPath:String = ""
    var rawData = NSData()
    // authentication singleton
    var a = Authentication.sharedInstance
    // after is used to keep track of pages
    // (i.e. a page will have an after "pointer" pointing to the next page)
    var after = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140

        if (a.isAuthenticated) {
            urlPath = authLink + (post?.getLink())! + ".json"
        }
        else {
            urlPath = baseLink + (post?.getLink())! + ".json"
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func initWithPost(selected:Post){
        self.post = selected
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row == 0{
            return 300;
        }
        return UITableViewAutomaticDimension;//Choose your custom row height
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell") as! imageCell
            cell.picture.image = post?.getImage()
            
            return cell;
        }else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "pointCell") as! pointCell
            cell.author.text = "u/"+(post?.getUsername())!
            if let x = post?.getComments(){
                cell.comments.text = String(describing: x)
            }
            if let y = post?.getPoints(){
                cell.points.text = String(describing: y)
            }
            return cell
        }else{
            var cell = tableView.dequeueReusableCell(withIdentifier: "CommentsCell") as? CommentCell
            if (cell == nil) {
                cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "CommentCell") as? CommentCell
            }
            return cell!
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
