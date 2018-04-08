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
    
    var comments:[Comment] = []
    
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
        getJSON()
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
        return comments.count + 2
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
            cell?.Author.text = (comments[indexPath.row-2].getAuthor() + "  ")
            cell?.points.text = comments[indexPath.row-2].getScore() + " points"
            cell?.comment.text = comments[indexPath.row-2].getText()
            return cell!
        }
        
    }
    func getJSON(){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let url: NSURL = NSURL(string: urlPath)!
        var request: URLRequest = URLRequest(url: url as URL)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        print(urlPath)
        // if user is authenticated, include the token in the HTTP request header
        if (a.isAuthenticated) {
            request.httpMethod = "GET"
            request.setValue("Bearer " + a.token, forHTTPHeaderField: "Authorization")
        }
        
        let task = session.dataTask(with: request) { (data, response, error) in
            self.rawData = NSData(data:data!)
            //print(self.rawData)
            DispatchQueue.main.async {
                self.parseJSON()
            }
        }
        task.resume()
    }
    
    func parseJSON(){
        var json:[Any]? = nil
        
        // parse json
        do {
            json = try JSONSerialization.jsonObject(with: self.rawData as Data, options:.allowFragments) as? [Any]
        } catch {
            print("Error Parsing JSON")
            print(error)
        }
        //print(json)
        // Get the sub-json block "data". This block contains contains "children", which we need
        let comments = json![1] as! [String:Any]
        let data = comments["data"] as! [String:Any]?
        
        let postData = data!["children"] as! [[String:Any]]
        
        //print (postData.count)
        
        for i in 0...postData.count-1 {
            
            //print (postData[i]["kind"])
            if postData[i]["kind"] as! String == "t1"{
                let p = postData[i]["data"] as! [String:Any]
                let user = String(describing:p["author"]!)
                let score = String(describing:p["score"]!)
                let body = String(describing:p["body"]!)
                
                //print (user + score + body)
                let comObj = Comment(user: user,score: score,text: body)
                self.comments.append(comObj)
            }
        }
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }

        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Zoom" {
            if let destinationNavCtrl = segue.destination as? FullImageViewController{
                if let pic = post?.getImage(){
                    destinationNavCtrl.initImg(img: pic)
                }
            }
        } // ShowDetail
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
