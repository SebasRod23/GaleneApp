//
//  HistorialTableViewController.swift
//  GaleneApp
//
//  Created by user190842 on 4/14/21.
//

import UIKit

class RetosTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconLabel: UIImageView!
    @IBOutlet weak var retoLabel: UILabel!
    @IBOutlet weak var completadoButton: UIButton!
    @IBAction func completadoFunc(_ sender: Any) {
    }

    
}

class RetosTableViewController: UITableViewController {
    
    struct MLData: Codable {
        var MLString:String
    }
    
    let direccion="http://martinmolina.com.mx/202111/equipo3/data/retos.json"
    var currTag : String?
    var nuevoArray:[Any]?
    
        override func viewDidLoad() {
            super.viewDidLoad()
            
            tableView.delegate = self
            
            if let url = URL(string: direccion) {
                //print(url)
                let datosCrudos = try? Data(contentsOf: url)
                nuevoArray = try! JSONSerialization.jsonObject(with: datosCrudos!) as? [Any]
                let firstElem = nuevoArray![0] as! [String: Any]
                let s1:String = String(firstElem["descripcion"] as! String)
                print(s1)
                let filtered = nuevoArray!.filter {
                    let elem = ($0 as! [String: Any])
                    //let str:String = elem["id"] as! String
                    return true
                }
                //print(filtered)
            } else {
                // the URL was bad!
                print("the URL was bad!")
            }
        }
    
    override func viewDidAppear(_ animated: Bool) {
        //guard
        if let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString?,
        let sourcePath = documentsPath.appendingPathComponent("MLData.plist") as NSString?,
        let dictionary = NSDictionary(contentsOfFile: sourcePath as String) {
            //print("dict: \(dictionary)")
            self.currTag = dictionary["MLString"] as? String
            //print(self.currTag!)
        }
        else {
            self.currTag = "NA"
            //print(self.currTag!)
        }
        
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 162
    }
 
    // MARK: - Table view data source

        override func numberOfSections(in tableView: UITableView) -> Int {
            // #warning Incomplete implementation, return the number of sections
            return 1
        }

        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // #warning Incomplete implementation, return the number of rows
            return nuevoArray!.count
        }

        

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            var cell = tableView.dequeueReusableCell(withIdentifier: "reto", for: indexPath)as! RetosTableViewCell
                
            // Configure the cell...
            if (object_getClass(cell)?.description()  == "NSNull") {
                cell = UITableViewCell( style: UITableViewCell.CellStyle.default, reuseIdentifier: "reto") as! RetosTableViewCell
                
            }
            let objeto = nuevoArray![indexPath.row] as! [String: Any]
            //print(objeto)
            let s1:String = String(objeto["descripcion"] as! String)
          

        //let s2:String = objeto["resultados.fecha"] as! String
            cell.retoLabel?.text=s1//ACTUALIZAR JSON
        cell.completadoButton.tag = indexPath.row
        cell.completadoButton.addTarget(self, action: #selector(goToCongrats(sender:)), for: .touchUpInside)
        
            return cell
        }
    @objc
    func goToCongrats(sender: UIButton){
        let rowIndex: Int = sender.tag
        //print(rowIndex)
        //let sigVista = RetoTerminadoViewController()
        let sigVista = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RetoTerminadoViewController") as! RetoTerminadoViewController
        let objeto = nuevoArray![rowIndex] as! [String: Any]
        let s:String = objeto["descripcion"] as! String
        sigVista.retoTerminado = s
        self.navigationController?.pushViewController(sigVista, animated: true)
    }
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // Get the new view controller using segue.destination.
            // Pass the selected object to the new view controller.
            let sigVista = segue.destination as! RetoTerminadoViewController
            let indice = self.tableView.indexPathForSelectedRow?.row
            let objeto = nuevoArray![indice!] as! [String: Any]
            let s:String = objeto["reto"] as! String

            sigVista.retoTerminado = s
        }*/

        /*
        // Override to support conditional editing of the table view.
        override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            // Return false if you do not want the specified item to be editable.
            return true
        }
        */

        /*
        // Override to support editing the table view.
        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                // Delete the row from the data source
                tableView.deleteRows(at: [indexPath], with: .fade)
            } else if editingStyle == .insert {
                // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            }
        }
        */

        /*
        // Override to support rearranging the table view.
        override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

        }
        */

        /*
        // Override to support conditional rearranging of the table view.
        override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
            // Return false if you do not want the item to be re-orderable.
            return true
        }
        */
  
        
        // MARK: - Navigation

        // In a storyboard-based application, you will often want to do a little preparation before navigation
        /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // Get the new view controller using segue.destination.
            // Pass the selected object to the new view controller.
            /*let sigVista = segue.destination as! ViewController
            let indice = self.tableView.indexPathForSelectedRow?.row
            let objeto = nuevoArray![indice!] as! [String: Any]
            let s:String = objeto["palabra"] as! String*/
            let indice = self.tableView.indexPathForSelectedRow?.row
            let objeto = nuevoArray![indice!] as! [String:Any]
        }*/

}
