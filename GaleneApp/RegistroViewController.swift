//
//  RegistroViewController.swift
//  GaleneApp
//
//  Created by user186969 on 5/26/21.
//

import UIKit
import FirebaseAuth
class RegistroViewController: UIViewController {

    @IBOutlet weak var correoField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var confirmPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
  
    @IBAction func correoKeyboard(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    @IBAction func contrasenaKeyboard(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    @IBAction func confconKeyboard(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    func useSegue(){
        performSegue(withIdentifier: "registroToLogin", sender: self)
    }
    @IBAction func register(_ sender: Any) {
        let pass: String = passwordField.text!
        let passConf: String = confirmPassword.text!
        let correo: String = correoField.text!
        if(pass==passConf && !(pass=="")){
            print("try")

            Auth.auth().createUser(withEmail: correo, password: pass) { authResult, error in
    
                if(!(error == nil)){
                    self.errorLabel.text="No se pudo crear la cuenta"
                }else{
                    
                    self.errorLabel.text="Tu cuenta fue creada"
                    self.useSegue()
                }
                
            }
            print("se salvo")
        }else{
            errorLabel.text="No llenaste todos los campos"
        }
    }
    

}
