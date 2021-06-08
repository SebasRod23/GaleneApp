//
//  InterfaceController.swift
//  GaleneWatch WatchKit Extension
//
//  Created by user190842 on 5/21/21.
//

import WatchKit
import Foundation
import WatchConnectivity



class InterfaceController: WKInterfaceController, WCSessionDelegate  {
    
    struct Data {
        var cumplido: Bool
        var descripcion: String
        var fecha: String
        
    }
    
    var wcSession : WCSession!
    
    @IBOutlet weak var tableView: WKInterfaceTable!
    var retos: [Data] = []
    override func awake(withContext context: Any?) {
        // Configure interface objects here.
        super.awake(withContext: context)
        retos.append(Data(cumplido: false, descripcion: "Pintar mandala", fecha: "07-06-2021"))
        retos.append(Data(cumplido: true, descripcion: "Haz mucho mucho mucho mucho mucho ejercicio", fecha: "07-06-2021"))
        retos.append(Data(cumplido: false, descripcion: "Escucha musica", fecha: "07-06-2021"))
        
        
        setupTable()
    }
    func setupTable() {
        tableView.setNumberOfRows(retos.count, withRowType: "TableClass")
        
        
        for i in 0...retos.count-1{
            if let row = tableView.rowController(at: i) as? TableClass{
                row.labelTable.setText("Reto #"+String(i+1))
            }
        }
    }
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        let everything = ["titulo":"Reto #"+String(rowIndex+1),"reto" : retos[rowIndex].descripcion, "fecha" : retos[rowIndex].fecha, "cumplido" : retos[rowIndex].cumplido] as [String : Any]
        pushController(withName: "showDetails", context: everything)
    }
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()

        wcSession = WCSession.default
        wcSession.delegate = self
        wcSession.activate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
            
            let text = message["message"] as! String
            
            print(text)
            
        }
        
        func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
            
            // Code.
            
        }

}
