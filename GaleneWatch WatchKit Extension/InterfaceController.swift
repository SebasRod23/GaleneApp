//
//  InterfaceController.swift
//  GaleneWatch WatchKit Extension
//
//  Created by user190842 on 5/21/21.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    @IBOutlet weak var tableView: WKInterfaceTable!
    var retos = ["jkflds","fsdjlkf;das","jkjdfkajal"]
    override func awake(withContext context: Any?) {
        // Configure interface objects here.
        super.awake(withContext: context)
        setupTable()
    }
    func setupTable() {
        tableView.setNumberOfRows(retos.count, withRowType: "TableClass")
        
        for i in 0...retos.count-1{
            if let row = tableView.rowController(at: i) as? TableClass{
                row.labelTable.setText(retos[i])
            }
        }
    }
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }

}
