//
//  ViewController.swift
//  OTPScreen
//
//  Created by Hidayat Abisena on 15/02/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var codeTextField: OTPTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        codeTextField.configure()
        codeTextField.didEnterLastDigit = { [weak self] code in
            print(code)
        }
        
    }

    @IBAction func verifiedBtnTapped(_ sender: Any) {
       print("button tapped..")
    }
    
}

