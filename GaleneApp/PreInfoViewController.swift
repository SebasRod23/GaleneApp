//
//  PreInfoViewController.swift
//  GaleneApp
//
//  Created by user190841 on 5/7/21.
//

import UIKit

class PreInfoViewController: UIViewController {
    
    @IBOutlet weak var imageInpML: UIImageView!
    var inputImage: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        imageInpML.image = inputImage
        // Do any additional setup after loading the view.
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
