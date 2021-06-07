//
//  ForgotPassViewController.swift
//  GaleneApp
//
//  Created by user186969 on 5/30/21.
//

import UIKit
import FirebaseAuth
class ForgotPassViewController: UIViewController {

    @IBOutlet weak var fieldCorreo: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func correoKeyboard(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func recuperarContrasena(_ sender: Any) {
        let email = fieldCorreo.text!
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            guard error == nil else{
                self.errorLabel.text = "No se pudo mandar el correo"
                return
            }
            self.errorLabel.textColor = UIColor.green
            self.errorLabel.text = "El correo fue mandado"
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
