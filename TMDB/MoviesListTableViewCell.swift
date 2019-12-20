//
//  MoviesListTableViewCell.swift
//  TMDB
//
//  Created by Shyam on 16/12/19.
//  Copyright © 2019 SOLS247. All rights reserved.
//

import UIKit

class MoviesListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var popularityLbl: UILabel!
    
    
    @IBOutlet weak var clippingView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        DispatchQueue.main.async {
            
            self.imgView.layer.cornerRadius = 10
            self.imgView.layer.masksToBounds = true
            self.containerView.backgroundColor = UIColor.clear
            self.containerView.layer.shadowOpacity = 10
            self.containerView.layer.shadowRadius = 3
            self.containerView.layer.shadowColor = UIColor.darkGray.cgColor
            self.containerView.layer.shadowOffset = CGSize(width: 3, height: 3)
            self.clippingView.layer.cornerRadius = 20
            self.clippingView.layer.masksToBounds = true
            
            self.backgroundColor = UIColor.white
            self.contentView.backgroundColor = UIColor.clear
            
            
            self.containerView.bringSubviewToFront(self.imgView)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
