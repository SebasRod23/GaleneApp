//
//  DiagnosisViewController.swift
//  GaleneApp
//
//  Created by user190842 on 4/14/21.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth


class DiagnosisViewController: UIViewController {

    var tagResult: String?
    var diagnosis: String = ""
    var nretos: Int = 0
    var user : User?
    
    /** @var handle
          @brief The handler for the auth state listener, to allow cancelling later.
       */
    var handle: AuthStateDidChangeListenerHandle?
    var db: Firestore!
    
    struct MLData: Codable {
        var MLString: String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        // [START setup]
        let settings = FirestoreSettings()

        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                self.user = user
              }
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    @IBAction func backToHome(_ sender: UIButton) {
        self.writeToPList()
        _ = navigationController?.popToRootViewController(animated: true)
        // Query
        saveData()
        
    }
    
    struct Reto{
        var descripcion: String
        let cumplido: Bool = false
        let recordatorio: Bool = false
        
        func toAnyObject()->Any{
            return[
                "descripcion": descripcion,
                "cumplido": cumplido,
                "recordatorio": recordatorio
            ]
        }
        
    }
    
    
    func saveData(){
        var retos: [String] = []
        var img: String = ""
        // Get tags
        db.collection("retos").whereField("tags", arrayContains: tagResult!).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print(err)
            } else {
                for document in querySnapshot!.documents {
                    print(document.data())
                    retos.append(document.get("descripcion") as! String)
                    img = document.get("imagen") as! String
                }
                
                var retosSelected: [Reto] = []
                var randoms: [String] = []
                while self.nretos > 0 {
                    let reto = Reto(descripcion: retos.randomElement()!)
                    if (!randoms.contains(reto.descripcion)){
                        retosSelected.append(reto)
                        randoms.append(reto.descripcion)
                        self.nretos-=1
                    }
                }
                
                var retosAny: [Any] = []
                for reto in retosSelected {
                    retosAny.append(reto.toAnyObject())
                }
                
                let uid = self.user!.uid
                // Save it on Firebase
                self.db.collection("historial").document().setData([
                    "fecha": Date.init(),
                    "imagen":img,
                    "resultado":self.diagnosis,
                    "retos": retosAny,
                    "userID": uid
                ])
            }
        }
        
        
    }
    
    func writeToPList() {
        let mlData = MLData(MLString: self.tagResult!)
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml

        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("MLData.plist")
        do {
            let data = try encoder.encode(mlData)
            try data.write(to: path)
        } catch {
            print(error)
        }
    }
    
}
