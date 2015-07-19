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
    
    @IBAction func cancelClick(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func create(sender: AnyObject) {
    }
    @IBOutlet weak var userID: UITextField!
    @IBOutlet weak var descriptionField: UITextView!
    override func viewDidLoad() {
    
    }
}