//
//  RetoTerminadoViewController.swift
//  GaleneApp
//
//  Created by user186969 on 4/15/21.
//

import UIKit

class RetoTerminadoViewController: UIViewController {
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var retoLabel: UILabel!
    var retoTerminado: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        shareButton!.layer.cornerRadius = 10
        retoLabel.text=retoTerminado
        print(retoTerminado!)
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
