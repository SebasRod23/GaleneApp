//
//  InterfaceController.swift
//  GaleneWatch WatchKit Extension
//
//  Created by user190842 on 5/21/21.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    var retos :  [Reto] = []
    @IBOutlet weak var bugLabel: WKInterfaceLabel!
    var fecha1 = ""
    struct Reto {
        var cumplido: Bool
        var descripcion: String
        var recordatorio: Bool
        
        func toAnyObject()->Any{
            return[
                "cumplido": cumplido,
                "descripcion": descripcion,
                "recordatorio": recordatorio
            ]
        }
        
    }
    struct Mensaje{
        var contenido: [Reto]
        var fecha1: String
        
        func toAnyObject()->Any{
            return[
                "cumplido": contenido,
                "fecha1": fecha1
            ]
        }
        
    }
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("Activation failed with error: \(error.localizedDescription)")
            return
        }
        print("Watch activated with state: \(activationState.rawValue)")
    }
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        print("my MENSAJEEEEE")
        print(message["contenido"])
        retos = message["contenido"] as! [Reto]
        fecha1 = message["fecha"] as! String
        
    }


    
    @IBOutlet weak var tableView: WKInterfaceTable!
    
    
    var miSession : WCSession! = nil
    override func awake(withContext context: Any?) {
        // Configure interface objects here.
        super.awake(withContext: context)
        setupTable()
    }

    func setupTable() {
        
        tableView.setNumberOfRows(retos.count, withRowType: "TableClass")
        if(retos.count>0){
            for i in 0...retos.count-1{
                if let row = tableView.rowController(at: i) as? TableClass{
                    row.labelTable.setText(retos[i].descripcion as String)
                }
            }
        }
        
    }
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        let everything = ["reto" : retos[rowIndex].descripcion, "date" : fecha1, "type" : retos[rowIndex].cumplido, "detail" : retos[rowIndex].recordatorio] as [String : Any]
        pushController(withName: "showDetails", context: everything)
    }
    override func willActivate() {
        miSession = WCSession.default//4.2
        miSession.delegate = self//4.3
        miSession.activate()//4.4
        sleep(10)
        if miSession.isReachable{
            bugLabel.setText("SE CONECTO")
        }else{
            bugLabel.setText("NO SE CONECTO")
        }
        // This method is called when watch view controller is about to be visible to user
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }

}
