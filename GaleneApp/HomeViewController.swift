//
//  HomeViewController.swift
//  GaleneApp
//
//  Created by user191105 on 4/11/21.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var snButton: UIButton!
    @IBOutlet weak var testbutton: UIButton!
    @IBOutlet weak var historialButton: UIButton!
    override func viewDidLoad() {

        super.viewDidLoad()
        testbutton.layer.cornerRadius = 10
        snButton.layer.cornerRadius = 10
        historialButton.layer.cornerRadius = 10
        print("Hello")
        
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
