//
//  Semaphore.swift
//  Multithreading
//
//  Created by (_:) on 15.10.2022.
//

import Foundation

struct Semaphore {
    static func test(semaphoreValue val: Int = 1, taskCount: Int = 12) {
        let semaphore = DispatchSemaphore(value: val)
        let printSemaphore = DispatchSemaphore(value: 1)
        let begin = Date()
        var last = Date()
        
        let workItem = DispatchWorkItem {
            semaphore.wait()
            defer {
                semaphore.signal()
            }
            
            sleep(3) // intense work simulation
            let end = Date()
            
            printSemaphore.wait()
            defer {
                printSemaphore.signal()
            }
            
            let timePassedBegin = end.timeIntervalSince(begin)
            let timePassedLast = end.timeIntervalSince(last)
            last = end
            
            print("Time passed since begin: \(timePassedBegin)")
            print("Time passed since last: \(timePassedLast)", terminator: "\n\n")
        }
        
        let global = DispatchQueue.global()
        for _ in 1...taskCount {
            global.async(execute: workItem)
        }
        
        while true {  }
    }
}
