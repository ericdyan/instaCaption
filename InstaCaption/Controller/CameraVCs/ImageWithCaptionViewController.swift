//
//  ImageWithCaptionViewController.swift
//  InstaCaption
//
//  Created by Eric Yang on 4/24/19.
//  Copyright © 2019 Eric Yang. All rights reserved.
//

import UIKit
import CoreData

class ImageWithCaptionViewController: UIViewController {

    @IBOutlet weak var uploadAgainButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var captionsLabel: UILabel!
    @IBOutlet weak var facesFoundLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    var img : UIImage?
    var caption: String = ""
    var facesFound : Int = -1
    var location : Location!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        uploadAgainButton.layer.cornerRadius = 4
        imageView.image = img
        captionsLabel.text = "Your caption: \"\(caption)\""
        facesFoundLabel.text = "Faces Found: \(facesFound)"
        if let name = location.name, let country = location.country, let state = location.state, let city = location.city {
            textView.text = "Name: \(name)\nCountry: \(country)\nState: \(state)\nCity: \(city)"
            // Save to CoreData
            createUser(location: city, faces: facesFound, caption: caption)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
    }
    
    @IBAction func unwindToCameraRollVC(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindToCameraRollVC", sender: self)
    }
    
    // MARK: - Core Data
    func createUser(location: String, faces : Int, caption : String) {
        // 1 Get reference to managedObjectContext from app delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // 2 Get reference from NSEntityDescription object's entityForName method
        let entity = NSEntityDescription.entity(forEntityName: "User", in: managedContext)
        
        // 3 Instanstiate NSManagerObject
        let user = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        // 4 Set Values
        user.setValue(location, forKey: "location")
        user.setValue(faces, forKey: "faces")
        user.setValue(caption, forKey: "caption")
        
        // 5 Call save method to add object to persistent storage
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save\(error), \(error.userInfo)")
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
