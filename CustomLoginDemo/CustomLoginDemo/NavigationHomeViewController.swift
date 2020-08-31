//
//  HomeViewController.swift
//  CustomLoginDemo
//
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth


class NavigationHomeViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
        navigationController?.isNavigationBarHidden = false
        
        overrideUserInterfaceStyle = .dark
    }
    
    func setUpElements() {
        // Style the elements
       
        
    }
    
    override open var shouldAutorotate: Bool {
       return false
    }

    // Specify the orientation.
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
       return .portrait
    }

}


