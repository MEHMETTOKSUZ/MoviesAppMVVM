//
//  DetailsHeaderView.swift
//  MoviesMVVM
//
//  Created by Mehmet ÖKSÜZ on 4.01.2024.
//

import UIKit

class DetailsHeaderView: UICollectionReusableView {
    
    struct ViewModel {
        let key: String
    }
    
    @IBOutlet weak var realeseDateLabel: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var overViewLabel: UILabel!
    @IBOutlet weak var imdbLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var addCartButton: UIButton!
    
    var favoriteButtonClicked: (() -> ())?
    var commentButtonClicked: (() -> ())?
    var playButtonClicked: (() -> ())?
    var addCartButtonClicked: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func itemFromCell(item: DetailsUIModel) {
        if let image = item.imageUrl {
            self.posterImage.downloaded(from: image, contentMode: .scaleToFill)
            self.posterImage.layer.cornerRadius = 30
        }
        
        self.overViewLabel.text = item.overview
        self.imdbLabel.text = item.imdbTitle
        self.nameLabel.text = item.nameTitle
        self.realeseDateLabel.text = item.realeseDate
        
        let imageName : String = item.isFavorite ? "star.fill": "star"
        self.favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
        
        self.addCartButton.isHidden = item.isAddedCart || item.isRented
        
    }
    
    
    @IBAction func favoriteButtonClicked(_ sender: Any) {
        
        self.favoriteButtonClicked?()
    }
    
    @IBAction func commentButtonClicked(_ sender: Any) {
        
        self.commentButtonClicked?()
        
    }
    
    @IBAction func playButtoNClicked(_ sender: Any) {
        
        self.playButtonClicked?()
    }
    
    @IBAction func addCartButtonClicked(_ sender: Any) {
        
        self.addCartButtonClicked?()
    }
    
}


extension DetailsHeaderView.ViewModel {
    init(response: MovieVideo) {
        
        self.init(key: response.key)
    }
}
