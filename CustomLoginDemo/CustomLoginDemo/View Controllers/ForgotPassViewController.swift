//
//  ForgotPassViewController.swift
//  TrashSorterAppTest
//
//  Created by Rahul Ravi on 9/5/20.
//  Copyright © 2020 Christopher Ching. All rights reserved.
//

import UIKit
import Firebase

class ForgotPassViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setUpElements()
        navigationController?.isNavigationBarHidden = false
        
        overrideUserInterfaceStyle = .dark
    }
    
    func setUpElements() {
        
        // Hide the error label
        errorLabel.alpha = 0
        
        // Style the elements
        Utilities.styleTextField(emailTextField)
    }
    
    
    override open var shouldAutorotate: Bool {
       return false
    }

    // Specify the orientation.
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
       return .portrait
    }
    
    
    @IBAction func forgotPassButton_Tapped(_ sender: Any) {
        let auth = Auth.auth()
        
        auth.sendPasswordReset(withEmail: emailTextField.text!) { (error) in
            if let error = error {
                self.errorLabel.text = error.localizedDescription
                self.errorLabel.alpha = 1
            }
            else {
                self.errorLabel.text = "Password Reset Email Successfully Sent"
                self.errorLabel.textColor = UIColor.purple
                self.errorLabel.alpha = 1
            }
        }
    }
    
}
