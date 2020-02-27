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
    @IBOutlet weak var deleteBtn: UIButton!
    
    override var bounds: CGRect {
        didSet {
            contentView.frame = bounds
        }
    }
    
    override func awakeFromNib() {
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func configureCell(with memberData:TeamMember? ) {
        
        guard let memberInfo = memberData else { return }
        
        firstNameLbl.text = memberInfo.name.firstName
        lastNameLbl.text = memberInfo.name.lastName
        genderImgV.image = memberInfo.gender == "male" ? UIImage.init(named: "Male") : UIImage.init(named: "Female")
        if let url = URL(string: memberInfo.imageUrls.thumbnailImageUrl) {
            profilePicImgV.af_setImage(withURL: url)
        }
    }
    
    override func layoutSubviews() {
        profilePicImgV.layer.borderWidth = 1
        profilePicImgV.layer.borderColor = UIColor.lightGray.cgColor
        profilePicImgV.layer.cornerRadius = profilePicImgV.frame.width/2
    }
}
