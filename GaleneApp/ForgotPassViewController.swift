//
//  ForgotPassViewController.swift
//  GaleneApp
//
//  Created by user186969 on 5/27/21.
//

import UIKit
import Firebase
class ForgotPassViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func emailKeyboard(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    @IBOutlet weak var errorLabel: UILabel!
    @IBAction func recuperarContrasena(_ sender: Any) {
        let correo = emailField.text!
        Auth.auth().sendPasswordReset(withEmail: correo) { error in
            guard error == nil else{
                self.errorLabel.text = "No existe ese correo"
                print("no existe")
                return
            }
            self.errorLabel.textColor = UIColor.green
            self.errorLabel.text = "Correo mandado"
            print("existe")
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
