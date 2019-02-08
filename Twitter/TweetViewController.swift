//
//  TweetViewController.swift
//  Twitter
//
//  Created by Miguel Barba on 2/5/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {

    @IBOutlet weak var tweetTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetTextView.becomeFirstResponder()
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tweet(_ sender: Any) {
        if (!tweetTextView.text.isEmpty){
                TwitterAPICaller.client?.postTweet(tweetString: tweetTextView.text, success: {
                self.dismiss(animated: true, completion: nil)
                }, failure: { (Error) in
                print("failed at tweeting \(Error)")
                self.dismiss(animated: true, completion: nil)
                })
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
}
