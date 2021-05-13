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
    @IBOutlet weak var progressLabel: UILabel!
    
    @IBAction func completadoFunc(_ sender: Any) {
    }
}

class RetosTableViewController: UITableViewController {
    
    struct MLData: Codable {
        var MLString: String
    }
    
    let urlData = "http://martinmolina.com.mx/202111/equipo3/data/retos.json"
    var currTag: String?
    var data: [Any]?
    var filteredData: [Any]?
    
    private var healthStore : Healthstore?
    private var count: Int? = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        healthStore=Healthstore()
        self.fetchDataURL()
        self.loadMLData()
        self.filterDataArray()
        if(currTag=="tenis" || currTag=="balon"){
            self.getPasos()
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.loadMLData()
        self.filterDataArray()
        tableView.reloadData()
        
    }
    
    func filterDataArray() {
        filteredData = data!.filter {
            let elem = ($0 as! [String: Any])
            let tags = elem["tags"] as! [String]
            return tags.contains(self.currTag!)
        }
    }
    
    func loadMLData() {
        if let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString?,
        let sourcePath = documentsPath.appendingPathComponent("MLData.plist") as NSString?,
        let dictionary = NSDictionary(contentsOfFile: sourcePath as String) {
            self.currTag = dictionary["MLString"] as? String
        }
        else {
            self.currTag = "NA"
        }
    }
    
    func fetchDataURL() {
        if let url = URL(string: self.urlData) {
            let dataFromUrl = try? Data(contentsOf: url)
            data = try! JSONSerialization.jsonObject(with: dataFromUrl!) as? [Any]
        } else {
            print("Error loading data from URL!")
        }
    }
    
    func getPasos(){
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
        }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 185
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "reto", for: indexPath) as! RetosTableViewCell
                
        if (object_getClass(cell)?.description()  == "NSNull") {
            cell = UITableViewCell( style: UITableViewCell.CellStyle.default, reuseIdentifier: "reto") as! RetosTableViewCell
        }
        
        let retoInfo = self.filteredData![indexPath.row] as! [String: Any]
        let strInfo: String = String(retoInfo["descripcion"] as! String)
          

        cell.retoLabel?.text = strInfo
        /*
         let secondsToDelay = 5.0
                DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
                    print(self.count!)
                }
         */
        cell.retoLabel?.text=strInfo
        cell.completadoButton.tag = indexPath.row
        cell.completadoButton.addTarget(self, action: #selector(goToCongrats(sender:)), for: .touchUpInside)
        if(currTag=="tenis" || currTag=="balon"){
            cell.progressLabel?.text=String(self.count!)+" pasos"
            cell.progressLabel?.isHidden = false
        } else{
            cell.progressLabel?.text=""
            cell.progressLabel?.isHidden = true
        }
        
        
        return cell
    }
    
    @objc
    func goToCongrats(sender: UIButton){
        let rowIndex: Int = sender.tag
        let nextView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RetoTerminadoViewController") as! RetoTerminadoViewController
        let retoInfo = self.filteredData![rowIndex] as! [String: Any]
        let strInfo: String = retoInfo["descripcion"] as! String
        nextView.retoInp = strInfo
        self.navigationController?.pushViewController(nextView, animated: true)
    }

}
