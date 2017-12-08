//
//  TaskCellTableViewCell.swift
//  TasksApp
//
//  Created by Aloc SP06447 on 06/12/2017.
//  Copyright © 2017 Aloc SP06447. All rights reserved.
//

import UIKit

class TaskCellTableViewCell: UITableViewCell {

    @IBOutlet weak var nome: UILabel!
    @IBOutlet weak var horario: UILabel!
    @IBOutlet weak var descricao: UILabel!
    @IBOutlet weak var enable: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
