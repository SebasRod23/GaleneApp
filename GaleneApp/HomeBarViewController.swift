//
//  HomeBarViewController.swift
//  GaleneApp
//
//  Created by user186969 on 5/28/21.
//

import UIKit
import FirebaseAuth
class HomeBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .done, target: self, action: #selector(self.signOut))
        
        
        // Do any additional setup after loading the view.
    }
    @objc func signOut(){
        do{
            try Auth.auth().signOut();
            print("Saliste")
            performSegue(withIdentifier: "homeToLogin", sender: self)
        }catch let err{
            print(err)
            print("Error")
        }
    

    }
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
