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
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    override func viewDidLoad() {
//        let number=10
//        for x in 1..<number{
//            dataEntries.append(DataEntry(amount: 5-Double(x), description: "test", userID: "pritham", token:"eyJ2ZXJzaW9uIjoyLCJhdXRob3JpemF0aW9uRmluZ2VycHJpbnQiOiJlZjU0MzhiMDY4NDU5ZTVkMTY0YmRmYjQ1ODEzMzkxYmY0NzM4YTFjZmNjNTYwZDhmYTE5ZTVlYWM2YmU4Njg0fGNyZWF0ZWRfYXQ9MjAxNS0wNy0xOFQyMjo0MDo1OS43NTk2MjU5MDIrMDAwMFx1MDAyNm1lcmNoYW50X2lkPWRjcHNweTJicndkanIzcW5cdTAwMjZwdWJsaWNfa2V5PTl3d3J6cWszdnIzdDRuYzgiLCJjb25maWdVcmwiOiJodHRwczovL2FwaS5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tOjQ0My9tZXJjaGFudHMvZGNwc3B5MmJyd2RqcjNxbi9jbGllbnRfYXBpL3YxL2NvbmZpZ3VyYXRpb24iLCJjaGFsbGVuZ2VzIjpbXSwiZW52aXJvbm1lbnQiOiJzYW5kYm94IiwiY2xpZW50QXBpVXJsIjoiaHR0cHM6Ly9hcGkuc2FuZGJveC5icmFpbnRyZWVnYXRld2F5LmNvbTo0NDMvbWVyY2hhbnRzL2RjcHNweTJicndkanIzcW4vY2xpZW50X2FwaSIsImFzc2V0c1VybCI6Imh0dHBzOi8vYXNzZXRzLmJyYWludHJlZWdhdGV3YXkuY29tIiwiYXV0aFVybCI6Imh0dHBzOi8vYXV0aC52ZW5tby5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tIiwiYW5hbHl0aWNzIjp7InVybCI6Imh0dHBzOi8vY2xpZW50LWFuYWx5dGljcy5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tIn0sInRocmVlRFNlY3VyZUVuYWJsZWQiOnRydWUsInRocmVlRFNlY3VyZSI6eyJsb29rdXBVcmwiOiJodHRwczovL2FwaS5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tOjQ0My9tZXJjaGFudHMvZGNwc3B5MmJyd2RqcjNxbi90aHJlZV9kX3NlY3VyZS9sb29rdXAifSwicGF5cGFsRW5hYmxlZCI6dHJ1ZSwicGF5cGFsIjp7ImRpc3BsYXlOYW1lIjoiQWNtZSBXaWRnZXRzLCBMdGQuIChTYW5kYm94KSIsImNsaWVudElkIjpudWxsLCJwcml2YWN5VXJsIjoiaHR0cDovL2V4YW1wbGUuY29tL3BwIiwidXNlckFncmVlbWVudFVybCI6Imh0dHA6Ly9leGFtcGxlLmNvbS90b3MiLCJiYXNlVXJsIjoiaHR0cHM6Ly9hc3NldHMuYnJhaW50cmVlZ2F0ZXdheS5jb20iLCJhc3NldHNVcmwiOiJodHRwczovL2NoZWNrb3V0LnBheXBhbC5jb20iLCJkaXJlY3RCYXNlVXJsIjpudWxsLCJhbGxvd0h0dHAiOnRydWUsImVudmlyb25tZW50Tm9OZXR3b3JrIjp0cnVlLCJlbnZpcm9ubWVudCI6Im9mZmxpbmUiLCJ1bnZldHRlZE1lcmNoYW50IjpmYWxzZSwiYnJhaW50cmVlQ2xpZW50SWQiOiJtYXN0ZXJjbGllbnQzIiwibWVyY2hhbnRBY2NvdW50SWQiOiJzdGNoMm5mZGZ3c3p5dHc1IiwiY3VycmVuY3lJc29Db2RlIjoiVVNEIn0sImNvaW5iYXNlRW5hYmxlZCI6dHJ1ZSwiY29pbmJhc2UiOnsiY2xpZW50SWQiOiIxMWQyNzIyOWJhNThiNTZkN2UzYzAxYTA1MjdmNGQ1YjQ0NmQ0ZjY4NDgxN2NiNjIzZDI1NWI1NzNhZGRjNTliIiwibWVyY2hhbnRBY2NvdW50IjoiY29pbmJhc2UtZGV2ZWxvcG1lbnQtbWVyY2hhbnRAZ2V0YnJhaW50cmVlLmNvbSIsInNjb3BlcyI6ImF1dGhvcml6YXRpb25zOmJyYWludHJlZSB1c2VyIiwicmVkaXJlY3RVcmwiOiJodHRwczovL2Fzc2V0cy5icmFpbnRyZWVnYXRld2F5LmNvbS9jb2luYmFzZS9vYXV0aC9yZWRpcmVjdC1sYW5kaW5nLmh0bWwiLCJlbnZpcm9ubWVudCI6Im1vY2sifSwibWVyY2hhbnRJZCI6ImRjcHNweTJicndkanIzcW4iLCJ2ZW5tbyI6Im9mZmxpbmUiLCJhcHBsZVBheSI6eyJzdGF0dXMiOiJtb2NrIiwiY291bnRyeUNvZGUiOiJVUyIsImN1cnJlbmN5Q29kZSI6IlVTRCIsIm1lcmNoYW50SWRlbnRpZmllciI6Im1lcmNoYW50LmNvbS5icmFpbnRyZWVwYXltZW50cy5zYW5kYm94LkJyYWludHJlZS1EZW1vIiwic3VwcG9ydGVkTmV0d29ya3MiOlsidmlzYSIsIm1hc3RlcmNhcmQiLCJhbWV4Il19fQ=="))
//        }
//        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//            self.tableView.reloadData()
//        })
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
        cell.namelabel.text=entry.userID
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let entry=dataEntries[indexPath.row]
        braintree = Braintree(clientToken: entry.token)
        let controller=UINavigationController(rootViewController: braintree!.dropInViewControllerWithDelegate(self))
        controller.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "dropInViewControllerDidCancel")
        self.presentViewController(controller, animated: true, completion: nil)
        
    }
    func getData(){
        let url=NSURL(string: "\(Constants.baseURL())/data/userData/\(userID!)")
        let request=NSURLRequest(URL: url!)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!, data: NSData!, error: NSError!) in
            if error == nil{
                let dictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableLeaves, error: nil) as! NSDictionary
                self.didReceiveResponse(dictionary)
            }
        })
    }
    func didReceiveResponse(data:NSDictionary){
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
    }
    //MARK: BT
    func dropInViewControllerDidCancel(viewController: BTDropInViewController!) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    func dropInViewController(viewController: BTDropInViewController!, didSucceedWithPaymentMethod paymentMethod: BTPaymentMethod!) {
        //code to post nonce to server
        dismissViewControllerAnimated(true, completion: nil)
    }
    func postNonceToServer(nonce:String){
        let paymenturl=NSURL(string: "\(Constants.baseURL())/data/userData/\(userID!)")
        var request = NSMutableURLRequest(URL: paymenturl!)
        request.HTTPBody="payment_method_nonce=\(nonce)".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        NSURLConnection.sendAsynchronousRequest(request as NSURLRequest, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            print(data)
        })
    }
}