//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Miguel Barba on 2/2/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    var tweetArray = [NSDictionary]()
    var numberOfTweet : Int!
    let myRefreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadTweets()
        myRefreshControl.addTarget(self, action: #selector(loadTweets) , for:.valueChanged)
        tableView.refreshControl = myRefreshControl
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        self.loadTweets()
    }
    
    @objc func loadTweets(){
        numberOfTweet = 10
        let  myParams = ["count" : numberOfTweet]
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams as [String : Any]
            , success: { (tweets: [NSDictionary]) in
                self.tweetArray.removeAll()
                for tweet in tweets{
                    self.tweetArray.append(tweet)
                }
                self.tableView.reloadData()
                self.myRefreshControl.endRefreshing()
        }, failure: { (Error) in
            print("Could not retrieve tweet")
        })
    }

    // MARK: - Table view data source
    func loadMoreTweets(){
        numberOfTweet = numberOfTweet + 20
        let myParams = ["count": numberOfTweet]
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams as [String : Any]
            , success: { (tweets: [NSDictionary]) in
                self.tweetArray.removeAll()
                for tweet in tweets{
                    self.tweetArray.append(tweet)
                }
                self.tableView.reloadData()
        }, failure: { (Error) in
            print("Could not retrieve tweet")
        })
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == tweetArray.count {
            loadMoreTweets()
        }
    }
    

    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCellTableViewCell
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        cell.userNameLabel.text = user["name"] as? String
        cell.tweetContent.text = tweetArray[indexPath.row]["text"] as? String
        let imageUrl = URL(string: user["profile_image_url_https"] as! String)
        let data = try? Data(contentsOf: imageUrl!)
        if let imageData = data {
            cell.profileImageView.image = UIImage(data: imageData)
        }
        cell.setFavorite(tweetArray[indexPath.row]["favorited"] as! Bool)
        //cell.setFavorite(tweetArray[indexPath.row]["favorited"] as! Bool)
        cell.tweetId = tweetArray[indexPath.row]["id"] as! Int
        cell.setRetweeted(tweetArray[indexPath.row]["retweeted"] as! Bool)
        print(tweetArray[indexPath.row])
        cell.numOfLikesLabel.text = String(tweetArray[indexPath.row]["favorite_count"] as! Int)
        cell.numOfRetweetsLabel.text = String(tweetArray[indexPath.row]["retweet_count"] as! Int)
        let dateText = (tweetArray[indexPath.row]["created_at"] as! String).components(separatedBy: " ")
        cell.dateLabel.text = dateText[1] + " " + dateText[2]
        
        return cell
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count
    }
}
