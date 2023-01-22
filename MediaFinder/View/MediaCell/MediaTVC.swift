//
//  MediaTVC.swift
//  MediaFinder
//
//  Created by Tolba on 04/06/1444 AH.
//

import UIKit
import SDWebImage

class MediaTVC: UITableViewCell {
    // MARK:- IBOutlet
    @IBOutlet weak var imageMedia: UIImageView!
    @IBOutlet weak var titleMediaLabel: UILabel!
    @IBOutlet weak var detailMediaLabel: UILabel!
    
    // MARK:- Cell Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK:- IBAction
    @IBAction func btnImageTapped(_ sender: UIButton) {
        let identityImg = imageMedia.frame.origin.x
        imageMedia.frame.origin.x += 4
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.5) {
            self.imageMedia.frame.origin.x -= 8
            self.imageMedia.frame.origin.x = identityImg
        }
    }
}

// MARK:- Methods
extension MediaTVC {
    func setupCell(type: MediaType, media: Media) {
        imageMedia.sd_setImage(with: URL(string: media.artworkUrl), placeholderImage: UIImage(named: PlaceholderImage.user))
        switch type {
        case .movie:
            titleMediaLabel.text = media.trackName
            detailMediaLabel.text = media.longDescription
        case .tvShow:
            titleMediaLabel.text = media.artistName
            detailMediaLabel.text = media.longDescription
        case .music:
            titleMediaLabel.text = media.trackName
            detailMediaLabel.text = media.artistName
        case .all:
            titleMediaLabel.text = media.trackName ?? media.artistName
            detailMediaLabel.text = media.longDescription ?? media.artistName
        }
    }
}

