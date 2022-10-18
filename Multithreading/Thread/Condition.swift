//
//  Condition.swift
//  Multithreading
//
//  Created by (_:) on 11.10.2022.
//

import Foundation

/* The pseudocode for performing the preceding steps would therefore look something like the following:
 lock the condition
 while (!(boolean_predicate)) {
     wait on condition
 }
 do protected work
 (optionally, signal or broadcast the condition again or change a predicate value)
 unlock the condition */



struct Condition {
    private static var isReady = false
    private static var array = Array(repeating: 0, count: 200_000)
    private static var condition = NSCondition()
    
    static func main() {
        let fillThread = Thread {
            condition.lock()
            defer {
                condition.unlock()
                print("Quit fillThread.")
            }
            
            print("Enter fillThread.")
            
            for index in 0..<array.count {
                array[index] = index % 7
            }
            
            for index in 1..<array.count {
                array[index] *= array[index - 1] % 2 == 0 ? 2 : 3
            }
            
            isReady = true
            condition.signal()
        }
        
        let countThread = Thread {
            condition.lock()
            defer {
                condition.unlock()
                print("Quit countThread.")
            }
            
            print("Enter countThread.")
            
            while !isReady {
                print("Waiting...")
                condition.wait()
            }
            isReady = false
            
            let sum = array.reduce(0, +)
            print("The sum is \(sum).")
            
        }
        
        fillThread.start()
        countThread.start()
        while true {  }
    }
}
