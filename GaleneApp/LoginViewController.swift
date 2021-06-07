//
//  LoginViewController.swift
//  GaleneApp
//
//  Created by user186969 on 5/26/21.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var correoField: UITextField!
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Auth.auth().currentUser != nil {
                performSegue(withIdentifier: "LoginToHome", sender: self)
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func passwordKeyboard(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    @IBAction func correoKeyboard(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    @IBAction func login(_ sender: Any) {
        setLogin()
    }
    
    func setLogin() {
        let email = correoField.text ?? ""
        let password = passwordField.text ?? ""
        if(!(password=="") && !(email=="")){
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                guard error == nil else {
                    self?.errorLabel.text="Usuario o contrasena incorrecto"
                    print("No sirvio")
                    return
                }
                self?.performSegue(withIdentifier: "LoginToHome", sender: self)
                print("Si sirvio")
            }
        }
    }
    



}
