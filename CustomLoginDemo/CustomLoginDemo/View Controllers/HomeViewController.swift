//
//  HomeViewController.swift
//  CustomLoginDemo
//
//  Created by Rahul Ravi on 2020-07-13.
//  Copyright © 2020 Rahul Ravi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import AVFoundation
import FirebaseStorage


class HomeViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

//    @IBOutlet weak var landfillButton: UIButton!
//    @IBOutlet weak var recyclingButton: UIButton!
//    @IBOutlet weak var compostButton: UIButton!
//    static var landfillClicked: Bool = false
//    static var recyclingClicked: Bool = false
//    static var compostClicked: Bool = false
    let db = Firestore.firestore()
    private var imageData:CollectionReference!
    var previewLayer:CALayer!
    
    var captureDevice:AVCaptureDevice!
    
    var takePhoto = false
    
    let captureSession = AVCaptureSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
        navigationController?.isNavigationBarHidden = false
        prepareCamera()
    }
    
    func setUpElements() {
        // Style the elements
//        Utilities.styleFilledButton(landfillButton)
//        Utilities.styleFilledButton(recyclingButton)
//        Utilities.styleFilledButton(compostButton)
        
    }
    
    func prepareCamera() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
        if let availableDevices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back).devices.first {
            captureDevice = availableDevices
            beginSession()
        }
    }
    
    func beginSession() {
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
            
            captureSession.addInput(captureDeviceInput)
        } catch {
            print(error.localizedDescription)
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.previewLayer = previewLayer
        self.view.layer.addSublayer(self.previewLayer)
        self.previewLayer.frame = self.view.layer.frame
        captureSession.startRunning()
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as String):NSNumber(value:kCVPixelFormatType_32BGRA)]
        
        dataOutput.alwaysDiscardsLateVideoFrames = true
        
        if captureSession.canAddOutput(dataOutput) {
            captureSession.addOutput(dataOutput)
        }
        
        captureSession.commitConfiguration()
        
        let queue = DispatchQueue(label: "com.aryanvaswani.captureQueue")
        dataOutput.setSampleBufferDelegate(self, queue: queue)
        
        
    }
    
    
    @IBAction func takePhoto(_ sender: Any) {
        takePhoto = true
    }
    
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if takePhoto {
            takePhoto = false
            
            if let image = self.getImageFromSampleBuffer(buffer: sampleBuffer) {
                
                DispatchQueue.main.async {
                    
                    let photoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PhotoVC") as! PhotoViewController
                    
                    photoVC.takenPhoto = image
                    
                    
                    
                    guard let data = image.jpegData(compressionQuality: 1.0) else { return }
                    let storage = Storage.storage()
                    let randString = self.randomString(length: 8)
                    let storageRef = storage.reference()
                    let imageRef = storageRef.child("images/" + randString + ".jpg")
                    
                    let uploadTask = imageRef.putData(data, metadata: nil) { (metadata, error) in
                        if let error = error {
                            return
                        }
                        else {
                            imageRef.downloadURL(completion: { (url, error) in
                                if let error = error {
                                    return
                                }
                            })
                        }
                        
                    }
                    
                    let url = URL(string: "https://us-central1-trashsorterappv2.cloudfunctions.net/classify?image=" + "https://storage.cloud.google.com/trashsorterappv2.appspot.com/images/" + randString + ".jpg")
                    
                    guard let requestUrl = url else { fatalError() }
                    // Create URL Request
                    var request = URLRequest(url: requestUrl)
                    // Specify HTTP Method to use
                    request.httpMethod = "GET"
                    // Send HTTP Request
                    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                      // Check if Error took place
                      if let error = error {
                        print("Error took place \(error)")
                        return
                      }
                      // Read HTTP Response Status code
                      if let response = response as? HTTPURLResponse {
                        print("Response HTTP Status code: \(response.statusCode)")
                      }
                      // Convert HTTP Response Data to a simple String
                      if let data = data, let dataString = String(data: data, encoding: .utf8) {
                        print("Response data string:\n \(dataString)")
                      }
                    }
                    
//                    guard let data = image.jpegData(compressionQuality: 1.0) else { return }
//
//                    let user = Auth.auth().currentUser
//                    if let user = user {
//                        let currentUID = user.uid
//                        self.db.collection("users").whereField("uid", isEqualTo: currentUID).getDocuments { (querySnapshot, error) in
//                            if let error = error {
//                                print("Error getting documents: \(error)")
//                            }
//                            else {
//                                for document in querySnapshot!.documents {
//                                    print("\(document.documentID) => \(document.data())")
//                                    self.db.collection("users").document(document.documentID).updateData(["takenImage" : data])
//                                    { (error) in
//                                    }
//                                    self.imageData = self.db.collection("users")
//                                    self.imageData.getDocuments{(snapshot, error) in
//                                        if let err = error{
//                                            debugPrint(err.localizedDescription)
//                                        }
//                                        else {
//                                            print(snapshot?.documents as Any)
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                    }
                    
                    self.present(photoVC, animated: true, completion: nil)
                }
            }
        }
    }
    
    func getImageFromSampleBuffer (buffer:CMSampleBuffer) -> UIImage?{
        if let pixelBuffer = CMSampleBufferGetImageBuffer(buffer) {
            let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
            let context = CIContext()
            
            let imageRect = CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(pixelBuffer), height: CVPixelBufferGetHeight(pixelBuffer))
            
            if let image = context.createCGImage(ciImage, from: imageRect) {
                return UIImage(cgImage: image, scale: UIScreen.main.scale, orientation: .right)
            }
        }
        
        return nil
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    /*
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
    
    */

    
    

}


