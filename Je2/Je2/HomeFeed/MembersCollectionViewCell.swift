//
//  MembersCollectionViewCell.swift
//  Je2
//
//  Created by Rohit Karyappa on 2/26/20.
//  Copyright © 2020 Rohit Karyappa. All rights reserved.
//

import UIKit
import AlamofireImage

class MembersCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var profilePicImgV: UIImageView!
    @IBOutlet weak var genderImgV: UIImageView!
    @IBOutlet weak var firstNameLbl: UILabel!
    @IBOutlet weak var lastNameLbl: UILabel!
    
    override var bounds: CGRect {
        didSet {
            contentView.frame = bounds
        }
    }
    
    override func awakeFromNib() {
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func configureCell(with memberData:TeamMember? ) {
        firstNameLbl.text = memberData?.name.firstName
        lastNameLbl.text = memberData?.name.lastName
        genderImgV.image = memberData!.gender == "male" ? UIImage.init(named: "Male") : UIImage.init(named: "Female")
        if let url = URL(string: memberData!.imageUrls.thumbnailImageUrl) {
            profilePicImgV.af_setImage(withURL: url)
        }
    }
    
    override func layoutSubviews() {
        profilePicImgV.layer.borderWidth = 1
        profilePicImgV.layer.borderColor = UIColor.lightGray.cgColor
        profilePicImgV.layer.cornerRadius = profilePicImgV.frame.width/2
    }
}
