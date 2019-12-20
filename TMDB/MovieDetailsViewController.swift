//
//  MovieDetailsViewController.swift
//  TMDB
//
//  Created by Shyam on 17/12/19.
//  Copyright © 2019 SOLS247. All rights reserved.
//

import UIKit
import SDWebImage

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak var backDropImg: UIImageView!
    @IBOutlet weak var posterImg: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var tagLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var playBtn: UIButton!
    
    var movieID: String!
    var videoURL: String!
    var imgBaseURL = "https://image.tmdb.org/t/p/original"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.playBtn.layer.cornerRadius = 25
        playBtn.imageView?.image = playBtn.imageView?.image!.withRenderingMode(.alwaysTemplate)
        playBtn.tintColor = UIColor.systemRed
        self.backDropImg.dropShadow()
        self.posterImg.dropShadow()
        self.backDropImg.addSubview(self.posterImg)
        getMovieDetails()
        print("MovieID:\(String(describing: movieID!))")
    }
    
    @IBAction func playVideo(_ sender: Any) {
        
        guard let url = URL(string: videoURL) else { return }
        UIApplication.shared.open(url)
        
    }
    func getMovieDetails(){
        let urlString = "https://api.themoviedb.org/3/movie/\(String(describing: movieID!))?api_key=db239d75a07903d0fc366c81218f3cef&language=en-US"
        
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
                    if let backDropImg = jsonResponse!["backdrop_path"] as? String {
                        let imgURL = NSURL(string: self.imgBaseURL + backDropImg)
                        
                        self.backDropImg.sd_imageIndicator = SDWebImageActivityIndicator.gray
                        self.backDropImg.sd_setImage(with: imgURL! as URL, placeholderImage:UIImage(named:"placeholder-image.jpg"))
                        
                    }
                    if let title = jsonResponse!["title"] as? String {
                        self.titleLbl.text = title
                    }
                    
                    if let tagline = jsonResponse!["tagline"] as? String {
                        self.tagLbl.text = tagline
                    }
                    
                    if let overview = jsonResponse!["overview"] as? String {
                        if overview == "" {
                            self.descLbl.text = "Sorry. No synopsis Available."
                        }
                        else{
                            self.descLbl.text = overview
                        }
                    }
                    if let homepage = jsonResponse!["homepage"] as? String {
                        
                        self.videoURL = homepage
                        
                    }
                    
                    if let posterImg = jsonResponse!["poster_path"] as? String{
                        let imgURL = NSURL(string: self.imgBaseURL + posterImg)
                        self.posterImg.sd_imageIndicator = SDWebImageActivityIndicator.gray
                        self.posterImg.sd_setImage(with: imgURL! as URL, placeholderImage:UIImage(named:"placeholder-image.jpg"))
                        
                    }
                } catch let parsingError {
                    print("Error", parsingError)
                }
            }
        }
        task.resume()
    }
}
extension UIImageView {
    func dropShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOpacity = 5
        self.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.layer.shadowRadius = 2
      
    }
    
}
