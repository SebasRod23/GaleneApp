//
//  HistorialTableViewController.swift
//  GaleneApp
//
//  Created by user190842 on 4/14/21.
//

import UIKit
import HealthKit
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
    private var healthStore : Healthstore?
    private var count: Int? = 0
    
        override func viewDidLoad() {
            super.viewDidLoad()
            
            tableView.delegate = self
            healthStore = Healthstore()
            
            if let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString?,
            let sourcePath = documentsPath.appendingPathComponent("MLData.plist") as NSString?,
            let dictionary = NSDictionary(contentsOfFile: sourcePath as String) {
                self.currTag = dictionary["MLString"] as? String
            }
            else {
                self.currTag = "NA"
            }
            
            
            if let url = URL(string: direccion) {
                let datosCrudos = try? Data(contentsOf: url)
                nuevoArray = try! JSONSerialization.jsonObject(with: datosCrudos!) as? [Any]
                
                nuevoArray = nuevoArray!.filter {
                    let elem = ($0 as! [String: Any])
                    let tags = elem["tags"] as! [String]
                    return tags.contains(self.currTag!)
                }
                
            } else {
                // the URL was bad!
                print("the URL was bad!")
            }
            
            if let healthStore = healthStore{
                healthStore.requestAuthorization { success in
                    if success{
                        healthStore.calcularPasos{
                            statisticsCollection in if let statisticsCollection = statisticsCollection{
                                self.updateUIFromStatistics(statisticsCollection)
                            }
                        }
                    }
                }
            }
        }
    
    private func updateUIFromStatistics(_ statisticsCollection: HKStatisticsCollection){
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        let endDate = Date()

        statisticsCollection.enumerateStatistics(from:    startDate, to: endDate){ (statistics,
            stop) in
            let steps = statistics.sumQuantity()?.doubleValue(for: .count())
            self.count = Int(steps ?? 0)
        }
        print(self.count!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //guard
        if let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString?,
        let sourcePath = documentsPath.appendingPathComponent("MLData.plist") as NSString?,
        let dictionary = NSDictionary(contentsOfFile: sourcePath as String) {
            self.currTag = dictionary["MLString"] as? String
        }
        else {
            self.currTag = "NA"
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
            let s1:String = String(objeto["descripcion"] as! String)
          
        let secondsToDelay = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
            cell.retoLabel?.text=String(self.count!)
        }
        
        cell.completadoButton.tag = indexPath.row
        cell.completadoButton.addTarget(self, action: #selector(goToCongrats(sender:)), for: .touchUpInside)
        
            return cell
        }
    @objc
    func goToCongrats(sender: UIButton){
        let rowIndex: Int = sender.tag
        let sigVista = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RetoTerminadoViewController") as! RetoTerminadoViewController
        let objeto = nuevoArray![rowIndex] as! [String: Any]
        let s:String = objeto["descripcion"] as! String
        sigVista.retoTerminado = s
        self.navigationController?.pushViewController(sigVista, animated: true)
    }
  
        
        // MARK: - Navigation

        // In a storyboard-based application, you will often want to do a little preparation before navigation
        /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // Get the new view controller using segue.destination.
            // Pass the selected object to the new view controller.
        }*/

}
