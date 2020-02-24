//
//  TableViewCell.swift
//  HandZap
//
//  Created by Chandra Rao on 24/02/20.
//  Copyright © 2020 Chandra Rao. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblRate: UILabel!
    @IBOutlet weak var lblTerm: UILabel!

    @IBOutlet weak var btnMore: UIButton!

    @IBOutlet weak var btnInvite: UIButton!
    @IBOutlet weak var btnInbox: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureUI(withData formsData: FormsData?) {
        DispatchQueue.main.async {
            if let data = formsData {
                self.btnInbox.layer.masksToBounds = true
                self.btnInbox.layer.borderColor = UIColor(red: 44.0/255.0, green: 78.0/255.0, blue: 104.0/255.0, alpha: 1.0).cgColor
                self.btnInbox.layer.borderWidth = 2.0
                
                self.btnInvite.layer.masksToBounds = true
                self.btnInvite.layer.borderColor = UIColor(red: 44.0/255.0, green: 78.0/255.0, blue: 104.0/255.0, alpha: 1.0).cgColor
                self.btnInvite.layer.borderWidth = 2.0
                
                self.lblTitle.text = data.title ?? " "
                self.lblDate.text = data.startDate ?? " "
                self.lblRate.text = data.rate ?? " "
                self.lblTerm.text = data.jobTerm ?? " "
            }
        }
    }
}
