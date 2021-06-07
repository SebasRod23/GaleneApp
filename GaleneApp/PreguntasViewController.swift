//
//  PreguntasViewController.swift
//  GaleneApp
//
//  Created by user190842 on 5/9/21.
//

import UIKit
import FirebaseFirestore

class PreguntasViewController: UIViewController {
    private var score: Int = 0
    private var counter: Int = 0
    
    @IBOutlet weak var bttn0: UIButton!
    @IBOutlet weak var bttn1: UIButton!
    @IBOutlet weak var bttn2: UIButton!
    @IBOutlet weak var bttn3: UIButton!
    
    
    @IBOutlet weak var nextBttn: UIButton!
    
    @IBOutlet weak var lblNumber: UILabel!
    
    @IBOutlet weak var lblQuestion: UILabel!
    
    private var questions: String = ""
    var db: Firestore!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        // Do any additional setup after loading the view.
        bttn0.tag=0
        bttn1.tag=1
        bttn2.tag=2
        bttn3.tag=3
        
        
        bttn0.addTarget(self, action: #selector(nextQuestion), for: .touchUpInside)
        bttn1.addTarget(self, action: #selector(nextQuestion), for: .touchUpInside)
        bttn2.addTarget(self, action: #selector(nextQuestion), for: .touchUpInside)
        bttn3.addTarget(self, action: #selector(nextQuestion), for: .touchUpInside)
        
        nextBttn.isHidden = true
        
        
        // [START setup]
        let settings = FirestoreSettings()

        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
        getQuestion()
        lblNumber.text="Pregunta "+String(counter+1)
        
    }
    
    func getQuestion(){
        db.collection("preguntas").whereField("index", isEqualTo: String(counter)).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print(err)
            } else {
                for document in querySnapshot!.documents {
                    self.lblQuestion.text = (document.get("pregunta") as! String)
                }
            }
        }
    }
    
    func getDiagnosis()->String{
        var diagnosis = ""
        switch score {
        case 0...21:
            diagnosis = "Ansiedad leve"
        case 22...35:
            diagnosis = "Ansiedad moderada"
        default:
            diagnosis = "Ansiedad severa"
        }
        return diagnosis
    }
    
    func getRetos()->Int{
        var retos = 0
        switch score {
        case 0...21:
            retos = 1
        case 22...35:
            retos = 2
        default:
            retos = 3
        }
        return retos
    }
    
    @objc func nextQuestion(sender:UIButton!){
        let bttn: UIButton = sender
        
        if (counter>=20){
            nextBttn.isHidden = false
            print(score)
            bttn0.isHidden = true
            bttn1.isHidden = true
            bttn2.isHidden = true
            bttn3.isHidden = true
            lblQuestion.text="Has terminado el quiz!"
            lblNumber.text=""
        }
        else{
            counter+=1
            lblNumber.text="Pregunta "+String(counter+1)
            getQuestion()
            score+=bttn.tag
        }
        
        
        
        
    }
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "goToPhoto"{
            let sigVista = segue.destination as! PictureViewController
            sigVista.diagnosis = getDiagnosis()
            sigVista.nretos = getRetos()
        }
    }
    

}
