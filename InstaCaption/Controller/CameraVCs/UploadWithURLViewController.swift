//
//  UploadWithURLViewController.swift
//  InstaCaption
//
//  Created by Eric Yang on 4/25/19.
//  Copyright © 2019 Eric Yang. All rights reserved.
//

import UIKit

class UploadWithURLViewController: UIViewController {
    
    // MARK: - Variables
    var textFieldText : String = ""
    @IBOutlet weak var urlTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelDidPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func doneDidPressed(_ sender: UIButton) {
        if let text = urlTextField.text {
            textFieldText = text
            performSegue(withIdentifier: "toCameraRollSegue", sender: self)
        } else {
            // Handle error (empty textfield)
        }
    }
    
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCameraRollSegue" {
            if let cameraRollVC = segue.destination as? UploadFromCameraRollViewController {
                cameraRollVC.urlString = textFieldText
            }
        }
    }

}
