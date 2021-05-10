//
//  PictureViewController.swift
//  GaleneApp
//
//  Created by user190841 on 5/6/21.
//

import UIKit
import CoreML
import Vision

class PictureViewController: UIViewController, UIImagePickerControllerDelegate,
                             UINavigationControllerDelegate {
    
    var imageToML : UIImage?
    @IBOutlet weak var tomarButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func selectCameraPhoto(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.sourceType = UIImagePickerController.SourceType.camera
        picker.delegate = self
        present(picker, animated: true)
    }
    
    
    @IBAction func selectAlbumPhoto(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        let modelFile: GaleneModel = {
        do {
            let config = MLModelConfiguration()
            return try GaleneModel(configuration: config)
        } catch {
            print(error)
            fatalError("Couldn't create modelML")
        }
        }()
        imageToML = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        let model = try! VNCoreMLModel(for: modelFile.model)
        let imagenCI = CIImage(image: imageToML!)
        let handler = VNImageRequestHandler(ciImage: imagenCI!)
        let request = VNCoreMLRequest(model: model, completionHandler: modelResult)
        try! handler.perform([request])
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func modelResult(request: VNRequest, error: Error?)
    {
        guard let results = request.results as? [VNClassificationObservation] else { fatalError("No hubo respuesta del modelo ML")}
        var bestPrediction = ""
        var bestConfidence: VNConfidence = 0
        //recorrer todas las respuestas en búsqueda del mejor resultado
        for classification in results{
            if (classification.confidence > bestConfidence){
                bestConfidence = classification.confidence
                bestPrediction = classification.identifier
            }
        }
        let resultStrML = "Hemos detectado: " + bestPrediction
        
        let nextView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PreInfoViewController") as! PreInfoViewController
        nextView.inputImage = imageToML
        nextView.inputAnswerML = resultStrML
        self.navigationController?.pushViewController(nextView, animated: true)
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
