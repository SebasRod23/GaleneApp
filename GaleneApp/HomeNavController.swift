//
//  HomeNavController.swift
//  GaleneApp
//
//  Created by user191105 on 4/11/21.
//

import UIKit

class HomeNavController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        
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
