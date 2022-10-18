//
//  Waint Until.swift
//  Multithreading
//
//  Created by (_:) on 19.10.2022.
//

import Foundation

struct waitUntil {
    private static let queue = OperationQueue()
    
    static func test() {
        queue.addOperation {
            sleep(1)
            print("Test 1")
        }
        
        queue.addOperation {
            sleep(2)
            print("Test 2")
        }
        
        print("Call wait until")
        queue.waitUntilAllOperationsAreFinished()
        print("Test end")
    }
}
