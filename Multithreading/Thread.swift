//
//  Thread.swift
//  Multithreading
//
//  Created by (_:) on 08.10.2022.
//

/* Несколько потоков могут улучшисть восприимчивость приложения к действиям пользователя;
 несколько потоков могут улучшить производительность приложения в режиме реального времени. */

import Foundation

/* Параллельные потоки
 Поток 1: ------------
 Поток 2: ------------ */

/* Последовательные потоки
 Поток 1: --   -  ----
 Поток 2:   --- --     */

/* Асинхронные потоки
 Поток 1  (Main): ------------
 Поток 2 (Async):   ----       */

struct PThread { // C
    static func main() {
        var thread = pthread_t(bitPattern: 0)
        var attribute = pthread_attr_t()
        
        pthread_attr_init(&attribute)
        pthread_create(&thread, &attribute, { pointer in
            // Do some work here
            return nil
        }, nil)
    }
}

struct NSThread { // Objective-C / Swift
    static func main() {
        let thread = Thread {
            // Do some work here
        }
        
        thread.start()
    }
    
    static func test() {
        var array1 = [Int](repeating: 0, count: 2500000)
        var array2 = [Int](repeating: 0, count: 2500000)
        
        var begin = Date()
        
        for i in 0..<array1.count {
            array1[i] += 1
        }
        
        for i in 0..<array2.count {
            array2[i] += 1
        }
        
        let end = Date()
        print("Withoud threads: \(end.timeIntervalSince(begin)) s")
        
        begin = Date()
        
        let thread1 = Thread {
            for i in 0..<array1.count {
                array1[i] += 1
            }
            
            let end1 = Date()
            print("Thread 1 finished in \(end1.timeIntervalSince(begin)) s")
        }
        
        let thread2 = Thread {
            for i in 0..<array2.count {
                array2[i] += 1
            }
            
            let end2 = Date()
            print("Thread 2 finished in \(end2.timeIntervalSince(begin)) s")
        }
        
        thread1.start()
        thread2.start()
        
        while true {  }
    }
}
