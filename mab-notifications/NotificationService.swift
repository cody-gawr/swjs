//
//  NotificationService.swift
//  mab-notifications
//
//  Created by Kyle Smith on 8/4/17.
//  Copyright © 2017 SWJG-Ventures, LLC. All rights reserved.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
            if let notificationData = request.content.userInfo["data"] as? [String: String] {
                if let urlString = notificationData["image_url"], let fileUrl = URL(string: urlString) {
                    // Download the attachment
                    URLSession.shared.downloadTask(with: fileUrl) { (location, response, error) in
                        if let location = location {
                            // Move temporary file to remove .tmp extension
                            let tmpDirectory = NSTemporaryDirectory()
                            var tmpFile = ""
                            // Handle google API not sending back a .png file
                            if fileUrl.host?.contains("google") == true {
                                let tmpString = fileUrl.absoluteString.replacingOccurrences(of: "https://maps.googleapis.com/maps/api/", with: "")
                                tmpFile = "file://".appending(tmpDirectory).appending(tmpString).appending(".png")
                            } else {
                                tmpFile = "file://".appending(tmpDirectory).appending(fileUrl.lastPathComponent)
                            }
                            
                            let tmpUrl = URL(string: tmpFile)!
                            let manager = FileManager.default
                            if manager.fileExists(atPath: tmpUrl.path) {
                                try! manager.removeItem(at: tmpUrl)
                            }
                            try! manager.moveItem(at: location, to: tmpUrl)
                            
                            // Add the attachment to the notification content
                            do {
                                let attachment = try UNNotificationAttachment(identifier: "", url: tmpUrl)
                                self.bestAttemptContent?.attachments = [attachment]
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                        // Serve the notification content
                        self.contentHandler!(self.bestAttemptContent!)
                        }.resume()
            }
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}
