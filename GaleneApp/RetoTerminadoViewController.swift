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
        self.shareButton!.layer.cornerRadius = 10
        self.retoLabel.text = self.retoInp
    }

}
