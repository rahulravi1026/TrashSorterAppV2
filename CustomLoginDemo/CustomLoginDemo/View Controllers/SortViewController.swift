//
//  SortViewController.swift
//  TrashSorterAppTest
//
//  Created by Rahul Ravi on 9/5/20.
//  Copyright © 2020 Christopher Ching. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class SortViewController: UIViewController {

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
    }
    
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
    /*
     
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
