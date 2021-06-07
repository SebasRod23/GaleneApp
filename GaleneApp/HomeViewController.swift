//
//  HomeViewController.swift
//  GaleneApp
//
//  Created by user191105 on 4/11/21.
//

import UIKit
import HealthKit
import FirebaseStorage
import Firebase
import FirebaseAuth

class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var snButton: UIButton!
    @IBOutlet weak var testbutton: UIButton!
    @IBOutlet weak var historialButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    private let picker = UIImagePickerController()
    private let storage = Storage.storage()
    private var handle: AuthStateDidChangeListenerHandle?
    private var useruid : String?
    // Get a reference to the storage service using the default Firebase App
    

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
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func logOutButton(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            performSegue(withIdentifier: "HomeToLogin", sender: self)
        }catch let err{
            print(err)
        }

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                self.useruid = user.uid
                self.downloadProfileImage()
              }
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    func downloadProfileImage() {
        let pathReference = storage.reference(withPath: "images/" + useruid! + "/profile.jpg")
        // Download in memory with a maximum allowed size of 2MB (1 * 1024 * 1024 bytes)
        pathReference.getData(maxSize: 2 * 1024 * 1024) { data, error in
          if let error = error {
            print(error)
          } else {
            let image = UIImage(data: data!)
            self.profileImage.image = image
          }
        }
    }
    
    func uploadProfileImage(image : UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            return
        }
        let storageRef = storage.reference()
        let profileImageRef = storageRef.child("images/" + useruid! + "/profile.jpg")
        let uploadTask = profileImageRef.putData(imageData, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                // Error
                print(error)
                return
            }
            
            }
    }
    
    @IBAction func changeProfileImage(_ sender: UIButton) {
        picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imageInp =  info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        profileImage.image = imageInp
        uploadProfileImage(image: imageInp!)
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
