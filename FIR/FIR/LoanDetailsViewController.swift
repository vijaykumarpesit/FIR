//
//  LoanDetailsViewController.swift
//  FIR
//
//  Created by Sachin Vas on 20/05/17.
//  Copyright © 2017 Vijay. All rights reserved.
//

import Foundation
import UIKit

class LoanDetailsViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var riskScore: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var tableViewCell = tableView.dequeueReusableCell(withIdentifier: "Document")
        if tableViewCell == nil {
            tableViewCell = UITableViewCell(style: .default, reuseIdentifier: "Document")
        }
        return tableViewCell!
    }
}
