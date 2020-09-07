//
//  ProfileViewController.swift
//  TrashSorterAppTest
//
//  Created by Rahul Ravi on 9/5/20.
//  Copyright © 2020 Christopher Ching. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class ProfileViewController: UIViewController {

    @IBOutlet weak var landfillText: UILabel!
    @IBOutlet weak var recyclingText: UILabel!
    @IBOutlet weak var compostText: UILabel!
    @IBOutlet weak var profileText: UILabel!
    
    var myMutableString = NSMutableAttributedString()
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        DispatchQueue.main.async {
            self.profileNameChange()
            self.landfillTextChange()
            self.recyclingTextChange()
            self.compostTextChange()
        }
    }
    
    func profileNameChange() {
        let user = Auth.auth().currentUser
        if let user = user {
            let currentUID = user.uid
            self.db.collection("users").whereField("uid", isEqualTo: currentUID).getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                }
                else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        let docRef = self.db.collection("users").document(document.documentID)
                        docRef.getDocument { (document, error) in
                            if let document = document, document.exists {
                                let property1 = document.get("firstname")
                                print(property1)
                                self.profileText.text! = "\(property1 ?? 0)" + "'s Profile"
                               // let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                               // print("Document data: \(dataDescription)")
                            } else {
                                print("Document does not exist")
                            }
                        }
                        }
                        
                    }
                }
            }
    }
    
    func landfillTextChange() {

            let user = Auth.auth().currentUser
                if let user = user {
                    let currentUID = user.uid
                    self.db.collection("users").whereField("uid", isEqualTo: currentUID).getDocuments { (querySnapshot, error) in
                        if let error = error {
                            print("Error getting documents: \(error)")
                        }
                        else {
                            for document in querySnapshot!.documents {
                                print("\(document.documentID) => \(document.data())")
                                let docRef = self.db.collection("users").document(document.documentID)
                                docRef.getDocument { (document, error) in
                                    if let document = document, document.exists {
                                        let property = document.get("numLandfill")
                                        print(property)
                                        self.landfillText.text! = "Number of Landfill Pictures: " + "\(property ?? 0)"
                                       // let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                                       // print("Document data: \(dataDescription)")
                                    } else {
                                        print("Document does not exist")
                                    }
                                }
                                }
                                
                            }
                        }
                    }

        
    }
    
    func recyclingTextChange() {
            let user = Auth.auth().currentUser
                if let user = user {
                    let currentUID = user.uid
                    self.db.collection("users").whereField("uid", isEqualTo: currentUID).getDocuments { (querySnapshot, error) in
                        if let error = error {
                            print("Error getting documents: \(error)")
                        }
                        else {
                            for document in querySnapshot!.documents {
                                print("\(document.documentID) => \(document.data())")
                                let docRef = self.db.collection("users").document(document.documentID)
                                docRef.getDocument { (document, error) in
                                    if let document = document, document.exists {
                                        let property = document.get("numRecycling")
                                        print(property)
                                        self.recyclingText.text! = "Number of Recycling Pictures: " + "\(property ?? 0)"
                                       // let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                                       // print("Document data: \(dataDescription)")
                                    } else {
                                        print("Document does not exist")
                                    }
                                }
                                }
                                
                            }
                        }
                    }
        
    }
    
    func compostTextChange() {
            let user = Auth.auth().currentUser
                if let user = user {
                    let currentUID = user.uid
                    self.db.collection("users").whereField("uid", isEqualTo: currentUID).getDocuments { (querySnapshot, error) in
                        if let error = error {
                            print("Error getting documents: \(error)")
                        }
                        else {
                            for document in querySnapshot!.documents {
                                print("\(document.documentID) => \(document.data())")
                                let docRef = self.db.collection("users").document(document.documentID)
                                docRef.getDocument { (document, error) in
                                    if let document = document, document.exists {
                                        let property = document.get("numCompost")
                                        print(property)
                                        self.compostText.text! = "Number of Compost Pictures: " + "\(property ?? 0)"
                                       // let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                                       // print("Document data: \(dataDescription)")
                                    } else {
                                        print("Document does not exist")
                                    }
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
