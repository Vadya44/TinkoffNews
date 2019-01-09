//
//  NewsTableViewCell.swift
//  TinkoffNews
//
//  Created by Вадим Гатауллин on 09/01/2019.
//  Copyright © 2019 Вадим Гатауллин. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        countLabel.backgroundColor = .lightGray
        countLabel.layer.cornerRadius = 6
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.green
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with news : News?) {
        if let news = news {
            nameLabel?.text = news.title
            countLabel?.text = "\(news.reputation)"
            nameLabel.alpha = 1
            countLabel.alpha = 1
            activityIndicator.stopAnimating()
        } else {
            nameLabel.alpha = 0
            countLabel.alpha = 0
            activityIndicator.startAnimating()
        }
    }

}
