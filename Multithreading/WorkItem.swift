//
//  WorkItem.swift
//  Multithreading
//
//  Created by (_:) on 14.10.2022.
//

import Foundation

struct WorkItem {
    private static var globalQueue = DispatchQueue.global(qos: .default)
    private static var serial = DispatchQueue(label: "com.github-vanyabiiryuk.serial-queue")
    private static var workItem = DispatchWorkItem(qos: .default, flags: .barrier) {
        sleep(3) // simulating intense work
        print("Work item's block complete!")
    }
    
    /* A method created to understand
     whether workItems are performed synchronously or asynchronously */
    static func syncAsync() {
        print("""
              
              ---------------*---------------
              Before calling perform() method
              ---------------*---------------
              
              """)
        
        workItem.perform()
        
        print("""
              
              -------------*--*-------------
              After calling perform() method
              -------------*--*-------------
              
              """)
    }
    
    // Is it possible to notify multiple queues? (YES, it is)
    static func multipleNotification() {
        workItem.notify(queue: globalQueue) {
            print("Notification for global Dispatch Queue with default QOS.")
        }
        workItem.notify(queue: .global(qos: .background)) {
            print("Notification for global Dispatch Queue with background QOS.")
        }
        
        workItem.perform()
        /* Output:
         Notification for global Dispatch Queue with default QOS.
         Notification for global Dispatch Queue with background QOS.
         */
    }
    
    // Is it possible to notify the calling concurrent queue? (YES, it is)
    static func selfNotificationConcurrent() {
        workItem.notify(queue: globalQueue) {
            print("Notification that is sent to the queue that called the perform method.")
        }
        
        globalQueue.async {
            workItem.perform()
        }
        /* Output:
         Notification that is sent to the queue that called the perform method.
         */
        
        while true {  }
    }
    
    // Is it possible to notify the calling serial queue? (YES, it is)
    static func selfNotificationSerial() {
        workItem.notify(queue: serial) {
            print("Notification that is sent to the queue that called the perform method.")
        }
        
        serial.async {
            workItem.perform()
        }
        /* Output:
         Notification that is sent to the queue that called the perform method.
         */
        
        while true {  }
    }
    
    // Is it possible to execute the work item itself as a notification? (YES, but it won't enter recursion)
    static func selfExecute() {
        workItem.notify(queue: serial, execute: workItem)
        
        serial.async {
            workItem.perform()
        }
        /* Output:
         Work item's block complete!
         Work item's block complete!
         */
        
        while true {  }
    }
    
    static func waiting() {
        print("Begin of execution of the method.")
        serial.async {
            workItem.perform()
        }
        print("Called async() method.\nCalling wait method...")
        workItem.wait()
        print("End of execution of the method.")
        /* Output:
         Begin of the method execution.
         Called async() method.
         Calling wait method...
         Work item's block complete!
         End of the method execution.
         */
        
        while true {  }
    }
    
    static func cancelling() {
        print("Begin execution of the method.")
        serial.asyncAfter(deadline: .now() + .seconds(4), execute: workItem)
        print("Called asyncAfter(deadline:execute:) method.")
        print("workItem.isCancelled = \(workItem.isCancelled)")
        workItem.cancel()
        print("Cancelled work item's block execution.")
        print("workItem.isCancelled = \(workItem.isCancelled)")
        print("Waiting for work items's block to be executed.")
        sleep(10)
        print("End of execution of the method.")
        /* Output:
         Begin execution of the method.
         Called asyncAfter(deadline:execute:) method.
         workItem.isCancelled = false
         Cancelled work item's block execution.
         workItem.isCancelled = true
      -> Waiting for work items's block to be executed.
      -> End of execution of the method.
         */
    }
    
    static func lateCancelling() {
        print("Begin execution of the method.")
        serial.async(execute: workItem)
        print("Called async(execute:) method.")
        print("Waiting befor cancelling the item's block execution.")
        sleep(1)
        print("workItem.isCancelled = \(workItem.isCancelled)")
        workItem.cancel()
        print("Cancelled work item's block execution.")
        print("workItem.isCancelled = \(workItem.isCancelled)")
        sleep(2)
        print("Executing work item with serial.sync method...")
        let begin = Date()
        serial.sync(execute: workItem)
        let end = Date()
        print("Time passed: \(end.timeIntervalSince(begin))")
        print("End of execution of the method.")
        
        /* Output:
         Begin execution of the method.
         Called async(execute:) method.
         Waiting befor cancelling the item's block execution.
         workItem.isCancelled = false
         Cancelled work item's block execution.
         workItem.isCancelled = true
      -> Work item's block complete!
      -> Executing work item with serial.sync method...
      -> Time passed: 2.5987625122070312e-05
         End of execution of the method.
         */
    }
}
