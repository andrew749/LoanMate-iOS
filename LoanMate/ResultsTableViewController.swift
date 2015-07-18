//
//  ResultsTableViewController.swift
//  LoanMate
//
//  Created by Andrew Codispoti on 2015-07-18.
//  Copyright (c) 2015 Andrew Codispoti. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(rgb: Int, alpha: CGFloat) {
        let r = CGFloat((rgb & 0xFF0000) >> 16)/255
        let g = CGFloat((rgb & 0xFF00) >> 8)/255
        let b = CGFloat(rgb & 0xFF)/255
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
    
    convenience init(rgb: Int) {
        self.init(rgb:rgb, alpha:1.0)
    }
}
class ResultsTableViewController:UIViewController,UITableViewDataSource,UITableViewDelegate{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var amountLabel: UILabel!
    var userID:String?
    var dataEntries:[DataEntry]=[]
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    override func viewDidLoad() {
        let number=10
        for x in 1..<number{
            dataEntries.append(DataEntry(amount: 5-Double(x), description: "test", userID: "pritham", token:"trololol"))
        }
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
        })
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataEntries.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("tablecell") as! ResultCell
        let entry=dataEntries[indexPath.row]
        let amount=entry.amount
        cell.amountLabel.text="\(amount)"
        if amount > 0{
            cell.backgroundColor=UIColor(rgb: 0x8ffcd6)
        }else if amount < 0{
            cell.backgroundColor=UIColor(rgb: 0xff9193)
        }else{
            cell.backgroundColor=UIColor(rgb: 0xdbdbdb)
        }
        cell.descriptionLabel.text=entry.description
        cell.namelabel.text=entry.userID
        return cell
    }
    func getData(){
        let url=NSURL(string: "\(Constants.baseURL())/data")
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