//
//  AlbumViewController.swift
//  iOS Music App
//
//  Created by Brock Gibson on 10/5/18.
//  Copyright © 2018 Brock Gibson. All rights reserved.
//

import UIKit

extension AlbumViewController {
    @IBAction func cancelToAlbumViewController(_ segue: UIStoryboardSegue) {
    }
}

class AlbumViewController: UITableViewController {
    
    @IBOutlet weak var AlbumImg: UIImageView!
    @IBOutlet weak var Talbe: UITableView!
    @IBOutlet weak var AlbumName: UILabel!
    @IBOutlet weak var ArtistName: UILabel!
    
    let URL_GET_DATA = "https://rss.itunes.apple.com/api/v1/us/apple-music/top-albums/all/10/explicit.json"
    var albums = [Album]()
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        
        refreshControl.addTarget(self, action: #selector(fetchTopAlbums), for: .valueChanged)
        
        return refreshControl
    }()
    
    @objc
    func fetchTopAlbums() {
        var albumData = [Album]()
        
        let url = URL(string: URL_GET_DATA)
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if let data = data {
                do {
                    // convert the data to JSON
                    let jsonSerialized = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                    let json = jsonSerialized
                    
                    var queryDic = json?["feed"] as? [String : Any]
                    
                    let items = queryDic?["results"] as? [[String : Any]]
                    
                    for item in items! {
                        albumData.append(Album(id: Int((item["id"] as? String)!)!,
                                                 name: (item["name"] as? String)!,
                                                 artist: (item["artistName"] as? String)!,
                                                 artwork: self.getImage(url: (item["artworkUrl100"] as? String)!),
                                                 explicit: self.checkExplicit(rating: (item["contentAdvisoryRating"])),
                                                 date: self.getReleaseDate(date: (item["releaseDate"] as? String)!),
                                                 url: URL(string: (item["url"] as? String)!)!
                        ))
                    }
                    
                    self.albums = albumData
                    albumData.removeAll()
                    
                    DispatchQueue.main.async {
                        self.refresher.endRefreshing()
                        self.tableView.reloadData()
                    }
                    
                }  catch let error as NSError {
                    print(error.localizedDescription)
                }
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 60
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refresher
        } else {
            tableView.addSubview(refresher)
        }
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        fetchTopAlbums()
    }
    
    func checkExplicit(rating: Any?) -> Bool {
        if let value = rating as? String {
            return value == "Explicit" ? true : false
        }
        return false
    }
    
    func getImage(url :String) -> UIImage {
        let imageData = try! Data(contentsOf: URL(string: url)!)
        return UIImage(data: imageData)!
    }
        
    func getReleaseDate(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let myDate = dateFormatter.date(from: date)!
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from: myDate)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell", for: indexPath) as! AlbumCell
        let album = albums[indexPath.row]
        
        cell.AlbumName.text = album.name
        cell.ArtistName.text = album.artist
        cell.AlbumImage.image = album.artwork
        return cell   
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        self.performSegue(withIdentifier: "AlbumDetail", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "AlbumDetail")
        {
            let controller = segue.destination as? AlbumDetailViewController
            let path = tableView.indexPathForSelectedRow
            
            let row = path?.row
            controller!.getArtistName = albums[row!].artist
            controller!.getAlbumName = albums[row!].name
            controller!.getAlbumArtwork = albums[row!].artwork
            controller!.getExplicit = albums[row!].explicit ? "🅴" : ""
            controller!.getDate = albums[row!].date
        }
    }

}
