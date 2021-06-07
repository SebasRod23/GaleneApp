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
    var retos = ["reto1","reto2","reto3"]
    var fecha1 = ["12/04/21","12/07/20","21/03/21"]
    var type = ["sports","art","music"]
    var detail = ["NA","NA","5"]
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
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        let everything = ["reto" : retos[rowIndex], "date" : fecha1[rowIndex], "type" : type[rowIndex], "detail" : detail[rowIndex]]
        pushController(withName: "showDetails", context: everything)
    }
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }

}
