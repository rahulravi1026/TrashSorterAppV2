//
//  HomeViewController.swift
//  CustomLoginDemo
//
//  Created by Rahul Ravi on 2020-07-13.
//  Copyright © 2020 Rahul Ravi. All rights reserved.
//

import UIKit
import Firebase


class HomeViewController: UIViewController {

    @IBOutlet weak var landfillButton: UIButton!
    @IBOutlet weak var recyclingButton: UIButton!
    @IBOutlet weak var compostButton: UIButton!
    static var landfillClicked: Bool = false
    static var recyclingClicked: Bool = false
    static var compostClicked: Bool = false
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
        
    }
    
    func setUpElements() {
        // Style the elements
        Utilities.styleFilledButton(landfillButton)
        Utilities.styleFilledButton(recyclingButton)
        Utilities.styleFilledButton(compostButton)
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func landfillTapped(_ sender: Any) {
        let user = Auth.auth().currentUser
        if let user = user {
            let currentUID = user.uid
            db.collection("users").whereField("uid", isEqualTo: currentUID).getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                }
                else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        self.db.collection("users").document(document.documentID).updateData(["numLandfill" : FieldValue.increment(Int64(1))]) { (error) in
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func recyclingTapped(_ sender: Any) {
        let user = Auth.auth().currentUser
        if let user = user {
            let currentUID = user.uid
            db.collection("users").whereField("uid", isEqualTo: currentUID).getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                }
                else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        self.db.collection("users").document(document.documentID).updateData(["numRecycling" : FieldValue.increment(Int64(1))]) { (error) in
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func compostTapped(_ sender: Any) {
        let user = Auth.auth().currentUser
        if let user = user {
            let currentUID = user.uid
            db.collection("users").whereField("uid", isEqualTo: currentUID).getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                }
                else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        self.db.collection("users").document(document.documentID).updateData(["numCompost" : FieldValue.increment(Int64(1))]) { (error) in
                        }
                    }
                }
            }
        }
    }
    
    

    
    

}


