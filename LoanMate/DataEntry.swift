//
//  DataEntry.swift
//  LoanMate
//
//  Created by Andrew Codispoti on 2015-07-18.
//  Copyright (c) 2015 Andrew Codispoti. All rights reserved.
//

import Foundation

class DataEntry{
    var amount:Double=0
    var description:String?
    var transactionID:String?
    init(amount:Double, description:String, transactionID:String){
        self.amount=amount
        self.description=description
        self.transactionID=transactionID
    }
}