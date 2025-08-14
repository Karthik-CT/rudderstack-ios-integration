//
//  HomeScreenViewController.swift
//  push
//
//  Created by Karthik Iyer on 25/02/23.
//

import UIKit
import CleverTapSDK
import Rudder

class HomeScreenViewController: UIViewController {

    @IBOutlet weak var txtPushEvent: UITextField!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CleverTap.autoIntegrate()
        CleverTap.setDebugLevel(3)
        
        if let txtPushEvent = txtPushEvent {
            txtPushEvent.delegate = self
        } else {
            print("txtPushEvent is nil")
        }
        
        //Initialize App Inbox
        CleverTap.sharedInstance()?.initializeInbox(callback: ({ (success) in
            let messageCount = CleverTap.sharedInstance()?.getInboxMessageCount()
            let unreadCount = CleverTap.sharedInstance()?.getInboxMessageUnreadCount()
            print("Inbox Message:\(String(describing: messageCount))/\(String(describing: unreadCount)) unread")
         }))
        
    }
    
    @IBAction func PushEventButton(_ sender: UIButton) {
//        CleverTap.sharedInstance()?.recordEvent(txtPushEvent.text!)
        
        //Rudderstack event
        RSClient.sharedInstance()?.track(
            "success_transfer_completed",
            properties: [
                "transfer_amount": "170.00",
                "currency": "INR",
            ]
        )

        self.showToast(message: "Event Pushed!", font: .systemFont(ofSize: 12.0))
    }
    
    func showToast(message : String, font: UIFont) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}

extension HomeScreenViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
