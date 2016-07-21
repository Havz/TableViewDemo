//
//  ViewController.swift
//  TableViewDemo
//
//  Created by Nick on 7/21/16.
//  Copyright © 2016 EntroByte LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var activityMonitor : UIActivityIndicatorView!;
    @IBOutlet weak var songTableView : UITableView!;
    
    private var _songCollection : [ITunesItem] = [ITunesItem]();

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //view loaded, get the itunes data for a 'michael jackson' search
        let searchURL : String = "https://itunes.apple.com/search?term=Michael+jackson";
        
        let requestURL: NSURL = NSURL(string: searchURL)!;
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL);
        let session = NSURLSession.sharedSession();
        let fetchTask = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) -> Void in
            
            //cast the generic response to httpResponse
            let httpResponse = response as! NSHTTPURLResponse
            
            if (httpResponse.statusCode == 200) {
                do{
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
                    
                    if let items = json["results"] as? [[String: AnyObject]] {
                        
                        for item in items {
                            //build out a new ITunesItem from the json entry
                            var newItunesItem : ITunesItem = ITunesItem();
                            if let trackName = item["trackName"] as? String{
                                newItunesItem.trackName = trackName;
                            }
                            if let artworkURL = item["artworkUrl30"] as? String{
                                newItunesItem.artworkURL = artworkURL;
                            }
                            if let artistName = item["artistName"] as? String{
                                newItunesItem.artistName = artistName;
                            }
                            
                            self._songCollection.append(newItunesItem);
                        }
                        
                    }
                    //data all collected, update the table on the main thread
                    self.performSelectorOnMainThread(#selector(ViewController.finishedLoading), withObject: nil, waitUntilDone: false);
                }catch {
                    print("Error! \(error)");
                }
            }
            //error retrieving valid response
            else{
                //all other responses treat as an error
                let alert = UIAlertController(title: "Oops", message: "Unable to get song list", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil);
            }
            
            
        }
        
        fetchTask.resume();
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func finishedLoading(){
        self.activityMonitor.hidden = true;
        songTableView.reloadData();
    }
    
    //MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80.0
    }
    
    //MARK: - UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _songCollection.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellID = "TableCell";
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID) as! ITunesTableViewCell;
        
        //populate this cell prototype with the data from the collection
        let songData : ITunesItem = _songCollection[indexPath.row];
        
        cell.artistLabel.text = songData.artistName;
        cell.trackName.text = songData.trackName;
        cell.artworkImage.image = songData.artworkImage;
        
        
        return cell;
    }

}

