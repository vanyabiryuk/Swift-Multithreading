//
//  Dependencies.swift
//  Multithreading
//
//  Created by (_:) on 19.10.2022.
//

import Foundation

struct DependenciesTest {
    private static let operationQueue = OperationQueue()
    
    static func run() {
        let operation1 = BlockOperation {
            print("Operation 1. Begin.")
            sleep(UInt32.random(in: 0...3))
            print("Operation 1. End.")
        }
        
        let operation2 = BlockOperation {
            print("Operation 2. Begin.")
            sleep(UInt32.random(in: 0...3))
            print("Operation 2. End.")
        }
        
        let operation3 = BlockOperation {
            print("Operation 3. Begin.")
            sleep(UInt32.random(in: 0...3))
            print("Operation 3. End.")
        }
        
        operation3.addDependency(operation2)
        operation3.addDependency(operation1)
        
        operationQueue.addOperations([operation1, operation2, operation3], waitUntilFinished: true)
    }
    // operation3 всегда будет выполняться после того, как закончат выполнение operation1 и operation2
}
