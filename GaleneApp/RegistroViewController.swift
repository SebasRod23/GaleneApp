//
//  RegistroViewController.swift
//  GaleneApp
//
//  Created by user186969 on 5/26/21.
//

import UIKit
import FirebaseAuth
class RegistroViewController: UIViewController {

    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var correoField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
  
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // Get the new view controller using segue.destination.
            // Pass the selected object to the new view controller.
        let correo: String = correoField.text!
        let password: String = passwordField.text!
        let confPassword: String = confirmPassword.text!
            if (segue.identifier == "registroToLogin" && password==confPassword && !(password=="")){
                let sigVista = segue.destination as! LoginViewController
                Auth.auth().createUser(withEmail:correo, password: password) { authResult, error in
                  // ...
                }
            }else{
                errorLabel.text = "Verifica tus inputs"
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
