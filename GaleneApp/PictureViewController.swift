//
//  PictureViewController.swift
//  GaleneApp
//
//  Created by user190841 on 5/6/21.
//

import UIKit

class PictureViewController: UIViewController {

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
    /*
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
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        //imageView.image = image
        let nextView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PreInfoViewController") as! PreInfoViewController
        nextView.inputImage = image
        self.navigationController?.pushViewController(nextView, animated: true)
        picker.dismiss(animated: true, completion: nil)
        
    }
    
}
