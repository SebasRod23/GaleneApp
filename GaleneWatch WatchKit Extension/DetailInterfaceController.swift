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
    @IBOutlet weak var categoryLabel: WKInterfaceLabel!
    @IBOutlet weak var detailLabel: WKInterfaceLabel!
    @IBOutlet weak var dateLabel: WKInterfaceLabel!
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        print("MY MENSAJEEEEEEEEEEEEE")
        print(context!)
        let data = context! as? [String : String]
        titleLabel.setText(data!["reto"]!)
        categoryLabel.setText(data!["type"])
        detailLabel.setText(data!["detail"])
        dateLabel.setText(data!["date"])
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
