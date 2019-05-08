//
//  UploadImgViewController.swift
//  InstaCaption
//
//  Created by Eric Yang on 4/23/19.
//  Copyright © 2019 Eric Yang. All rights reserved.
//

import UIKit

class UploadImgViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // MARK: - Variable Declaration
    var uploaded : Bool = false
    var facesDetected : Int = 0
    var captions : [Caption] = []
    var finalCaption : String = ""
    var imageUrlText : String = ""
    var uploadedImage : UIImage!
    
    
    // MARK: - IB Outlets
    @IBOutlet weak var uploadedImg: UIImageView!
    @IBOutlet weak var generateButton: UIButton!
    @IBOutlet weak var imageUrlTextField: UITextField!
    @IBOutlet weak var uploadWithUrlButton: UIButton!
    
    // MARK: - IB Actions
    @IBAction func uploadImgDidPressed(_ sender: UIButton) {
        let imgController = UIImagePickerController()
        imgController.delegate = self
        imgController.sourceType = .photoLibrary
        imgController.allowsEditing = false
        self.present(imgController, animated: true) {
            // Completion Handler
        }
        
    }
    
    @IBAction func uploadWithUrlDidPressed(_ sender: UIButton) {
        // Check if user url input exists
        if let urlText = self.imageUrlTextField.text {
            imageUrlText = urlText
        } else {
            // Error textfield is empty
        }
        // Create Queue and Group
        let backgroundQ = DispatchQueue.global(qos: .background)
        let group = DispatchGroup()
        
        group.enter()
        backgroundQ.async(group: group, execute: {
            // Enable Background Tasks
            var bTask : UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
            bTask = UIApplication.shared.beginBackgroundTask {
                () -> Void in
                UIApplication.shared.endBackgroundTask(bTask)
            }
            if let url = URL(string: self.imageUrlText) {
                do {
                    let data = try Data(contentsOf: url)
                    if let image = UIImage(data: data) {
                        self.uploadedImage = image
                        print("image converted")
                    } else {
                        print("couldn't convert to img")
                    }
                }
                catch {
                    // Data is nil
                    print("Data is nil")
                }
            }
            DispatchQueue.main.async {
                self.uploadedImg.image = self.uploadedImage
                self.generateButton.isHidden = false
            }
        })
        group.leave()
    }
    
    
    @IBAction func generateDidPressed(_ sender: UIButton) {
        if let img = uploadedImg.image {
            detectFaces(img: img)
            captions = CaptionsModel.shared.returnCaptions(faces: facesDetected)
        }
        finalCaption = captions[0].text
    }
    
    
    // MARK: - Protocol Functions
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Check if can be converted to UIImage
        if let image = info[.originalImage] as? UIImage {
            uploadedImg.image = image
            generateButton.isHidden = false
        } else {
            // Error Message
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateButton.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    // MARK: - URL Download
    
    
    // MARK: - Facial Detection
    func detectFaces(img: UIImage) {
        var faces : [CIFeature] = []
        if let ci = img.cgImage {
            let ciImage = CIImage(cgImage: ci)
            let options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
            let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: options)!
            faces = faceDetector.features(in: ciImage)
            facesDetected = faces.count
            print("Faces found: \(facesDetected)")
        }
    }
    
    
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "presentImageWithCaption" {
            if let imageWithCaptionVC = segue.destination as? ImageWithCaptionViewController {
                imageWithCaptionVC.img = uploadedImg.image
                imageWithCaptionVC.caption = finalCaption
                imageWithCaptionVC.facesFound = facesDetected
            }
        }
    }

}
