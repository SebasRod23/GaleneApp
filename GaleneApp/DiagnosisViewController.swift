//
//  DiagnosisViewController.swift
//  GaleneApp
//
//  Created by user190842 on 4/14/21.
//

import UIKit

class DiagnosisViewController: UIViewController {

    var tagResult: String?
    
    struct MLData: Codable {
        var MLString: String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    @IBAction func backToHome(_ sender: UIButton) {
        self.writeToPList()
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    func writeToPList() {
        let mlData = MLData(MLString: self.tagResult!)
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml

        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("MLData.plist")
        do {
            let data = try encoder.encode(mlData)
            try data.write(to: path)
        } catch {
            print(error)
        }
    }
    
}
