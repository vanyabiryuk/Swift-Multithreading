//
//  Async Operation.swift
//  Multithreading
//
//  Created by (_:) on 19.10.2022.
//

import Foundation

/* По умолчанию, все операции выполняются синхронно, то есть на том потоке, который вызвал у них метод start().
 Ниже представлен способ реализации асинхронной операции. */

class AsyncOperation: Operation {
    private var finish = false
    private var execute = false
    private let queue = DispatchQueue(label: "com.github-vanyabiryuk.serial-queue")
    
    override var isAsynchronous: Bool { return true }
    override var isFinished: Bool { return finish }
    override var isExecuting: Bool { return execute }
    
    override func start() {
        willChangeValue(forKey: "isExecuting")
        queue.async {
            self.main()
        }
        execute = true
        didChangeValue(forKey: "isExecuting")
    }
    
    override func main() {
        print("Testing async operation.")
        sleep(2)
        print("I slept so well.")
        
        willChangeValue(forKey: "isFinished")
        willChangeValue(forKey: "isExecuting")
        
        finish = true
        execute = false
        
        didChangeValue(forKey: "isFinished")
        didChangeValue(forKey: "isExecuting")
    }
    
    static func test() {
        print("Test begin")
        let asyncOperation = AsyncOperation()
        asyncOperation.start()
        print("Test end")
        
        while true {  }
    }
}

/* Если операция будет работать в связке с OperationQueue, она будет выполнена асинхронно,
 поэтому не следует переопределять свойство isAsynchronous. */
