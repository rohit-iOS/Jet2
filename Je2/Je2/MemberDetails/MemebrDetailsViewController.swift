//
//  MemebrDetailsViewController.swift
//  Je2
//
//  Created by Rohit Karyappa on 2/26/20.
//  Copyright © 2020 Rohit Karyappa. All rights reserved.
//

import UIKit
import MessageUI


class MemebrDetailsViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    var memberInformation : TeamMember!

    @IBOutlet weak var firstNameLbl: UILabel!
    @IBOutlet weak var lastNameLbl: UILabel!
    @IBOutlet weak var profilePicImgV: UIImageView!
    @IBOutlet weak var dateOfBirthLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var emailBtn: UIButton!
    @IBOutlet weak var contactNoBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let memberInfo = memberInformation else { return }
        
        firstNameLbl.text = memberInfo.name.firstName
        lastNameLbl.text = memberInfo.name.lastName
        
        if let url = URL(string: memberInfo.imageUrls.largeImageUrl) {
            profilePicImgV.af_setImage(withURL: url)
        }
        
        setDateOfBirth()
        addressLbl.text = "\(memberInfo.address.city), \(memberInfo.address.country)"
        emailBtn.setTitle(memberInfo.email, for: .normal)
        contactNoBtn.setTitle(memberInfo.contactNo, for: .normal)

    }
    
    func setDateOfBirth() {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = DateFormats.universal
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = DateFormats.display
        
        if let date = dateFormatterGet.date(from: memberInformation.dateOfBirth.date) {
            dateOfBirthLbl.text = dateFormatterPrint.string(from: date)
        }
    }
    
    @IBAction func closeBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func emailBtnAction(_ sender: UIButton) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([memberInformation!.email])
            mail.setMessageBody("<p>Test mail, welcome ...</p>", isHTML: true)
            
            present(mail, animated: true)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    @IBAction func callBtnAction(_ sender: UIButton) {
        guard let number = URL(string: "tel://" + memberInformation!.contactNo) else { return }
        UIApplication.shared.open(number)
    }
    
}
