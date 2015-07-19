//
//  BTViewController.swift
//  LoanMate
//
//  Created by Andrew Codispoti on 2015-07-18.
//  Copyright (c) 2015 Andrew Codispoti. All rights reserved.
//

import Foundation
import UIKit
class BTViewController:UIViewController,BTDropInViewControllerDelegate{
    var braintree:Braintree?
    func dropInViewController(viewController: BTDropInViewController!, didSucceedWithPaymentMethod paymentMethod: BTPaymentMethod!) {
        
    }
    func dropInViewControllerDidCancel(viewController: BTDropInViewController!) {
        <#code#>
    }
}