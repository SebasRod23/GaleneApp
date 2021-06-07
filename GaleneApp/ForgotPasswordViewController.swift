//
//  ForgotPasswordViewController.swift
//  GaleneApp
//
//  Created by user186969 on 5/29/21.
//

import UIKit
import FirebaseAuth

class ForgotPasswordViewController: UITabBarController {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var correoField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func emailKeyboard(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func recuperarContrasena(_ sender: Any) {
        let email = correoField.text ?? ""
        /*Auth.auth().sendPasswordReset(withEmail: email) { error in
            self.errorLabel.text = "Tus datos no se encuentran disponible"
        }*/
    }
    


}
