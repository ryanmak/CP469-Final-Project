//
//  PostViewController.swift
//  CP469 Final Project
//
//  Created by Jonathan Wu on 2018-04-07.
//  Copyright © 2018 Mak & Wu Collaborative. All rights reserved.
//

import UIKit

class PostViewController: UITableViewController {
    
    @IBOutlet weak var nav: UINavigationItem!
    
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
    
    
    @IBAction func commentButton(_ sender: Any) {
        
        if (a.isAuthenticated) {
            var comment = ""
            let alert = UIAlertController(title: "Create Comment", message:"Enter Comment", preferredStyle: .alert)
            alert.addTextField { (textField) in
                    textField.text = "Comment goes here"
            }
            alert.addAction(UIAlertAction(title:"OK", style: .default,handler: { [weak alert] (_) in
                let textField = alert?.textFields![0]
                comment = (textField?.text)!
                print (comment)
            }))
            
            self.present(alert, animated: true, completion: nil)
            
            let json: [String: Any] = ["parent": baseLink + (post?.getLink())!,"text":comment]
            
            let jsonData = try? JSONSerialization.data(withJSONObject: json)
            let url = URL(string: "http://oauth.reddit.com/api/comment")
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    return
                }
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                    print(responseJSON)
                }
            }
            
            task.resume()
            
        }else{
            notLoggedInAlert()
        }
    }
    func notLoggedInAlert(){
        let alert = UIAlertController(title: "Not Logged In", message: "In order to comments a post, you need to log in", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        nav.title = post?.getTitle()
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
            cell.id = post?.getID()
            
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
