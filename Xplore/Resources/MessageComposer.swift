//
//  MessageComposer.swift
//  Xplore
//
//  Created by Jack Knight on 3/29/19.
//  Copyright © 2019 Jack Knight. All rights reserved.
//

import Foundation
import MessageUI

class MessageComposer: NSObject, MFMailComposeViewControllerDelegate {
    
    func canSendEmail() -> Bool {
        return MFMailComposeViewController.canSendMail()
    }
    
    func composePhotoReportEmailWith(photo: PhotoPair) -> MFMailComposeViewController {
        let emailComposeVC = MFMailComposeViewController()
        emailComposeVC.mailComposeDelegate = self
        emailComposeVC.setToRecipients(["jkknight9@gmail.com"])
        emailComposeVC.setSubject("Innappropriate Photo")
        emailComposeVC.setMessageBody("Dear Xplore,\n\nI would like to report this photo as inappropriate.\n\nPhoto ID: \(photo.photoUrl)", isHTML: false)
        return emailComposeVC
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
