//
//  ITunesItem.swift
//  TableViewDemo
//
//  Created by Nick on 7/21/16.
//  Copyright © 2016 EntroByte LLC. All rights reserved.
//

import UIKit

class ITunesItem: NSObject {
    private var _artworkURL : String = "";
    var artworkURL : String{
        get{
            return _artworkURL;
        }
        set(withURL){
            var shouldUpdate = false;
            if (_artworkURL != withURL){
                //this is a new item assigned, get image data
                shouldUpdate = true;
            }
            _artworkURL = withURL;
            
            if (shouldUpdate){
                self.getArtwork();
            }
            
        }
    }

    var artworkImage : UIImage?
    var artistName : String = "";
    var trackName : String = "";
    
    override init() {
        super.init();
    }
    
    convenience init(trackName : String, artworkURL : String, artistName : String){
        self.init();
        
        self.artworkURL = artworkURL;
        self.artistName = artistName;
        self.trackName = trackName;
    }
    
    
    func getArtwork(){
        if let url = NSURL(string: artworkURL) {
            let request = NSURLRequest(URL: url)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
                (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                if let imageData = data as NSData? {
                    self.artworkImage = UIImage(data: imageData)
                }
            }
        }
        
    }
}
