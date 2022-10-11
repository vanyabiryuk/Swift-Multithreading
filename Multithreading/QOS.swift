//
//  QOS.swift
//  Multithreading
//
//  Created by (_:) on 09.10.2022.
//

import Foundation

/* Quality of Service

 * User-interactive (QOS_CLASS_USER_INTERACTIVE)
 The quality-of-service class for user-interactive tasks, such as animations, event handling, or updates to app's user
 interface. User-interactive tasks have the highest priority on the system. Use this class for tasks or queues
 that interact with the user or actively update your app's user interface. For example, use this class for animations
 or for tracking events interactively.
 
 * User-initiated (QOS_CLASS_USER_INITIATED)
 The quality-of-service class for tasks that prevent the user from actively using an app. User-initiated tasks are
 second only to user-interactive tasks in their priority on the system. Assign this class to tasks that provide
 immediate results for something the user is doing, or that would prevent the user from using your app. For example,
 you might use this quality-of-service class to load the content of an email that you want to display to the user.
 
 * Default (QOS_CLASS_DEFAULT)
 The default quality-of-service class. Default tasks have a lower priority than user-initiated and user-interactive
 tasks, but a higher priority than utility and background tasks. Assign this class to tasks or queues that your app
 initiates or uses to perform active work on the user's behalf.

 * Utility (QOS_CLASS_UTILITY)
 The quality-of-service class for tasks that the user does not track actively. Utility tasks have a lower priority than
 default, user-initiated, and user-interactive tasks, but a higher priority than background tasks. Assign this
 quality-of-service class to tasks that do not prevent the user from continuing to use your app. For example, you might
 assign this class to long-running tasks whose progress the user does not follow actively.
 
 * Background (QOS_CLASS_BACKGROUND)
 The quality-of-service class for maintenance or cleanup tasks that you create. Background tasks have the lowest
 priority of all tasks. Assign this class to tasks or dispatch queues that you use to perform work while your app is
 running in the background.
 
 * Unspecified (QOS_CLASS_UNSPECIFIED)
 The absence of a quality-of-service class. */

struct QOSPThread {
    static let qosClasses = [QOS_CLASS_UNSPECIFIED,     QOS_CLASS_BACKGROUND,          QOS_CLASS_UTILITY,
                                 QOS_CLASS_DEFAULT, QOS_CLASS_USER_INITIATED, QOS_CLASS_USER_INTERACTIVE]
    static var qosTitles = ["Unspecified", "Background", "Utility", "Default", "User-initiated", "User-interactive"]
    
    static func main() {
        var pthread = pthread_t(bitPattern: 0)
        var attribute = pthread_attr_t()
        pthread_attr_init(&attribute)
        
        for index in 0..<self.qosClasses.count {
            let qos = qosClasses[index]
            
            pthread_attr_set_qos_class_np(&attribute, qos, 0)
            pthread_create(&pthread, &attribute, { pointer in
                let begin = Date()
                
                var array = Array(repeating: 0, count: 5_000_000)
                for i in 0..<array.count { array[i] += 1 }
                
                let end = Date()
                
                let qosStr = pointer.load(as: String.self)
                print("\(qosStr) QOS thread finished in \(end.timeIntervalSince(begin)) s")
                
                return nil
            }, &qosTitles[index])
        }
        
        while true {  }
    }
}

struct QOSNSThread {
    static let qosClasses: [(qos: QualityOfService, title: String)] = [
        (.background, "Background"),
        (.utility, "Utility"),
        (.default, "Deafult"),
        (.userInitiated, "User-initiated"),
        (.userInteractive, "User-interactive")
    ]
    
    static func main() {
        for index in 0..<self.qosClasses.count {
            let nsThread = Thread {
                let begin = Date()
                
                var array = Array(repeating: 0, count: 5_000_000)
                for i in 0..<array.count { array[i] += 1 }
                
                let end = Date()
                
                let qosStr = self.qosClasses[index].title
                print("\(qosStr) QOS thread finished in \(end.timeIntervalSince(begin)) s")
            }
            
            nsThread.qualityOfService = qosClasses[index].qos
            nsThread.start()
        }
        
        while true {  }
    }
}
