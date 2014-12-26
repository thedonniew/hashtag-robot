//
//  ViewController.swift
//  hashtag-robot
//
//  Created by Donnie Wang on 11/10/14.
//  Copyright (c) 2014 Donnie Wang. All rights reserved.
//

import UIKit
import MobileCoreServices

class CaptionViewController: UIViewController, SuggestedHashtagsTableViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var insertAllButton: UIButton!
    @IBOutlet var captionTextView : UITextView?
    @IBOutlet var imageView : UIImageView?
    
    var hashtagsController: SuggestedHashtagsTableViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //  present image picker controller
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            let cameraUI = UIImagePickerController()
            cameraUI.sourceType = .Camera
            cameraUI.mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(.Camera)!
            cameraUI.allowsEditing = false
            cameraUI.delegate = self
            self.presentViewController(cameraUI, animated: true, completion: nil)
        }
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
    
    
    // MARK: - UIImagePickerController delegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as String
        
        
        if mediaType == kUTTypeImage {
            let image = info[UIImagePickerControllerOriginalImage] as UIImage
            
            let size = CGSize(width: 80.0, height: 80.0)
            imageView?.image = self.scaleImage(image, size: size)
            println()
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func scaleImage(image: UIImage, size: CGSize) -> UIImage {
        let originalImageWidth = image.size.width
        let originalImageHeight = image.size.height
        
        var newImageWidth: CGFloat = 0.0
        var newImageHeight: CGFloat = 0.0
        
        if originalImageWidth < originalImageHeight {
            if originalImageWidth > size.width {
                newImageWidth = size.width;
                newImageHeight = originalImageHeight * newImageWidth / originalImageWidth;
                UIGraphicsBeginImageContextWithOptions(size, true, UIScreen.mainScreen().scale);
            } else {
                return image
            }
        } else {
            if originalImageHeight > size.height {
                newImageHeight = size.height;
                newImageWidth = originalImageWidth * newImageHeight / originalImageHeight;
                UIGraphicsBeginImageContextWithOptions(size, true, UIScreen.mainScreen().scale);
            } else {
                return image
            }
        }
        
        let x = (size.width - newImageWidth) / 2
        let y = (size.height - newImageHeight) / 2
        image .drawInRect(CGRect(x: x, y: y, width: newImageWidth, height: newImageHeight))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
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

