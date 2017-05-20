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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let initialSetUpDone = UserDefaults.standard.bool(forKey: "InitialSetUp")
        if initialSetUpDone == false {
            let authenticationConfiguration = DGTAuthenticationConfiguration(accountFields: .none)!
            authenticationConfiguration.phoneNumber = "+91"
            authenticationConfiguration.title = "Sign In"
            Digits.sharedInstance().authenticate(with: nil, configuration: authenticationConfiguration, completion: {[unowned self] (session, error) in
                DispatchQueue.main.async {
                    let cameraViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "QRCodeScanner") as! CameraViewController
                    let navigationController = UINavigationController(rootViewController: cameraViewController)
                    self.navigationController?.present(navigationController, animated: true, completion: nil)
                }
            })
        }
    }
}
