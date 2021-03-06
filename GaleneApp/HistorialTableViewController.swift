//
//  HistorialTableViewController.swift
//  GaleneApp
//
//  Created by user190842 on 4/14/21.
//

import UIKit
import Firebase
import FirebaseAuth

class HistorialTableViewCell: UITableViewCell {
    
 
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
}
class HistorialTableViewController: UITableViewController, UISearchResultsUpdating {
    
    var user: User?
    var handle: AuthStateDidChangeListenerHandle?
    var db: Firestore!
    
    struct Historial {
        var fecha: Date
        let imagen: String
        let resultado: String
        var retos: [[String: Any]]
        
        func toAnyObject()->Any{
            return[
                "fecha":fecha,
                "imagen":imagen,
                "resultado": resultado,
                "retos":retos,
            ]
        }
    }
    
        var histData = [Historial]()
        var nuevoArray:[Any]?
        var datosFiltrados = [Historial]()
        let searchController = UISearchController(searchResultsController: nil)
    func updateSearchResults(for searchController: UISearchController) {
        if(searchController.searchBar.text!==""){
            datosFiltrados=histData
        }else{
            datosFiltrados = histData.filter{
                let objeto = $0.resultado
                let s2:String = String(objeto)
                print(s2.lowercased().contains(searchController.searchBar.text!.lowercased()))
                return s2.lowercased().contains(searchController.searchBar.text!.lowercased())
            }
        }
        self.tableView.reloadData()
    }
    
    
        override func viewDidLoad() {
            super.viewDidLoad()

            tableView.delegate = self
            self.navigationController!.navigationBar.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            let settings = FirestoreSettings()
            Firestore.firestore().settings = settings
            self.db = Firestore.firestore()
            self.getHistorial()
            datosFiltrados = histData
            self.tableView.reloadData()
            
            

            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 600
        }
    
    override func viewDidAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if let user = user{
                self.user = user
            }
        })
        searchController.searchResultsUpdater=self
        searchController.obscuresBackgroundDuringPresentation=false
        searchController.hidesNavigationBarDuringPresentation=false
        tableView.tableHeaderView=searchController.searchBar
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    func getHistorial(){
        //let uid : String = self.user!.uid
        //.whereField("userID", isEqualTo: uid)
        db.collection("historial").getDocuments{ (snapshot, err) in
            if let err = err{
                print(err)
            }else{
                
                for document in snapshot!.documents{
                    let data = document.data()
                    let fecha = (data["fecha"] as! Timestamp).dateValue()
                    let imagen = data["imagen"] as! String
                    let resultado = data["resultado"] as! String
                    let retos = data["retos"] as! [[String: Any]]
                    
                    let newEntry = Historial(fecha: fecha, imagen: imagen, resultado: resultado, retos: retos)
                    self.histData.append(newEntry)
                }
                
                
            }
            self.tableView.reloadData()
        }
        //self.tableView.reloadData()
    }
    
    

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedHist = datosFiltrados[indexPath.row]
        let vc = storyboard?.instantiateViewController(withIdentifier:"HistorialDetailViewController") as? HistorialDetailViewController
        print(selectedHist)
        vc?.res = selectedHist.resultado
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        vc?.fech = formatter.string(from: selectedHist.fecha)
        vc?.reto = selectedHist.retos
        navigationController?.pushViewController(vc!, animated: true)
        
    }
    // MARK: - Table view data source

        override func numberOfSections(in tableView: UITableView) -> Int {
            // #warning Incomplete implementation, return the number of sections
            return 1
        }

        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // #warning Incomplete implementation, return the number of rows
            return datosFiltrados.count
        }

        override func viewWillDisappear(_ animated: Bool) {
            self.searchController.searchBar.isHidden = true
            tableView.tableHeaderView = UIView()
        }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            var cell = tableView.dequeueReusableCell(withIdentifier: "historial", for: indexPath)as! HistorialTableViewCell
                
            // Configure the cell...
            if (object_getClass(cell)?.description()  == "NSNull") {
                cell = UITableViewCell( style: UITableViewCell.CellStyle.default, reuseIdentifier: "historial") as! HistorialTableViewCell
                
            }
            let objeto = datosFiltrados[indexPath.row] //as! [String: Any]
            let s1:String = objeto.resultado // String(objeto["tipo"] as! String)
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            let s2:String = formatter.string(from: objeto.fecha) //String(objeto["fecha"] as! String)

        //let s2:String = objeto["resultados.fecha"] as! String
            cell.statusLabel?.text=s1
            cell.dateLabel?.text=s2
            switch s1 {
            case "Ansiedad severa":
                cell.backgroundColor = #colorLiteral(red: 0.431372549, green: 0.7333333333, blue: 0.6431372549, alpha: 0.5)
            case "Ansiedad moderada":
                cell.backgroundColor = #colorLiteral(red: 0.6588235294, green: 0.8392156863, blue: 0.7843137255, alpha: 0.5)
            default:
                cell.backgroundColor = #colorLiteral(red: 0.862745098, green: 0.937254902, blue: 0.9137254902, alpha: 0.5)
            }
            return cell
        }
        
    
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
