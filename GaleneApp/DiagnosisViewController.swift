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
        db.collection("retos").whereField("tags", arrayContains: tagResult).getDocuments() { (querySnapshot, err) in
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
                
                let user = Auth.auth().currentUser
                // [END get_user_profile]
                // [START user_profile]
                if let user = user {
                    let uid = user.uid
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
        /*
        // Randomly select challenges
        var retosSelected: [Reto] = []
        var randoms: [String] = []
        while nretos > 0 {
            let reto = Reto(descripcion: retos.randomElement()!)
            if (!randoms.contains(reto.descripcion)){
                retosSelected.append(reto)
                randoms.append(reto.descripcion)
                nretos-=1
            }
        }
        
        
        // Save it on Firebase
        db.collection("historial").document().setData([
            "fecha": Date.init(),
            "imagen":img,
            "resultado":diagnosis,
            "retos": retosSelected
        ])*/
        
        
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
