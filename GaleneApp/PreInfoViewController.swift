//
//  PreInfoViewController.swift
//  GaleneApp
//
//  Created by user190841 on 5/7/21.
//

import UIKit

class PreInfoViewController: UIViewController {
    
    @IBOutlet weak var imageInpML: UIImageView!
    @IBOutlet weak var answerML: UILabel!
    var inputImage: UIImage?
    var inputAnswerML: String?
    var diagnosis: String = ""
    var nretos: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageInpML.image = self.inputImage
        self.answerML.text = "Hemos detectado: " + self.inputAnswerML!
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toDiagnosisViewController") {
            let diagnosisView = (segue.destination as! DiagnosisViewController)
            diagnosisView.tagResult = self.inputAnswerML!
            diagnosisView.diagnosis = self.diagnosis
            diagnosisView.nretos = self.nretos
        }
    }
    
}
