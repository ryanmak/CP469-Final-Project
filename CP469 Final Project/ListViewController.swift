//
//  ListViewController.swift
//  CP469 Final Project
//
//  Created by Ryan Mak on 2018-04-03.
//  Copyright © 2018 Mak & Wu Collaborative. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {
    // currently loaded posts will be stored here
    var posts:[Post] = []
    
    // url and raw data are variables as they can change as more posts are loaded
    var urlPath:String = "https://www.reddit.com/r/pics/.json"
    var rawData = NSData()
    
    // reddit keeps the number of posts displayed at 25 posts/page.
    let NUM_OF_POSTS = 25
    var pageNumber = 1
    
    // after is used to keep track of pages
    // (i.e. a page will have an after "pointer" pointing to the next page)
    var after = String()


    // MARK: - TABLE FUNCTIONS
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "PostCellView"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PostCellView  else {
            fatalError("The dequeued cell is not an instance of PostCellView.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let post = posts[indexPath.row]
        
        cell.title.text = post.getTitle()
        cell.points.text = post.getPoints()
        cell.username.text = post.getUsername()
        cell.timestamp.text = post.getTimestamp()
        cell.postImage.image = post.getImage()
        
        // if user has reached bottom, load more posts
        if (indexPath.row == (NUM_OF_POSTS * pageNumber) - 1) {
            print("load more posts!")
            pageNumber = pageNumber + 1
            
            urlPath = "https://www.reddit.com/r/pics/.json?count=" + String(NUM_OF_POSTS * pageNumber) + "&after=" + after
            print(urlPath)
            getJSON()
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
        
        return cell
    }
    
    // MARK: - DEFAULT FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        let temp = Post(title:"Ecks Dee", points:"42069", username:"bravoman", timestamp:"just now", image: #imageLiteral(resourceName: "tbh") )
//        posts.append(temp)
        
        // Download the json file
        getJSON()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - JSON/HELPER FUCNTIONS
    func getJSON(){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let url: NSURL = NSURL(string: urlPath)!
        let request: URLRequest = URLRequest(url: url as URL)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request, completionHandler:{ (data, response, error) in
            self.rawData = NSData(data:data!)
            let results = NSString(data: self.rawData as Data, encoding: String.Encoding.utf8.rawValue)
            self.parseJSON()
        })
        task.resume()
    }
    
    func parseJSON(){
        var json:[String:Any]? = nil
        
        // parse json
        do {
            json = try JSONSerialization.jsonObject(with: self.rawData as Data, options:.allowFragments) as? [String:Any]
        } catch {
            print("Error Parsing JSON")
            print(error)
        }

        // Get the sub-json block "data". This block contains contains "children", which we need
        let data = json!["data"] as! [String:Any]?
        
        // Get the after pointer
        after = data!["after"] as! String
        print(after)
        
        // "children" contains the first 25 posts of the subreddit. This property was parsed as
        // a NSArray, but since we need to access the contents, cast as [[String:Any]] instead
        let postData = data!["children"] as! [[String:Any]]
        
        // convert individiaul posts to the Post object
        for i in 0...postData.count-1 {
            let p = postData[i]["data"] as! [String:Any]
            let title = String(describing:p["title"]!)
            let points = String(describing:p["score"]!)
            let username = String(describing:p["author"]!)
            
            // reddit gives time as a unix timestamp; we need to convert this to
            // a readable format, similar to the one reddit uses
            var timestamp = String(describing: p["created_utc"]!)
            timestamp = utsToRelativeTime(uts: timestamp)
            
            // reddit hides images in another series of nested json blocks. Call a
            // function to retrieve the URLs of the images
            let imageURL = getImageURL(post:p)
            
            // we need to download the image as a UIImage. Create an async task to download
            // the image and load all contents to a Post Object
            let url = URL(string: imageURL)
            var image = UIImage()
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async {
                    image = UIImage(data: data!)!
                    let postObj = Post(title:title,points:points,username:username,timestamp:timestamp,image:image)
                    self.posts.append(postObj)
                    self.tableView.beginUpdates()
                    
                    let indexPath:IndexPath = IndexPath(row:(self.posts.count - 1), section:0)
                    
                    self.tableView.insertRows(at: [indexPath], with: .left)
                    
                    self.tableView.endUpdates()
                }
            }
            
            print(title)
            print(points)
            print(username)
            print(imageURL)
            print("")
        }
    }
    // converts a unix timestamp into a relative time format (i.e. 1 hour ago, 5 days ago etc.)
    func utsToRelativeTime(uts:String)->String {
        let dateOfPost = NSDate(timeIntervalSince1970: Double(uts)!)
        let currentDate = NSDate()
        print(dateOfPost)
        print(currentDate)
        return ""
    }
    // returns the url of the image
    func getImageURL(post:[String:Any])->String{
        let preview = post["preview"] as! [String:Any]
        let images = preview["images"] as! [[String:Any]]
        let source = images[0]["source"] as! [String:Any]
        let imageURL = source["url"]!
        
        return String(describing: imageURL)
    }


}

