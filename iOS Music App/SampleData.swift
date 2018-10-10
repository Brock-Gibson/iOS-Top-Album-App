//
//  SampleData.swift
//  iOS Music App
//
//  Created by Brock Gibson on 10/5/18.
//  Copyright © 2018 Brock Gibson. All rights reserved.
//

import Foundation




final class sampleData {
    
    // 1
    let defaultSession = URLSession(configuration: .default)
    // 2
    var dataTask: URLSessionDataTask?
    
    static func generateAlbumData() -> [Album] {
        return [
            Album(name: "Extraordinary Magic", artist: "Ben Rector"),
            Album(name: "Walking in between", artist: "Ben Rector"),
            Album(name: "Head full of dreams", artist: "Coldplay")
        ]
    }
    
    static func getAlbums() -> [Album] {
        var albums: [Album] = []

        let url = URL(string: "https://rss.itunes.apple.com/api/v1/us/apple-music/top-albums/all/10/explicit.json")

        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in

            if let data = data {
                do {
                    // Convert the data to JSON
                    let jsonSerialized = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                    let json = jsonSerialized
//                    print(json!)

                    var queryDic = json?["feed"] as? [String : Any]

                    let items = queryDic?["results"] as? [[String : Any]]


                    for item in items! {
                        albums.append(Album(name: (item["name"] as? String)!, artist: (item["artistName"] as? String)!))
                    }


                    print(albums)


                }  catch let error as NSError {
                    print(error.localizedDescription)
                }
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        task.resume()

        return albums
    }
}
