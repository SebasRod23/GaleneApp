//
//  HistorialTableViewController.swift
//  GaleneApp
//
//  Created by user190842 on 4/14/21.
//
import UIKit
import HealthKit
import UserNotifications
import FirebaseFirestore
import FirebaseAuth

class RetosTableViewCell: UITableViewCell {
    @IBOutlet weak var iconLabel: UIImageView!
    @IBOutlet weak var retoLabel: UILabel!
    @IBOutlet weak var completadoButton: UIButton!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var recordarSwitch: UISwitch!
    
    @IBAction func completadoFunc(_ sender: Any) {
    }
}

class RetosTableViewController: UITableViewController {
    
    var historialData: Historial = Historial()
    var user : User?
    /** @var handle
          @brief The handler for the auth state listener, to allow cancelling later.
       */
    var handle: AuthStateDidChangeListenerHandle?
    
    var db: Firestore!
    
    private var healthStore : Healthstore?
    private var count: Int? = 0
    
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
    
    struct Historial {
        var fecha: Date = Date()
        var imagen: String = ""
        var resultado: String = ""
        var retos: [[String: Any]] = []
        
        func toAnyObject()->Any{
            return[
                "fecha": fecha,
                "imagen": imagen,
                "resultado": resultado,
                "retos": retos,
            ]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        // [START setup]
        let settings = FirestoreSettings()

        Firestore.firestore().settings = settings
        // [END setup]
        self.db = Firestore.firestore()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                self.user = user
                self.healthStore = Healthstore()
                self.fetchHistorial()
              }
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    func fetchHistorial(){
        let uid : String = self.user!.uid
        db.collection("historial").whereField("userID", isEqualTo: uid).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print(err)
            } else {
                var historial : [Historial] = []
                for document in querySnapshot!.documents {                    historial.append(Historial(fecha: (document.get("fecha") as! Timestamp).dateValue(), imagen: document.get("imagen") as! String, resultado: document.get("resultado") as! String, retos: document.get("retos") as! [[String: Any ]]))
                }
                if !historial.isEmpty {
                    let mostRecentHistorial = historial.reduce(historial[0], { $0.fecha.timeIntervalSince1970 > $1.fecha.timeIntervalSince1970 ? $0 : $1 } )
                    self.historialData = mostRecentHistorial
                    if(self.historialData.imagen == "tenis" || self.historialData.imagen == "balon") {
                        self.getPasos()
                    }
                }
                
            }
            self.tableView.reloadData()
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
        return historialData.retos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "reto", for: indexPath) as! RetosTableViewCell
                
        if (object_getClass(cell)?.description()  == "NSNull") {
            cell = UITableViewCell( style: UITableViewCell.CellStyle.default, reuseIdentifier: "reto") as! RetosTableViewCell
        }
        let retoInfo = self.historialData.retos[indexPath.row]
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
        cell.recordarSwitch.tag = indexPath.row
        cell.recordarSwitch.addTarget(self, action: #selector(recordar(sender:)), for: .valueChanged)
        if(self.historialData.imagen == "tenis" || self.historialData.imagen == "balon"){
            cell.progressLabel?.text=String(self.count!)+" pasos"
            cell.progressLabel?.isHidden = false
        } else{
            cell.progressLabel?.text=""
            cell.progressLabel?.isHidden = true
        }
        
        
        return cell
    }
    @objc func recordar(sender: UISwitch){
        let rowIndex: Int = sender.tag
        if sender.isOn{
            let center = UNUserNotificationCenter.current()

            center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
                if granted {
                    let content = UNMutableNotificationContent()
                        content.title = "Late wake up call"
                    let retoInfo = self.historialData.retos[rowIndex]
                        let strInfo: String = retoInfo["descripcion"] as! String
                        content.body = strInfo
                        content.categoryIdentifier = "alarm"
                        content.userInfo = ["customData": "fizzbuzz"]
                        content.sound = UNNotificationSound.default
                        var dateComponents = DateComponents()
                        dateComponents.hour = 3
                        dateComponents.minute = 22
                        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

                        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                        center.add(request)
                } else {
                    print("D'oh")
                }
            }
        }
    }
    @objc
    func goToCongrats(sender: UIButton){
        let rowIndex: Int = sender.tag
        let nextView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RetoTerminadoViewController") as! RetoTerminadoViewController
        let retoInfo = self.historialData.retos[rowIndex]
        let strInfo: String = retoInfo["descripcion"] as! String
        nextView.retoInp = strInfo
        self.navigationController?.pushViewController(nextView, animated: true)
    }
}
