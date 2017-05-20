//
//  BorrowViewController.swift
//  FIR
//
//  Created by Sachin Vas on 20/05/17.
//  Copyright © 2017 Vijay. All rights reserved.
//

import Foundation
import UIKit

class BorrowViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "InvestCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Invest")
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "Invest") as! InvestCell
        return tableViewCell
    }

}
