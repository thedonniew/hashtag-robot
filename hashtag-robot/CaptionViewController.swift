//
//  ViewController.swift
//  hashtag-robot
//
//  Created by Donnie Wang on 11/10/14.
//  Copyright (c) 2014 Donnie Wang. All rights reserved.
//

import UIKit

class CaptionViewController: UIViewController, SuggestedHashtagsTableViewControllerDelegate {
    
    @IBOutlet weak var insertAllButton: UIButton!
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
    
    func checkInsertAll() {
        let selectedIndexPathsCount = hashtagsController?.tableView.indexPathsForSelectedRows()?.count
        if selectedIndexPathsCount == hashtagsController?.suggestedHashtags.count {
            insertAllButton?.setTitle("Remove All", forState: .Normal)
        } else {
            insertAllButton?.setTitle("Insert All", forState: .Normal)
        }
    }
    
    func removeHashTag(hashtag: String) {
        let caption:NSString? = captionTextView?.text
        var hashtagString: NSString = hashtag
        hashtagString = hashtagString.substringFromIndex(1)
        captionTextView?.text = caption?.stringByReplacingOccurrencesOfString(hashtag, withString: hashtagString)
    }
    
    // MARK: - SuggestedHashtagsTableViewController delegate
    
    func suggestedHashtagsTableViewController(controller: SuggestedHashtagsTableViewController, didSelectHashtag hashtag: String) {
        insertHashTag(hashtag)
        checkInsertAll()
    }
    
    func suggestedHashtagsTableViewController(controller: SuggestedHashtagsTableViewController, didDeselectHashtag hashtag: String) {
        removeHashTag(hashtag)
        checkInsertAll()
    }
    
    // MARK: - IB Actions
    
    @IBAction func insertAll(sender: AnyObject) {
        // check if all hashtags are selected
        let selectedIndexPathsCount = hashtagsController?.tableView.indexPathsForSelectedRows()?.count
        if selectedIndexPathsCount == hashtagsController?.suggestedHashtags.count {
            
            if let suggestedHashtags = hashtagsController?.suggestedHashtags {
                for  hashtag in suggestedHashtags {
                    removeHashTag(hashtag)
                }
                
                for var i = 0; i < suggestedHashtags.count; i++ {
                    let indexPath = NSIndexPath(forRow: i, inSection: 0)
                    hashtagsController?.tableView.deselectRowAtIndexPath(indexPath, animated: true)
                }
            }
            
        } else {
            if let suggestedHashtags = hashtagsController?.suggestedHashtags {
                for  hashtag in suggestedHashtags {
                    insertHashTag(hashtag)
                }
                
                for var i = 0; i < suggestedHashtags.count; i++ {
                    let indexPath = NSIndexPath(forRow: i, inSection: 0)
                    hashtagsController?.tableView .selectRowAtIndexPath(indexPath, animated: true, scrollPosition: .None)
                }
            }
        }
        
        checkInsertAll()
    }
}

