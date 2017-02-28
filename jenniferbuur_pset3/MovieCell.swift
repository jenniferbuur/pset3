//
//  MovieCell.swift
//  jenniferbuur_pset3
//
//  Created by Jennifer Buur on 27-02-17.
//  Copyright © 2017 Jennifer Buur. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {

    
    @IBOutlet var poster: UIImageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var year: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
