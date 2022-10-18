//
//  Cancel Operation.swift
//  Multithreading
//
//  Created by (_:) on 19.10.2022.
//

import Foundation

class CancelTest {
    private static let operationQueue = OperationQueue()
    
    private class OperationCancelTest: Operation {
        override func main() {
            if isCancelled { return }
            sleep(1)
            if isCancelled { return }
            print("Main complete!")
        }
    }
    
    static func run() {
        print("Run begin")
        let operation1 = OperationCancelTest()
        let operation2 = OperationCancelTest()
        operationQueue.addOperation(operation1)
        operationQueue.addOperation(operation2)
        operation1.cancel()
        print("Run end")
        while true {  }
    }
    
    /* Output:
     Run begin
     Run end
     Main complete!
     */
}
