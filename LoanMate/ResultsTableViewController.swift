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
class ResultsTableViewController:UIViewController,UITableViewDataSource,UITableViewDelegate,BTDropInViewControllerDelegate{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var amountLabel: UILabel!
    var userID:String?
    var dataEntries:[DataEntry]=[]
    var braintree:Braintree?
    var sum:Double = 0
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    override func viewDidLoad() {
        getData()
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
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let entry=dataEntries[indexPath.row]
        braintree = Braintree(clientToken: Constants.token)
        let controller=UINavigationController(rootViewController: braintree!.dropInViewControllerWithDelegate(self))
        controller.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "dropInViewControllerDidCancel")
        self.presentViewController(controller, animated: true, completion: nil)
        
    }
    func getData(){
        let urlString = "\(Constants.baseURL())/data/userData/\(userID!.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)"
        let url=NSURL(string: urlString)
        let request=NSURLRequest(URL: url!)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!, data: NSData!, error: NSError!) in
            if error == nil{
                if let dictionary = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableLeaves, error: nil) as? NSDictionary{
                    self.didReceiveResponse(dictionary)
                }
            }
        })
    }
    func didReceiveResponse(data:NSDictionary){
        Constants.token = data["client_token"] as? String
        if let lendingBalance:Double = data["lending_balance"] as? Double{
            for x in data["loans_granted"] as! NSArray{
                if let amount=x["amount"] as? Double, description = x["description"] as? String, transactionID = x["id"] as? Double{
                    self.dataEntries.append(DataEntry(amount: amount, description: description, transactionID: "\(transactionID)"))
                }
            }
            for x in data["loans_outstanding"] as! NSArray{
                if let amount=x["amount"] as? Double, description = x["description"] as? String, transactionID = x["id"] as? Double{
                    self.dataEntries.append(DataEntry(amount: -amount, description: description, transactionID: "\(transactionID)"))
                }
            }
            for x in dataEntries{
                sum += x.amount
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
                self.balanceLabel.text = NSString(format: "%.2f", self.sum) as String
                self.lendingBalanceLabel.text = NSString(format: "%.2f", lendingBalance) as String
            })
        }
    }
    @IBOutlet weak var lendingBalanceLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    //MARK: BT
    func dropInViewControllerDidCancel(viewController: BTDropInViewController!) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    func dropInViewController(viewController: BTDropInViewController!, didSucceedWithPaymentMethod paymentMethod: BTPaymentMethod!) {
        //code to post nonce to server
        dismissViewControllerAnimated(true, completion: nil)
    }
    func postNonceToServer(nonce:String){
        let paymenturl=NSURL(string: "\(Constants.baseURL())/data/payLoan?username=\(userID!.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding))&loan_id=\(tableView.indexPathForSelectedRow())")
        var request = NSMutableURLRequest(URL: paymenturl!)
        request.HTTPBody="payment_method_nonce=\(nonce)".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        NSURLConnection.sendAsynchronousRequest(request as NSURLRequest, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            print(data)
        })
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "createsegue"{
            if let destination = segue.destinationViewController as? CreateController{
                destination.username=self.userID
            }
        }
    }
}