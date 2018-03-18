//
//  SecondTableViewController.swift
//  CallAnApi
//
//  Created by Fausto Checa on 17/3/18.
//  Copyright © 2018 Fausto Checa. All rights reserved.
//

import UIKit


class SecondTableViewController: UITableViewController {
    
    @IBOutlet weak var paisItem: UINavigationItem!
    
    
    var paisSeleccionado = [String: String]()
    
    var listaAnimales = [[String : String]] ()
    
    var redListAnimalsArray = [String]()
    
    var redListAnimalsString = "http://apiv3.iucnredlist.org/api/v3/country/getspecies/AZ?token=9bb4facb6d23f48efbf424bb05c0c1ef1cf6f468393bc745d42179ac4aca5fee"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let countryString = paisSeleccionado["country"]!
        
        paisItem.title = "Red list in \(countryString)"
        
        let myIsocode = String(describing: self.paisSeleccionado["isocode"]!)
        
       
        
        redListAnimalsString = "http://apiv3.iucnredlist.org/api/v3/country/getspecies/\(myIsocode)?token=9bb4facb6d23f48efbf424bb05c0c1ef1cf6f468393bc745d42179ac4aca5fee"

        // llamar a la API, taer json, parse json, sin copiarlo del anterior
        
        let url = URL(string: redListAnimalsString)
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: url!) { (data, response, error) in
            
            if error != nil {
                print(error as Any)
            }
            guard let data = data else { return }
            
            do{
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String: Any]
                let listaAnimales = json["result"] as! [[String: Any]]
                
                //print(listaAnimales)
                
                for animal in listaAnimales {
                    let scientific_name = animal["scientific_name"] as! String
                    
                    //print(scientific_name)
                    self.redListAnimalsArray.append(scientific_name)
                }
            
            } catch {
                print(error as Any)
            }
            DispatchQueue.main.async {
                 self.tableView.reloadData()
            }
           
        }
        task.resume()
       }

    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return redListAnimalsArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = redListAnimalsArray[indexPath.row]

        return cell
    }
    

    

}
