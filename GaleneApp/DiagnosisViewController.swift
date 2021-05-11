//
//  DiagnosisViewController.swift
//  GaleneApp
//
//  Created by user190842 on 4/14/21.
//

import UIKit

class DiagnosisViewController: UIViewController {

    var tagResult : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        print(tagResult!)
        
    }
    
    @IBAction func backToHome(_ sender: UIButton) {
        let homeView = navigationController?.viewControllers.first as! HomeViewController
        homeView.tempTagRetos = tagResult
        _ = navigationController?.popToRootViewController(animated: true)
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
