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
    
    let INITIAL_POST_COUNT = 1
    let urlPath:String = "https://www.reddit.com/r/pics/.json"
    var rawData = NSData()
    
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
        
        return cell
    }
    
    // MARK: - DEFAULT FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let temp = Post(title:"Ecks Dee", points:"42069", username:"bravoman", timestamp:"just now", image: #imageLiteral(resourceName: "tbh") )
        posts.append(temp)
        
        // Download the json file
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let url: NSURL = NSURL(string: urlPath)!
        let request: URLRequest = URLRequest(url: url as URL)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request, completionHandler:{ (data, response, error) in
            self.rawData = NSData(data:data!)
            let results = NSString(data: self.rawData as Data, encoding: String.Encoding.utf8.rawValue)
            print("the json file content is ")
            print(results!)
            print(response!)
            print("done")
            
            self.parseJSON()
        })
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - JSON FUCNTIONS
    func parseJSON(){
        var json:[String:Any]? = nil
        
        // parse json
        do {
            json = try JSONSerialization.jsonObject(with: self.rawData as Data, options:.allowFragments) as? [String:Any]
        } catch {
            
        }

        // Get the sub-json block "data". This block contains contains "children", which we need
        let data = json!["data"] as! [String:Any]?
        
        // "children" contains the first 25 posts of the subreddit. This property was parsed as a NSArray
        let postData = data!["children"] as! [[String:Any]]
        
        print(postData[0]["data"])
    }
}

