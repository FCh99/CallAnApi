//
//  TableViewController.swift
//  CallAnApi
//
//  Created by Fausto Checa on 17/3/18.
//  Copyright © 2018 Fausto Checa. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var misPaises: [[String: String]] = []
    
    var selectedCountry = [String : String] ()
    
  
    
    
    // first list
    
    // Dogs
    var urlString3 = "https://dog.ceo/api/breeds/list/all"
    // no funciona
     var urlImage = "https://dog.ceo/api/breed/hound/images"
    
    
    // New York Times
    var urlString2 = "http://api.nytimes.com/svc/search/v2/articlesearch.json?q=catalunya&api-key=60aeaeae7fff4477958cfe2a8a6a76f5"
    
    
    // Red List
    var urlStringCountries = "http://apiv3.iucnredlist.org/api/v3/country/list?token=9bb4facb6d23f48efbf424bb05c0c1ef1cf6f468393bc745d42179ac4aca5fee"
    var redListAnimals = "http://apiv3.iucnredlist.org/api/v3/country/getspecies/AZ?token=9bb4facb6d23f48efbf424bb05c0c1ef1cf6f468393bc745d42179ac4aca5fee"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // bring and present a list of breeds
       
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: URL.init(string: urlStringCountries)!) { (data, response, error) in
            if error != nil {
                print(error as Any)
            }
            guard let data = data else { return }
            do {
               
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String : Any]
                
                let listaPaises = json["results"] as! [[String : String]]
                var miPais: [String: Any] = [:]
                
                for pais in listaPaises {
                    miPais["isocode"] = pais["isocode"]
                    miPais["country"] = pais["country"]
                    self.misPaises.append(miPais as! [String : String])
                }
                
            }catch {
                print(error as Any)
            }
            DispatchQueue.main.async {
                //print(self.misPaises)
                self.tableView.reloadData()
            }
            
        }
       task.resume()
    }
    
  
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return misPaises.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = misPaises[indexPath.row]["country"]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedCountry = misPaises[indexPath.row]
        
        self.performSegue(withIdentifier: "segueToSecond", sender: nil)
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToSecond" {
            if let destController = segue.destination as? SecondTableViewController {                
            destController.paisSeleccionado = selectedCountry
            }
        }
    }
    
    

}
