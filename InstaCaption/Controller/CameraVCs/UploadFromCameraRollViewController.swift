//
//  UploadFromCameraRollViewController.swift
//  InstaCaption
//
//  Created by Eric Yang on 4/25/19.
//  Copyright © 2019 Eric Yang. All rights reserved.
//

import UIKit

class UploadFromCameraRollViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate  {

    
    // MARK: - Variable Declaration
    var facesDetected : Int = 0
    var captions : [Caption?] = []
    var finalCaption : String = ""
    var location : Location!
    // Sent via segue from URL VC
    var urlString : String!
    var uploadedImg : UIImage!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateButton.layer.cornerRadius = 4
        generateButton.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let urlString = urlString {
            downloadImg(urlString: urlString)
        }
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var generateButton: UIButton!
    
    
    // MARK: - IBActions
    @IBAction func uploadImageDidPressed(_ sender: UIButton) {
        // Empty urlString
        urlString = ""
        let imgController = UIImagePickerController()
        imgController.delegate = self
        imgController.sourceType = .photoLibrary
        imgController.allowsEditing = false
        self.present(imgController, animated: true) {
            // Completion Handler
        }
        
        
    }
    
    
    @IBAction func urlButtonDidPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func generateButtonDidPressed(_ sender: UIButton) {
        if let img = imageView.image {
            detectFaces(img: img)
            captions = CaptionsModel.shared.returnCaptions(faces: facesDetected)
            location = CaptionsModel.shared.returnLocation()
        }
        if let caption = captions[0]?.text {
            finalCaption = caption
        }
    }
    
    
    
    // MARK: - Protocol Functions
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Check if can be converted to UIImage
        if let image = info[.originalImage] as? UIImage {
            uploadedImg = image
            imageView.image = uploadedImg
            generateButton.isHidden = false
        } else {
            // Error Message
            print("error")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
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
    
    // MARK: - Download URL Image
    func downloadImg(urlString: String) {
        var success : Bool = false
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
            if let url = URL(string: urlString) {
                do {
                    let data = try Data(contentsOf: url)
                    print("finished")
                    if let image = UIImage(data: data) {
                        self.uploadedImg = image
                        success = true
                    } else {
                        // Show alert
                        print("Couldn't convert to UIImage")
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Please re-enter your URL", message: "Error loading image", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                            self.present(alert, animated: true)
                        }
                        
                    }
                }
                catch {
                    // Data is nil
                    print("Data is nil")
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Please check your URL", message: "No data retrieved", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    }
                }
                
            }
            DispatchQueue.main.async {
                self.imageView.image = self.uploadedImg
                // Only show generate button if URL successfully downloaded as UIImage
                if success {
                    self.generateButton.isHidden = false
                }
                
            }
        })
        group.leave()
    }
    
    
    
    
    // MARK: - Navigation
    
    // Unwind Segue
    @IBAction func unwindToCameraRollVC(segue: UIStoryboardSegue) {}
   

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "generate" {
            if let imageWithCaptionVC = segue.destination as? ImageWithCaptionViewController {
                imageWithCaptionVC.img = imageView.image
                imageWithCaptionVC.caption = finalCaption
                imageWithCaptionVC.facesFound = facesDetected
                imageWithCaptionVC.location = location
            }
        }
    }
    

}
