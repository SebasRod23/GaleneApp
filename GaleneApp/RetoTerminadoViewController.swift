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
    var retoInp: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.shareButton!.layer.cornerRadius = 10
        self.retoLabel.text = self.retoInp
    }

    @IBAction func compartirReto(_ sender: UIButton) {
        let imgTo = UIImage(named: "logo")
        let strTo = "Has completado el reto \(String(describing: retoInp))"
        
        let ShareSheet = UIActivityViewController(
            activityItems: [imgTo!, strTo], applicationActivities: nil
        )
        
        present(ShareSheet, animated: true)
    }
    
    
}
