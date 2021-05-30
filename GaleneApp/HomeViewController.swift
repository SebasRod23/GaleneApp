//
//  HomeViewController.swift
//  GaleneApp
//
//  Created by user191105 on 4/11/21.
//

import UIKit
import HealthKit
import FirebaseAuth
class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var snButton: UIButton!
    @IBOutlet weak var testbutton: UIButton!
    @IBOutlet weak var historialButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    private let picker = UIImagePickerController()

    override func viewDidLoad() {

        super.viewDidLoad()
        testbutton.layer.cornerRadius = 10
        snButton.layer.cornerRadius = 10
        historialButton.layer.cornerRadius = 10
        picker.delegate = self
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = true
        self.navigationController!.navigationBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .done, target: self, action: #selector(self.signOut))
        
        
        // Do any additional setup after loading the view.
    }
    @objc func signOut(){
        do{
            try Auth.auth().signOut();
            print("Saliste")
            performSegue(withIdentifier: "homeToLogin", sender: self)
        }catch let err{
            print(err)
            print("Error")
        }
    

    }
  
    @IBAction func changeProfileImage(_ sender: UIButton) {
        picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        profileImage.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
