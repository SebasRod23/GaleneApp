//
//  RegistroViewController.swift
//  GaleneApp
//
//  Created by user186969 on 5/26/21.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import Firebase
class RegistroViewController: UIViewController {

    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var correoField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    private let storage = Storage.storage()
    private var imageDefault : UIImage!
    private var useruid : String!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
  
    @IBAction func contrasenaKeyboard(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func confcontKeyboard(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    @IBAction func emailKeyboard(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // Get the new view controller using segue.destination.
            // Pass the selected object to the new view controller.
        let email: String = correoField.text!
        let password: String = passwordField.text!
        let confPassword: String = confirmPassword.text!
            if (segue.identifier == "registroToLogin" && password==confPassword && !(password=="")){
                Auth.auth().createUser(withEmail:email, password: password) { authResult, error in
                    if let user = authResult?.user {
                        self.useruid = user.uid
                    self.downloadDefaultImage()
                    }
                }
                let sigVista = segue.destination as! LoginViewController
                
            }else{
                errorLabel.text = "Verifica tus inputs"
            }
        }
    
    func downloadDefaultImage() {
        let pathReference = storage.reference(withPath: "images/default.jpg")
        pathReference.getData(maxSize: 2 * 1024 * 1024) { data, error in
          if let error = error {
            print(error)
          } else {
            self.imageDefault = UIImage(data: data!)!
            self.uploadProfileImage(image: self.imageDefault, useruid: self.useruid)
        }
    }
    }
    
    func uploadProfileImage(image : UIImage, useruid : String) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            return
        }
        let storageRef = storage.reference()
        let profileImageRef = storageRef.child("images/" + useruid + "/profile.jpg")
        let uploadTask = profileImageRef.putData(imageData, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                // Error
                print(error)
                return
            }
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
