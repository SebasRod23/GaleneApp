//
//  HistorialDetailViewController.swift
//  GaleneApp
//
//  Created by user191105 on 5/30/21.
//

import UIKit

class HistorialDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var res1: UILabel!
    @IBOutlet weak var fecha: UILabel!
    @IBOutlet var table: UITableView!
    @IBOutlet var descLabel: UILabel!
    @IBOutlet  var cumplidoLabel: UILabel!
    
    var fech = ""
    var res = ""
    var reto = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = #colorLiteral(red: 0.431372549, green: 0.7333333333, blue: 0.6431372549, alpha: 0.5)
        // Do any additional setup after loading the view.
        res1.text = res
        fecha.text = fech
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reto.count
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reto", for: indexPath) as! RetosEnHistorialTableViewCell
        
        let objeto = reto[indexPath.row]
        cell.desc.text = (objeto["descripcion"] as! String)
        if (objeto["cumplido"] != nil) == false{
            cell.cumplido.text = "No"
        }else{
            cell.cumplido.text = "Si"
        }
        
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
