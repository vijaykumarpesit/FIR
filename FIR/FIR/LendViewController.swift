//
//  LendViewController.swift
//  FIR
//
//  Created by Sachin Vas on 20/05/17.
//  Copyright © 2017 Vijay. All rights reserved.
//

import Foundation
import UIKit
import DigitsKit

class LendViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "InvestCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Invest")
    }
    
  /*  override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let initialSetUpDone = UserDefaults.standard.bool(forKey: "InitialSetUp")
        if initialSetUpDone == false {
            let authenticationConfiguration = DGTAuthenticationConfiguration(accountFields: .none)!
            authenticationConfiguration.phoneNumber = "+91"
            authenticationConfiguration.title = "Sign In"
           /* Digits.sharedInstance().authenticate(with: nil, configuration: authenticationConfiguration, completion: {[unowned self] (session, error) in
                if let digitsError = error {
                    print(digitsError)
                } else if let phoneNumber = session?.phoneNumber {
                    DispatchQueue.main.async {
                        print(phoneNumber)
                        let cameraViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "QRCodeScanner") as! CameraViewController
                        let navigationController = UINavigationController(rootViewController: cameraViewController)
                        self.navigationController?.present(navigationController, animated: true, completion: {
                            UserDefaults.standard.set(true, forKey: "InitialSetUp")
                        })
                    }*/
                }
            })
        }
    }*/
    
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
