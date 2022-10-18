//
//  GCD.swift
//  Multithreading
//
//  Created by (_:) on 13.10.2022.
//

import Foundation

struct GCD {
    private static func task(_ n: Int, withCheckpoints: Bool = false) {
        print("Task \(n). Begin...")
        var sum = 0
        for i in 0..<10_000 {
            sum += i % 7 * (i.isMultiple(of: 3) ? n : -n)
            if withCheckpoints && i.isMultiple(of: 1_000) {
                print("Task \(n). Checkpoint \(i / 1_000)")
            }
        }
        print("Task \(n). Result: \(sum)")
    }
    
    static func main() {
        let serialQueue = DispatchQueue(label: "com.github-vanyabiryuk.serial-queue")
        
        task(1)
        task(2)
        serialQueue.async {
            task(3)
        }
        task(4)
        task(5)
        task(6)
        task(7)
    }
    
    static func delayBlock(for seconds: Int,
                           in queue: DispatchQueue = DispatchQueue.global(qos: .userInitiated),
                           _ completion: @escaping () -> Void) {
        queue.asyncAfter(deadline: .now() + .seconds(seconds), execute: completion)
    }
    
    static func concurrentPerform(arraySize: Int = 200_000) {
        let beginWithoutConcurrency = Date()
        var arrayWithoutConcurrency = Array(repeating: 0, count: arraySize)
        for index in 0..<arrayWithoutConcurrency.count {
            arrayWithoutConcurrency[index] = index % 7 * (index.isMultiple(of: 3) ? 12 : -12)
        }
        let endWithoutConcurrency = Date()
        let sumWithoutConcurrency = arrayWithoutConcurrency.reduce(0, +)
        
        
        let beginWithConcurrency = Date()
        var arrayWithConcurrency = Array(repeating: 0, count: arraySize)
        DispatchQueue.concurrentPerform(iterations: arrayWithoutConcurrency.count) { index in
            arrayWithConcurrency[index] = index % 7 * (index.isMultiple(of: 3) ? 12 : -12)
        }
        let endWithConcurrency = Date()
        let sumWithConcurrency = arrayWithConcurrency.reduce(0, +)
        
        let timeWithoutConcurrency = endWithoutConcurrency.timeIntervalSince(beginWithoutConcurrency)
        let    timeWithConcurrency =    endWithConcurrency.timeIntervalSince(   beginWithConcurrency)
        
        print("""
              WITHOUT Concurrency
              - result: \(sumWithoutConcurrency)
              - time: \(timeWithoutConcurrency)
              
              WITH Concurrency
              - result: \(sumWithConcurrency)
              - time: \(timeWithConcurrency)
              
              Time reduce: x\(timeWithoutConcurrency / timeWithConcurrency)
              """)
    }
}
