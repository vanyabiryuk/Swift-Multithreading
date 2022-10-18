//
//  OperationQueue.swift
//  Multithreading
//
//  Created by (_:) on 19.10.2022.
//

import Foundation

class OperationA: Operation {
    override func main() {
        print("Overriden main in OperationA.\n\(Thread.current)")
    }
}

struct OperationQueueTest {
    static private let operationQueue = OperationQueue()
    static func run() {
        operationQueue.addOperation {
            print("OperationQueueTest.run()...\n\(Thread.current)")
        }
        
        operationQueue.addOperation(OperationA())
        
        while true {  }
    }
}
