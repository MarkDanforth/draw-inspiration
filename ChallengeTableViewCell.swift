//
//  ChallengeTableViewCell.swift
//  drawinspiration
//
//  Created by Mark Danforth on 14/08/2017.
//  Copyright © 2017 Mark Danforth. All rights reserved.
//

import UIKit

class ChallengeTableViewCell: UITableViewCell {
    
    // MARK: Properties
    
    @IBOutlet weak var challengeDetails: UILabel!
    @IBOutlet weak var challengeImage: UIImageView!
    @IBOutlet weak var challengeDate: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
