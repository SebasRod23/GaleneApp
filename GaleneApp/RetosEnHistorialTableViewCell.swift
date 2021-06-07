//
//  RetosEnHistorialTableViewCell.swift
//  GaleneApp
//
//  Created by user191105 on 6/6/21.
//

import UIKit

class RetosEnHistorialTableViewCell: UITableViewCell {

    static let identifier = "reto"
    
    static func nib() -> UINib{
        return UINib(nibName: "reto", bundle: nil)
    }
    
    
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var cumplido: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = #colorLiteral(red: 0.6588235294, green: 0.8392156863, blue: 0.7843137255, alpha: 0.5)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
