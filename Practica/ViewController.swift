//
//  ViewController.swift
//  Practica
//
//  Created by Allison Moreno on 18/04/23.
//

import UIKit
import Apollo

struct Country{
    var name: String
    var code: String
}

class ViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    let apolloClient = ApolloClient(url: URL(string: "https://countries.trevorblades.com/")!)
    var countries = [Country]();
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath) as! DefaultCell
           
           // Configure the cell’s contents.
        cell.lblNombre!.text = self.countries[indexPath.row].name
        cell.lblInicial!.text = self.countries[indexPath.row].code
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        /*
         let query = Query()
         apolloClient.fetch(query: query) { result in
          guard let data = try? result.get().data else { return }
          print(data.hero.name) // Luke Skywalker
        }
         */
        countries.append(Country(name: "Andorra", code: "AD"))
        print(countries)
        tableView.dataSource = self
    }


}

