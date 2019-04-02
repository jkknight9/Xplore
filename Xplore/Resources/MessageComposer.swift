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
    
    func composePhotoReportEmailWith(adventure: Adventure) -> MFMailComposeViewController {
        let emailComposeVC = MFMailComposeViewController()
        emailComposeVC.mailComposeDelegate = self
        emailComposeVC.setToRecipients(["jkknight9@gmail.com"])
        emailComposeVC.setSubject("Innappropriate Content")
        emailComposeVC.setMessageBody("Dear Xplore,\n\nI would like to report this adventure/user as inappropriate. Due to inappropriate content please review this adventure and remove all disturbing content. \n\ncreaterID: \(adventure.createrID).  \n\nadventureID: \(adventure.uuid) ", isHTML: false)
        return emailComposeVC
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
