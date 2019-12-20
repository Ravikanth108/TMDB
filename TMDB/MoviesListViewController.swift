//
//  MoviesListViewController.swift
//  TMDB
//
//  Created by Shyam on 16/12/19.
//  Copyright © 2019 SOLS247. All rights reserved.
//

import UIKit
import SDWebImage

class MoviesListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    struct Movies {
        var imgURL: String
        var movieTitle: String
        var id: Int
        var popularity: Double
    }
    
    @IBOutlet weak var tableView: UITableView!
    var imgURL = [String]()
    var movieTitle = [String]()
    var id = [Int]()
    var moviesList = [Movies]()
    private let refreshControl = UIRefreshControl()
    
    var imgBaseURL = "https://image.tmdb.org/t/p/original"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.tintColor = UIColor.systemRed
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Trending Movies ...")
        
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshMoviesData(_:)), for: .valueChanged)
        
        getTrendingMovies()
    }
    
    func getTrendingMovies(){
        let urlString = "https://api.themoviedb.org/3/trending/all/day?api_key=db239d75a07903d0fc366c81218f3cef"
        
        let URL: Foundation.URL = Foundation.URL(string: urlString)!
        let request:NSMutableURLRequest = NSMutableURLRequest(url:URL)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest){ (data, response, error) in
            print("data:\(String(describing: data))")
            guard data != nil else{
                print("data nil:\(String(describing: data))")
                return
            }
            
            DispatchQueue.main.async {
                
                do{
                    let jsonResponse = try JSONSerialization.jsonObject(with:
                        data!, options: []) as? [String: Any]
                    print("response:\(String(describing: jsonResponse))")
                    guard let array = jsonResponse!["results"] as? [[String: Any]] else {return}
                    
                    print("Array:\(array)")
                    
                    for elem in array {
                        if let title = elem["title"] as? String, let id = elem["id"] as? Int, let poster = elem["poster_path"] as? String, let popularity = elem["popularity"] as? Double {
                            self.moviesList.append(Movies(imgURL: poster, movieTitle: title, id: id, popularity: popularity))
                            print("MOVIESLIST:\(self.moviesList)")
                        }
                        else {
                            let title = elem["original_name"] as? String, id = elem["id"] as? Int, poster = elem["poster_path"] as? String, popularity = elem["popularity"] as? Double
                            self.moviesList.append(Movies(imgURL: poster!, movieTitle: title!, id: id!, popularity: popularity!))
                        }
                    }
                    self.moviesList = self.moviesList.sorted() { $0.popularity > $1.popularity
                    }
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                    print("movieTitle:\(self.movieTitle)")
                    print("imgURL:\(self.imgURL)")
                } catch let parsingError {
                    print("Error", parsingError)
                }
            }
        }
        task.resume()
    }
    @objc private func refreshMoviesData(_ sender: Any) {
        moviesList.removeAll()
        getTrendingMovies()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.moviesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoviesListTableViewCell") as! MoviesListTableViewCell
        
        cell.imgView.clipsToBounds = true
        cell.imgView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.imgView.sd_setImage(with: URL(string: imgBaseURL + moviesList[indexPath.row].imgURL), placeholderImage:UIImage(named:"placeholder-image.jpg"))
        cell.titleLbl.text = moviesList[indexPath.row].movieTitle
        cell.popularityLbl.text = "Poularity: \(String(moviesList[indexPath.row].popularity))"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = self.storyboard?.instantiateViewController(identifier: "MovieDetailsViewController") as! MovieDetailsViewController
        vc.movieID = String(moviesList[indexPath.row].id)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


