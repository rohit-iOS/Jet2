//
//  MembersCollectionViewCell.swift
//  Je2
//
//  Created by Rohit Karyappa on 2/26/20.
//  Copyright © 2020 Rohit Karyappa. All rights reserved.
//

import UIKit

class MembersCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var profilePicImgV: UIImageView!
    @IBOutlet weak var genderImgV: UIImageView!
    @IBOutlet weak var firstNameLbl: UILabel!
    @IBOutlet weak var lastNameLbl: UILabel!
    
    
    func configureCell(with memberData:TeamMember? ) {
        // set image with lazy laoding
        
        firstNameLbl.text = memberData?.name.firstName
        lastNameLbl.text = memberData?.name.lastName
    }
}
