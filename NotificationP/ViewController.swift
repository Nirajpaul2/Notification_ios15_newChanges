//
//  ViewController.swift
//  NotificationP
//
//  Created by Purplle on 04/04/22.
//

import UIKit

class ViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()

    
    }

    func scheduleLNTimeIntervalTrigger() {
        // 1. Create Local Notification and Add Content
        let content = UNMutableNotificationContent()
        content.title = "New Arrival 👚👕👖👗"
        content.subtitle = "Available for 2 days ✨🔥"
        content.body = "Woohh✨🔥✨🔥✨🔥✨🔥✨🔥"
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "morning.caf"))
        content.badge = 1
        content.categoryIdentifier = "categoryIdentifier"
        content.userInfo = ["customDataKey": "new_product"]
        content.threadIdentifier = "niraj"
        
        // Add media in the content
        let url = Bundle.main.url(forResource: "newDress", withExtension: "gif")
        if let urlgif = url {
        let attachment = try! UNNotificationAttachment(identifier: "gif", url: urlgif, options: [:])
        content.attachments = [attachment]
        }
        
        // 2. Create Trigger
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false) // Time trigger
        
        let request = UNNotificationRequest(identifier: "notificationIdentifier",
                                            content: content,
                                            trigger: trigger)
        
        // 3. Create a Request
        UNUserNotificationCenter.current().add(request)
    }

    @IBAction func buttonAction(_ sender: Any) {
        scheduleLNTimeIntervalTrigger()
    }

}
