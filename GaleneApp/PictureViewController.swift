//
//  PictureViewController.swift
//  GaleneApp
//
//  Created by user190841 on 5/6/21.
//

import UIKit
import CoreML
import Vision

class PictureViewController: UIViewController {
    
    var resultStrML : String?
    var imageToML : UIImage?
    @IBOutlet weak var presentImage: UIImageView!
    @IBOutlet weak var aceptarButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func didTapButton(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @IBAction func skipToPreInfo(_ sender: UIButton) {
        let nextView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PreInfoViewController") as! PreInfoViewController
        self.navigationController?.pushViewController(nextView, animated: true)
        
    }
    
    
    @IBAction func selectAlbumPhoto(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        presentImage.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        picker.dismiss(animated: true, completion: nil)
        //instanciar el modelo de la red neuronal
        //let modelFile = GaleneModel()
        let modelFile: GaleneModel = {
        do {
            let config = MLModelConfiguration()
            return try GaleneModel(configuration: config)
        } catch {
            print(error)
            fatalError("Couldn't create SleepCalculator")
        }
        }()
        imageToML = presentImage.image
        let model = try! VNCoreMLModel(for: modelFile.model)
        //Convertir la imagen obtenida a CIImage
        let imagenCI = CIImage(image: presentImage.image!)
        //Crear un controlador para el manejo de la imagen, este es un requerimiento para ejecutar la solicitud del modelo
        let handler = VNImageRequestHandler(ciImage: imagenCI!)
        //Crear una solicitud al modelo para el análisis de la imagen
        let request = VNCoreMLRequest(model: model, completionHandler: resultadosModelo)
        try! handler.perform([request])
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    

}

extension PictureViewController : UIImagePickerControllerDelegate,
                                  UINavigationControllerDelegate {
    /*
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        
        //instanciar el modelo de la red neuronal
        //let modelFile = GaleneModel()
        let modelFile: GaleneModel = {
        do {
            let config = MLModelConfiguration()
            return try GaleneModel(configuration: config)
        } catch {
            print(error)
            fatalError("Couldn't create SleepCalculator")
        }
        }()
        imageToML = image
        let model = try! VNCoreMLModel(for: modelFile.model)
        //Convertir la imagen obtenida a CIImage
        let imagenCI = CIImage(image: image)
        //Crear un controlador para el manejo de la imagen, este es un requerimiento para ejecutar la solicitud del modelo
        let handler = VNImageRequestHandler(ciImage: imagenCI!)
        //Crear una solicitud al modelo para el análisis de la imagen
        let request = VNCoreMLRequest(model: model, completionHandler: resultadosModelo)
        try! handler.perform([request])
        picker.dismiss(animated: true, completion: nil)
    }
 */
    
    func resultadosModelo(request: VNRequest, error: Error?)
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
        let resultado = bestPrediction+" "+String(bestConfidence)
        print(resultado)
        resultStrML = resultado
        
        let nextView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PreInfoViewController") as! PreInfoViewController
        nextView.inputImage = imageToML
        nextView.inputAnswerML = resultStrML
        self.navigationController?.pushViewController(nextView, animated: true)
    }
}
