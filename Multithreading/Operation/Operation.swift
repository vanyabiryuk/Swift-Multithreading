//
//  Operation.swift
//  Multithreading
//
//  Created by (_:) on 19.10.2022.
//

import Foundation

/*
 -> Pending -> Ready -> Executing -> Finished
 -> Pending -> Ready -> Executing -> Cancelled
 -> Pending -> Ready -> Cancelled
 -> Pending -> Cancelled
 
 isReady          готова ли операция к выполнению
 isAsynchronous   является ли операция асинхронной; по умолчанию операции создаются асинхронными
 isExecuting      находится ли операция в процессе выполннениня
 isFinished       заверщена ли операция
 isCancelled      отменена ли операция
 
 main()           в ней определяется основной функционал операции
 start()          начинает выполнение операции
 */

struct BlockOperationTest {
    static private let operationQueue = OperationQueue()
    static func run() {
        let blockOperation = BlockOperation {
            print("test")
        }
        operationQueue.addOperation(blockOperation)
        
        while true {  }
    }
}

