//
//  ViewController.swift
//  hashtag-robot
//
//  Created by Donnie Wang on 11/10/14.
//  Copyright (c) 2014 Donnie Wang. All rights reserved.
//

import UIKit

class CaptionViewController: UIViewController, SuggestedHashtagsTableViewControllerDelegate {
    
    @IBOutlet var captionTextView : UITextView?
    var hashtagsController: SuggestedHashtagsTableViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "SuggestedHashtagsSegue") {
            let controller = segue.destinationViewController as SuggestedHashtagsTableViewController
            controller.delegate = self
            
            hashtagsController = controller
        }
    }
    
    func insertHashTag(hashtag: String) {
        let caption:NSString? = captionTextView?.text
        if caption?.rangeOfString(hashtag).location == NSNotFound {
            var hashtagString: NSString = hashtag
            hashtagString = hashtagString.substringFromIndex(1)
            captionTextView?.text = caption?.stringByReplacingOccurrencesOfString(hashtagString, withString: hashtag)
        }

    }
    
    // MARK: - SuggestedHashtagsTableViewController delegate
    
    func suggestedHashtagsTableViewController(controller: SuggestedHashtagsTableViewController, didSelectHashtag hashtag: String) {
        insertHashTag(hashtag)
    }
    
    // MARK: - IB Actions
    
    @IBAction func insertAll(sender: AnyObject) {
        if let suggestedHashtags = hashtagsController?.suggestedHashtags {
            for  hashtag in suggestedHashtags {
                insertHashTag(hashtag)
            }
        }
    }
}

