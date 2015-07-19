//
//  CreateController.swift
//  LoanMate
//
//  Created by Andrew Codispoti on 2015-07-18.
//  Copyright (c) 2015 Andrew Codispoti. All rights reserved.
//

import Foundation
import UIKit

class CreateController:UIViewController{
    var username:String?
    @IBAction func cancelClick(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func create(sender: AnyObject) {
        let url=NSURL(string: "\(Constants.baseURL())/data/requestLoan?username=\(username!.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)&amount=\(userID!.text)")
        let request=NSURLRequest(URL: url!)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!, data: NSData!, error: NSError!) in
            if error == nil{
                if let dictionary = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableLeaves, error: nil) as? NSDictionary{
                    self.cancelClick(self)
                }
            }
        
        })

    }
    @IBOutlet weak var userID: UITextField!
    @IBOutlet weak var descriptionField: UITextView!
    override func viewDidLoad() {
    
    }
}