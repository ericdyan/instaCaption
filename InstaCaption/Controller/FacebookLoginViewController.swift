//
//  FacebookLoginViewController.swift
//  InstaCaption
//
//  Created by Eric Yang on 4/24/19.
//  Copyright © 2019 Eric Yang. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore

class FacebookLoginViewController: UIViewController, LoginButtonDelegate {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let loginButton = LoginButton(readPermissions: [.publicProfile, .email])
        loginButton.delegate = self
        loginButton.center = view.center
        view.addSubview(loginButton)
        
        // Do any additional setup after loading the view.
    }
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        performSegue(withIdentifier: "loggedInSegue", sender: nil)
    }
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        print("LOGGED OUT")
    }
    
    @IBAction func testButton(_ sender: UIButton) {
        performSegue(withIdentifier: "loggedInSegue", sender: nil)
    }
    

    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

}
