//
//  ViewController.swift
//  jenniferbuur_pset3
//
//  Created by Jennifer Buur on 27-02-17.
//  Copyright © 2017 Jennifer Buur. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let watchlist = UserDefaults.standard
    
    var movies = [String]()
    var years = [String]()
    var posters = [String]()
    var plots = [String]()
    var genres = [String]()
    
    var row: Int?
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.search(title: searchBar.text!)
        view.endEditing(true)
        searchBar.text = ""
        searchBar.placeholder = "search a movie"
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        searchBar.text = ""
        searchBar.placeholder = " search a movie"
    }
    
    func getPoster(poster: String) -> UIImage {
        var address = poster.replacingOccurrences(of: "http", with: "https")
        address = address.replacingOccurrences(of: "httpss", with: "https")
        return UIImage(data: try! Data(contentsOf: URL(string: address)!))!
    }
    
    func addMovie(movieDictionary: NSDictionary){
        self.movies.append((movieDictionary["Title"] as? String)!)
        self.years.append((movieDictionary["Year"] as? String)!)
        self.posters.append((movieDictionary["Poster"] as? String)!)
        self.plots.append((movieDictionary["Plot"] as? String)!)
        self.genres.append((movieDictionary["Genre"] as? String)!)
    }
    
    func removeMovie(index: Int){
        self.movies.remove(at: index)
        self.years.remove(at: index)
        self.posters.remove(at: index)
        self.plots.remove(at: index)
        self.genres.remove(at: index)
        updateWatchlist()
        self.tableView.reloadData()
    }
    
    func updateWatchlist(){
        self.watchlist.set(self.movies, forKey: "Title")
        self.watchlist.set(self.years, forKey: "Year")
        self.watchlist.set(self.posters, forKey: "Poster")
        self.watchlist.set(self.plots, forKey: "Plot")
        self.watchlist.set(self.genres, forKey: "Genre")
    }
    
    func search(title: String){
        let movie = title.components(separatedBy: " ").joined(separator: "+")
        let url = URL(string: "https://omdbapi.com/?t="+movie+"&yplot=short&r=json")
        let search = URLSession.shared.dataTask(with: url!) { data, response, error in
            do {
                let movieObject = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
                let response = movieObject["Response"] as? String
                if response == "False" || movie == "" {
                    self.alertUser(title: "Oops", message: "Movie not found")
                } else if self.movies.contains(movieObject["Title"] as! String) == true {
                    self.alertUser(title: "Oops", message: "Movie is already in my watchlist")
                } else {
                    self.addMovie(movieDictionary: movieObject)
                    self.updateWatchlist()
                    self.tableView.reloadData()
                }
            }
            catch {
                print(error)
            }
        }
        search.resume()
    }
    
    @IBOutlet var editButton: UIBarButtonItem!
    @IBAction func editButtonClicked(_ sender: Any) {
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
            editButton.title = "Edit"
        } else {
            tableView.setEditing(true, animated: true)
            editButton.title = "Done"
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.watchlist.array(forKey: "Title") == nil {
            self.alertUser(title: "Welcome", message: "Search movies to add them to my watchlist")
        } else {
            posters = (self.watchlist.array(forKey: "Poster") as? Array<String>)!
            movies = (self.watchlist.array(forKey: "Title") as? Array<String>)!
            years = (self.watchlist.array(forKey: "Year") as? Array<String>)!
            genres = (self.watchlist.array(forKey: "Genre") as? Array<String>)!
            plots = (self.watchlist.array(forKey: "Plot") as? Array<String>)!
        }
        searchBar.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func alertUser(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
        return
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MovieCell
        newCell.title.text = movies[indexPath.row]
        newCell.year.text = years[indexPath.row]
        if posters[indexPath.row] != "N/A" {
            newCell.poster.image = getPoster(poster: posters[indexPath.row])
        } else {
            newCell.poster.image = UIImage(named: "default")
        }
        
        return newCell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            removeMovie(index: indexPath.row)
        }
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        row = indexPath.row
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let secondViewController = segue.destination as! SecondViewController
        if posters[tableView.indexPathForSelectedRow!.row] != "N/A" {
            secondViewController.poster = getPoster(poster: posters[tableView.indexPathForSelectedRow!.row])
        } else {
            secondViewController.poster = UIImage(named: "default")
        }
        secondViewController.movie = self.movies[tableView.indexPathForSelectedRow!.row]
        secondViewController.plot = self.plots[tableView.indexPathForSelectedRow!.row]
        secondViewController.genre = self.genres[tableView.indexPathForSelectedRow!.row]
        secondViewController.year = self.years[tableView.indexPathForSelectedRow!.row]
    }
}

extension ViewController: UISearchBarDelegate {
    
}

