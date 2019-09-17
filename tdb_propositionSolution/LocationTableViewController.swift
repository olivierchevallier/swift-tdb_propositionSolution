//
//  LocationTableViewController.swift
//  tdb_propositionSolution
//
//  Created by olivier chevallier on 11.09.19.
//  Copyright © 2019 Olivier Chevallier. All rights reserved.
//

import UIKit
import os.log

class LocationTableViewController: UITableViewController {
    //MARK: Properties
    var userLocationStr: String?
    var destinationLocation: Location?
    var locations = [Location]()
    let dispatchGroup = DispatchGroup()
    @IBOutlet var txt_search: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txt_search.becomeFirstResponder()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    //MARK: Actions
    @IBAction func txt_searchChanged(_ sender: UITextField) {
        locations = [Location]()
        if txt_search.text != "" {
            performSearch(searchTxt: txt_search.text!, userLocation: userLocationStr!)
        }
        // Le dispatchGroup permet d'attendre que les fonctions qui en font partie quittent le groupe avant d'effectuer ce qui se trouve dans notify. Comme le traitement se fait de manière asynchrone, c'est important
        dispatchGroup.notify(queue: .main) {
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        destinationLocation = locations[indexPath.row]
    }
    
    @IBAction func btn_cancelPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Private methods
    /**
        Effectue la recherche de lieu à afficher dans le TableView
     */
    private func performSearch(searchTxt: String, userLocation: String){
        let url = generateURL(searchTxt: searchTxt, userLocation: userLocation)
        executeHTTPGet(url: url, dataCompletionHandler: { data in
            do {
                let featuresCollection = try JSONDecoder().decode(FeaturesCollection.self, from: data!)
                for feature in featuresCollection.features {
                    self.locations.append(Location(name: feature.place_name, coordinate: feature.geometry.coordinates))
                }
            } catch {
                print("JSON error : \(error)")
            }
        })
    }
    
    /**
        Genère l'URL pour la recherche de lieux grâce à l'API search de MapBox
     */
    private func generateURL(searchTxt: String, userLocation: String) -> URL {
        let accessToken = Bundle.main.object(forInfoDictionaryKey: "MGLMapboxAccessToken") as! String
        let formatedTxt = searchTxt.replacingOccurrences(of: " ", with: "%20")
        let stringURL = "https://api.mapbox.com/geocoding/v5/mapbox.places/" + formatedTxt + ".json?proximity=" + userLocation + "&access_token=" + accessToken
        guard let encodedStringURL = stringURL.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed), let url = URL(string: encodedStringURL) else {
            fatalError("Error generating URL")
        }
        return url
    }
    
    /**
        Exécute un requête HTTP GET sur l'URL donnée en permettant de traiter les données retournée par la requête dans le dataCompletionHandler (explication dataCompletionHandler : https://fluffy.es/return-value-from-a-closure/)
     */
    private func executeHTTPGet(url: URL, dataCompletionHandler: @escaping(Data?) -> Void) {
        dispatchGroup.enter()
        let session = URLSession.shared
        let task = session.dataTask(with: url, completionHandler: {data, response, error in
            if error != nil || data == nil {
                os_log("Client error", log: OSLog.default, type: .debug)
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                os_log("Server error", log: OSLog.default, type: .debug)
                return
            }
        
            guard let mime = response.mimeType, mime == "application/vnd.geo+json" else {
                os_log("Wrong MIME type", log: OSLog.default, type: .debug)
                return
            }
            //Execution du code défini dans le dataCompletionHandler à l'appel de la méthode
            dataCompletionHandler(data)
            self.dispatchGroup.leave()
        })
        task.resume()
    }
      
    struct FeaturesCollection: Decodable {
      let attribution: String
      let features: [Feature]
    }
      
    struct Feature: Decodable {
          let center: [Double]
          let context: [Context]?
          let geometry: Geometry
          let id: String
          let place_name: String
          let place_type: [String]
          let properties: Property
          let text: String
      }
      
      struct Context: Decodable {
          let id: String
          let text: String
      }
      
      struct Geometry: Decodable {
          let coordinates: [Double]
          let type: String
      }
      
      struct Property: Decodable {
          let address: String?
          let category: String?
      }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "LocationTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? LocationTableViewCell else {
            fatalError("The queued view cell is not an instance of LocationTableViewCell")
        }

        let location = locations[indexPath.row]
        cell.lbl_locationName.text = location.name

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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {        
        guard let mapViewController = segue.destination as? MapViewController else {
            fatalError("Unexpected destination : \(segue.destination)")
        }
        
        guard let selectedCell = sender as? LocationTableViewCell else {
            fatalError("Unexpected sender : \(sender)")
        }
        
        guard let indexPath = tableView.indexPath(for: selectedCell) else {
            fatalError("The selected cell is not being displayed by the table")
        }
        
        destinationLocation = locations[indexPath.row]
        mapViewController.destinationLocation = destinationLocation
    }
}
