//
//  ViewController.swift
//  Bandsintown Demo
//
//  Created by Michael Tadeo on 1/14/20.
//  Copyright © 2020 Tadeo Man. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tab: UISegmentedControl!
    @IBOutlet weak var tabTitle: UINavigationItem!
    
    let headers = ["x-api-key" : "6RLeFqUfcN6SQnnQgPCfq3OozzS6YfTI3zIuDvTd"]
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var artistArray: [Artist] = []
    var favoritesArray: [FavoriteArtist] = [FavoriteArtist]()
    var eventCount : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.keyboardDismissMode = .onDrag
        tableView.separatorStyle = .none
        loadData()
    }

//MARK: - Networking
/***************************************************************/
    func searchArtist(url: String, headers: [String : String]) {
        
        Alamofire.request(url, method: .get, headers: headers ).responseJSON {
            response in
            if response.result.isSuccess {
                
                print("Success!")
                let artistJSON : JSON = JSON(response.result.value!)
                print(artistJSON)
                self.updateArtistData(json: artistJSON)
            }
            else {
                print("Error \(String(describing: response.result.error))")
                
            }
        }
    }
    
    func getEventCount(url: String, headers: [String : String]) {
        
        Alamofire.request(url, method: .get, headers: headers ).responseJSON {
            response in
            if response.result.isSuccess {
                
                print("Success!")
                let eventJSON : JSON = JSON(response.result.value!)
                print(eventJSON)
                
                if eventJSON != JSON.null {
                    self.eventCount = eventJSON["upcoming_event_count"].stringValue + " Upcoming Dates"
                }
            }
            else {
                print("Error \(String(describing: response.result.error))")
                
            }
        }
    }
    
//MARK: - JSON Parsing
/***************************************************************/
    func updateArtistData(json : JSON) {
        
        if json["artists"] != JSON.null {
            
            for results in json["artists"].arrayObject! {
                let json = JSON(results)
                let artists = Artist(
                    artistImage: json["image_url"].stringValue,
                    artistName: json["name"].stringValue,
                    artistId: json["id"].stringValue,
                    trackerCount: json["tracker_count"].stringValue)
                artistArray.append(artists)
            }
        }
    }
 
//MARK: - Core Data Methods
/***************************************************************/
    func saveData() {
        do {
            try context.save()
        } catch  {
            print("Error Saving Coontent to Core Data")
        }
    }
    
  
    func loadData(){
        let request : NSFetchRequest<FavoriteArtist> = FavoriteArtist.fetchRequest()
        
        do {
            favoritesArray = try context.fetch(request)
        } catch  {
            print("Unable to Load Saved Favorite Artists - \(error)")
        }
    }
    
    @IBAction func tabTapped(_ sender: UISegmentedControl) {
        
        tableView.reloadData()
        
        if tab.selectedSegmentIndex == 0 {
            
            tabTitle.title = "Artists"
            searchBar.isHidden = false
            
        } else {

            tabTitle.title = "Favorites"
            searchBar.isHidden = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ArtistDetails" {
            
            if let indexPath = tableView.indexPathForSelectedRow {
                
                let destVC = segue.destination as! ArtistDetailsViewController
                
                //Check the Segment controller to see which Array we are pulling data from
                if tab.selectedSegmentIndex == 0 {
                    
                    destVC.passName = artistArray[indexPath.row].artistName
                    destVC.passTrackerCount = String(artistArray[indexPath.row].trackerCount) + " Trackers"
                    destVC.passUpcomingEvent = eventCount
                  
                }else{
                    
                    destVC.passName = favoritesArray[indexPath.row].name!
                    destVC.passTrackerCount = favoritesArray[indexPath.row].tracker!
                    destVC.passUpcomingEvent = eventCount
                   
                }
                
                //Grab the image from the cell to avoid having to reach out to the network or check the cache
                let cell = tableView.cellForRow(at: indexPath) as! ArtistCell
                if let image = cell.artistImage.image {
                    destVC.passImage = image
                }
                
            }
        }
    }
}

extension ViewController: UISearchBarDelegate {
    
//MARK: - Search Bar Delegate Methods
/***************************************************************/
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let searchUrl =
        "https://search.bandsintown.com/search?query=%7B%22term%22:%22\(searchText)%22,%22entities%22:%5B%7B%22type%22:%22artist%22%7D%5D%7D"
        
        artistArray = []
        
        if !searchText.isEmpty {
            
            searchArtist(url: searchUrl, headers: headers )
            
        } else {
            artistArray = []
            tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.tableView.reloadData()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {

//MARK: - TableView Delegate Methods
/***************************************************************/
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tab.selectedSegmentIndex == 0 {
            
            return artistArray.count
            
        } else {
            
            return favoritesArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ArtistCell
        cell.delegate = self
        
        if tab.selectedSegmentIndex == 0 {
            
            for favorites in favoritesArray {
                if favorites.id == artistArray[indexPath.row].artistId {
                    
                    artistArray[indexPath.row].favoriteSelected = true
                }
            }
            
            cell.artistImage.imageFromServerURL(artistArray[indexPath.row].artistImage, placeHolder: UIImage(systemName: "person.circle"))
            cell.artistNameLabel.text = artistArray[indexPath.row].artistName
            
            if artistArray[indexPath.row].favoriteSelected == true {
                
                cell.favoriteButton.setTitle("★", for: .normal)
                
            } else {
                
                cell.favoriteButton.setTitle("☆", for: .normal)
            }
        } else {
            
            if favoritesArray.count != 0 {
                
                cell.artistNameLabel.text = favoritesArray[indexPath.row].name
                cell.artistImage.imageFromServerURL(favoritesArray[indexPath.row].imageUrl!, placeHolder: UIImage(systemName: "person.circle"))
                cell.favoriteButton.setTitle("★", for: .normal)
            }
        }
        return cell
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var artistName: String = ""
        
        if tab.selectedSegmentIndex == 0 {
            
            artistName = artistArray[indexPath.row].artistName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
            
        } else {
            
            artistName = favoritesArray[indexPath.row].name!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        }
        
        let url = "https://rest.bandsintown.com/artists/\(artistName)?app_id=test"
        getEventCount(url: url, headers: headers)
       
        if eventCount != "" {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "ArtistDetails", sender: self)
            }
        }
        
    }
}


extension ViewController: ArtistCellDelegate {

    func favoriteButtonTapped(cell: UITableViewCell) {
        let indexPathTapped = tableView.indexPath(for: cell)

//Artist Search Tab
            if tab.selectedSegmentIndex == 0 {
                if favoritesArray.count != 0 {

//Check Artist if it exists in the Favorites
                    var favoriteMatch : Bool = false
                    var removeAtIndex : Int?
                    for (index, favorites) in favoritesArray.enumerated() {

                        if favorites.id == artistArray[indexPathTapped![1]].artistId {

                            favoriteMatch = true
                            removeAtIndex = index

                            break
                        } else {
                            print("No Match Found")
                        }
                    }

                    if favoriteMatch == true {
                        
                        artistArray[indexPathTapped![1]].favoriteSelected = false
                        if let removeIndex = removeAtIndex {

                            context.delete(favoritesArray[removeIndex])
                            favoritesArray.remove(at: removeIndex)
                            saveData()
                        }
                    } else {

                        if let pathTapped = indexPathTapped {
                           addToFavorites(indexPath: pathTapped)
                        }
                    }
                } else {

                    if let pathTapped = indexPathTapped{
                       addToFavorites(indexPath: pathTapped)
                    }
                }
            } else {

//Artist Favorites Tab
                if favoritesArray.count != 0{

                    //From Above - use this as a model
                    var artistMatch : Bool = false
                    var removeAtIndex : Int?
                    for (index, searchedArtist) in artistArray.enumerated(){

                        if searchedArtist.artistId == favoritesArray[indexPathTapped![1]].id {

                            artistMatch = true
                            removeAtIndex = index

                            break

                        }else{
                            
                            print("No Match Found")
                        }
                    }

                    if artistMatch == true {

                        if let unFavoriteArtist = removeAtIndex{

                            artistArray[unFavoriteArtist].favoriteSelected = false
                        }
                    }

                    context.delete(favoritesArray[indexPathTapped![1]])
                    favoritesArray.remove(at: indexPathTapped![1])
                    saveData()
                }
            }
            tableView.reloadData()
        }
    
    func addToFavorites(indexPath: IndexPath) {
        
        artistArray[indexPath[1]].favoriteSelected = true
        let favoriteArtist = FavoriteArtist(context: context)
        
        favoriteArtist.id = artistArray[indexPath[1]].artistId
        favoriteArtist.name = artistArray[indexPath[1]].artistName
        favoriteArtist.imageUrl = artistArray[indexPath[1]].artistImage
        favoriteArtist.tracker = String(artistArray[indexPath[1]].trackerCount)
        
        saveData()
        favoritesArray.append(favoriteArtist)
    }
}
