//
//  ViewController.swift
//  LoanMate
//
//  Created by Andrew Codispoti on 2015-07-18.
//  Copyright (c) 2015 Andrew Codispoti. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ConnectedDelegate {
    var successfullyConnected:Bool=false
    @IBOutlet weak var useridField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func connectClick(sender: AnyObject) {
        if let userId=useridField.text{
            doConnection("test")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func doConnection(loginName:String){
        
        let url=NSURL(string: "http://loanmate.herokuapp.com/login?username=\(loginName)")
        let request=NSURLRequest(URL: url!)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!, data: NSData!, error: NSError!) in
            if error == nil{
                self.didRecieveResponse(true)
            }
        })
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "connectaction"{
            if let destination = segue.destinationViewController as? ResultsTableViewController{
                
            }
        }
    }
    func didRecieveResponse(success:Bool){
        if success{
            print("success")
            self.performSegueWithIdentifier("connectaction", sender: self)
        }
    }
}

