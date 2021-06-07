//
//  HomeViewController.swift
//  GaleneApp
//
//  Created by user191105 on 4/11/21.
//

import UIKit
import HealthKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth
import WatchConnectivity

class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    

    @IBOutlet weak var snButton: UIButton!
    @IBOutlet weak var testbutton: UIButton!
    @IBOutlet weak var historialButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    private let picker = UIImagePickerController()
    private let storage = Storage.storage()
    private var handle: AuthStateDidChangeListenerHandle?
    private var useruid : String?
    var db : Firestore!
    var user : User?
    var historialData: Historial = Historial()
    var miSession : WCSession! = nil
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
        let settings = FirestoreSettings()
        if WCSession.isSupported() {//4.1
             miSession = WCSession.default//4.2
             miSession.delegate = self//4.3
             miSession.activate()//4.4
            
        }
        
        
        Firestore.firestore().settings = settings
        // [END setup]
        self.db = Firestore.firestore()
        
        // Do any additional setup after loading the view.
    }
    struct Reto {
        var cumplido: Bool
        var descripcion: String
        var recordatorio: Bool
        
        func toAnyObject()->Any{
            return[
                "cumplido": cumplido,
                "descripcion": descripcion,
                "recordatorio": recordatorio
            ]
        }
        
    }
    struct Historial {
        var fecha: Date = Date()
        var imagen: String = ""
        var resultado: String = ""
        var retos: [[String: Any]] = []
        
        func toAnyObject()->Any{
            return[
                "fecha": fecha,
                "imagen": imagen,
                "resultado": resultado,
                "retos": retos,
            ]
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                self.user = user
                self.fetchHistorial()
              }
        }
        
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
    func fetchHistorial(){
        
        db.collection("historial").whereField("userID", isEqualTo: useruid).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print(err)
            } else {
                var historial : [Historial] = []
                for document in querySnapshot!.documents {
                    historial.append(Historial(fecha: (document.get("fecha") as! Timestamp).dateValue(), imagen: document.get("imagen") as! String, resultado: document.get("resultado") as! String, retos: document.get("retos") as! [[String: Any ]]))
                }
                if !historial.isEmpty {
                    let mostRecentHistorial = historial.reduce(historial[0], { $0.fecha.timeIntervalSince1970 > $1.fecha.timeIntervalSince1970 ? $0 : $1 } )
                    /*if(self.historialData.imagen == "tenis" || self.historialData.imagen == "balon") {
                        self.getPasos()
                    }*/
                    let mensaje = ["contenido" : mostRecentHistorial.retos, "fecha": mostRecentHistorial.fecha] as [String : Any]
                    print(mostRecentHistorial)
                    if self.miSession.isReachable{
                        self.miSession.sendMessage(mensaje, replyHandler: nil, errorHandler: self.messageError(err: ))
                    }else{
                        print("AYNO")
                    }
                    
                }
            }
        }
        
    }
    // MARK: - Navigation
    func messageError(err : Error)->Void{
        print("error")
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}
extension HomeViewController:  WCSessionDelegate{
    func sessionDidBecomeInactive(_ session: WCSession) {
        // To support multiple watches.
        print("WC Session did become inactive.")
    }

    func sessionDidDeactivate(_ session: WCSession) {
        // To support multiple watches.
        WCSession.default.activate()
        print("WC Session did deactivate.")
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WC Session activation failed with error: \(error.localizedDescription)")
            return
        }
        print("Phone activated with state: \(activationState.rawValue)")
    }
    func sessionReachabilityDidChange(_ session: WCSession){
        print("cambie")
    }
}
