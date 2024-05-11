//
//  DataTableViewCell.swift
//  Medicine Reminder
//
//  Created by Omer on 4.05.2024.
//

import UIKit

class DataTableViewCell: UITableViewCell {

    @IBOutlet weak var medicineLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
