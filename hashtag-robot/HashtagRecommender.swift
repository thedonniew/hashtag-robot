//
//  HashtagRecommender.swift
//  hashtag-robot
//
//  Created by Gilman Tolle on 11/10/14.
//  Copyright (c) 2014 Donnie Wang. All rights reserved.
//

import UIKit
import SwifteriOS

class HashtagRecommender: NSObject {

    /*
        this crappy method will search twitter for the text you give it and then extract the hashtags from the top 15 tweets.
    
        it works best with single words, like 'kale' or 'breakfast', because twitter's search works best with single words.
    
        still need to figure out how to deal with a complicated message like 'start your day with a healthy breakfast of kale and oatmeal at @fuelcafe'.
    
        turn it into a series of searches for the important words?
    
        it's also my first piece of Swift code so it's probably terrible.
    
        but, hey - hashtags!
    */

    class func getHashtags(messageText:String, success:((hashtags:[String]) -> Void), failure:((error:NSError)->Void)) -> Void {
        
        func extractHashtags(text:String) -> Array<String> {
            println("Looking at tweet: \(text)")
            let regex = NSRegularExpression(pattern: "(#\\w+)", options: nil, error: nil)!
            let matches:[NSTextCheckingResult] = regex.matchesInString(text, options: nil, range: NSMakeRange(0, countElements(text))) as [NSTextCheckingResult]
            
            let textNSString = text as NSString // need to do this in order to call substringWithRange
            return matches.map( { textNSString.substringWithRange($0.range) })
        }

        // we'll need to register our own auth key at some point. using one copied from a tutorial for now.
        var swifter = Swifter(consumerKey: "RErEmzj7ijDkJr60ayE2gjSHT",
                           consumerSecret: "SbS0CHk11oJdALARa7NDik0nty4pXvAxdt7aj0R5y1gNzWaNEx")
        
        swifter.getSearchTweetsWithQuery(messageText,
            geocode: nil, lang: "en-us", locale: nil, resultType: "popular",
            count: 15, until: nil, sinceID: nil, maxID: nil,
            includeEntities: false, callback: nil,
            success: {
                (statuses, searchMetadata) in
                success(hashtags: statuses!.map { extractHashtags($0["text"].string!) }.reduce([String]()) { $0 + $1 })
            },
            failure: failure
        )
    }
}
