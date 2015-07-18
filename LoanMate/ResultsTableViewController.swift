//
//  ResultsTableViewController.swift
//  LoanMate
//
//  Created by Andrew Codispoti on 2015-07-18.
//  Copyright (c) 2015 Andrew Codispoti. All rights reserved.
//

import Foundation
import UIKit

class ResultsTableViewController:UIViewController,UITableViewDataSource,UITableViewDelegate{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var amountLabel: UILabel!
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("tablecell") as! ResultCell
        return cell
    }
    func getData(){
        let url=NSURL(string: "http://loanmate.herokuapp.com/data")
        let request=NSURLRequest(URL: url!)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!, data: NSData!, error: NSError!) in
            if error != nil{
                let dictionary=NSDictionary()
                self.didReceiveResponse(dictionary)
            }
        })
    }
    func didReceiveResponse(data:NSDictionary){
        print("yes")
    }
}