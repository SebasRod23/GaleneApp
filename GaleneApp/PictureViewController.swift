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
    
    var imageToML: UIImage?
    var diagnosis: String = ""
    var nretos: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        let imageInp = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.loadModel(image: imageInp!)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func loadModel(image : UIImage) {
        let modelFile: GaleneModel = {
        do {
            let config = MLModelConfiguration()
            return try GaleneModel(configuration: config)
        } catch {
            print(error)
            fatalError("Couldn't create modelML")
        }
        }()
        self.imageToML = image
        let model = try! VNCoreMLModel(for: modelFile.model)
        let imagenCI = CIImage(image: self.imageToML!)
        let handler = VNImageRequestHandler(ciImage: imagenCI!)
        let request = VNCoreMLRequest(model: model, completionHandler: modelResult)
        try! handler.perform([request])
    }
    
    func modelResult(request: VNRequest, error: Error?) {
        guard let results = request.results as? [VNClassificationObservation] else { fatalError("No hubo respuesta del modelo ML")}
        var bestPrediction = ""
        var bestConfidence: VNConfidence = 0
        for classification in results{
            if (classification.confidence > bestConfidence){
                bestConfidence = classification.confidence
                bestPrediction = classification.identifier
            }
        }
        
        let nextView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PreInfoViewController") as! PreInfoViewController
        nextView.inputImage = self.imageToML
        nextView.inputAnswerML = bestPrediction
        nextView.diagnosis = self.diagnosis
        nextView.nretos = self.nretos
        self.navigationController?.pushViewController(nextView, animated: true)
    }
    
}
