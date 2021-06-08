//
//  DetailInterfaceController.swift
//  GaleneWatch WatchKit Extension
//
//  Created by user186969 on 6/6/21.
//

import WatchKit
import Foundation


class DetailInterfaceController: WKInterfaceController {
    
    @IBOutlet weak var titleLabel: WKInterfaceLabel!
    @IBOutlet weak var detailLabel: WKInterfaceLabel!
    
    
    @IBOutlet weak var retoLabel: WKInterfaceLabel!
    
    @IBOutlet weak var dateLabel: WKInterfaceLabel!
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        print(context!)
        let data = context! as? [String : Any]
        titleLabel.setText((data!["titulo"]! as! String))
        retoLabel.setText((data!["reto"]! as! String))
        if (data!["cumplido"] as? Bool)!{
            detailLabel.setText("Reto cumplido")
        }
        else{
            detailLabel.setText("Reto pendiente")
        }
        dateLabel.setText((data!["fecha"] as! String))
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
