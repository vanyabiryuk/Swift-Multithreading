//
//  Mutex.swift
//  Multithreading
//
//  Created by (_:) on 10.10.2022.
//

import Foundation

struct CMutex {
    static private var mutex = pthread_mutex_t()
    
    static func mainNoMutex(_ firstThreadLowPriority: Bool? = nil) {
        pthread_mutex_init(&mutex, nil)
        
        struct ArrayAndMutex {
            var array: [Int]
            var mutex: pthread_mutex_t
        }
        
        var arrayAndMutex = ArrayAndMutex(array: Array(repeating: -1, count: 10000), mutex: mutex)
        
        var thread1 = pthread_t(bitPattern: 0)
        var attr1 = pthread_attr_t()
        pthread_attr_init(&attr1)
        
        var thread2 = pthread_t(bitPattern: 0)
        var attr2 = pthread_attr_t()
        pthread_attr_init(&attr2)
        
        if firstThreadLowPriority == true {
            pthread_attr_set_qos_class_np(&attr1, QOS_CLASS_BACKGROUND, 0)
            pthread_attr_set_qos_class_np(&attr2, QOS_CLASS_USER_INTERACTIVE, 0)
        } else if firstThreadLowPriority == false {
            pthread_attr_set_qos_class_np(&attr1, QOS_CLASS_USER_INTERACTIVE, 0)
            pthread_attr_set_qos_class_np(&attr2, QOS_CLASS_BACKGROUND, 0)
        }
        
        pthread_create(&thread1, &attr1, { pointer in
            let arrayAndMutex = pointer.assumingMemoryBound(to: ArrayAndMutex.self)
            
            for i in 0..<arrayAndMutex.pointee.array.count {
                arrayAndMutex.pointee.array[i] = i % 7
            }
            
            for i in 0..<arrayAndMutex.pointee.array.count {
                arrayAndMutex.pointee.array[i] *= i % 2 == 0 ? 2 : 3
            }
            
            return nil
        }, &arrayAndMutex)
        
        pthread_create(&thread2, &attr2, { pointer in
            let arrayAndMutex = pointer.assumingMemoryBound(to: ArrayAndMutex.self)
            var negativeCount = 0
            
            for i in 0..<arrayAndMutex.pointee.array.count {
                if arrayAndMutex.pointee.array[i] < 0 { negativeCount += 1}
            }
            
            print("negative count = \(negativeCount)")
            return nil
        }, &arrayAndMutex)
        
        while(true) {  }
    }
    
    static func mainMutex(_ firstThreadLowPriority: Bool? = nil) {
        pthread_mutex_init(&mutex, nil)
        
        struct ArrayAndMutex {
            var array: [Int]
            var mutex: pthread_mutex_t
        }
        
        var arrayAndMutex = ArrayAndMutex(array: Array(repeating: -1, count: 10_000), mutex: mutex)
        
        var thread1 = pthread_t(bitPattern: 0)
        var attr1 = pthread_attr_t()
        pthread_attr_init(&attr1)
        
        var thread2 = pthread_t(bitPattern: 0)
        var attr2 = pthread_attr_t()
        pthread_attr_init(&attr2)
        
        if firstThreadLowPriority == true {
            pthread_attr_set_qos_class_np(&attr1, QOS_CLASS_BACKGROUND, 0)
            pthread_attr_set_qos_class_np(&attr2, QOS_CLASS_USER_INTERACTIVE, 0)
        } else if firstThreadLowPriority == false {
            pthread_attr_set_qos_class_np(&attr1, QOS_CLASS_USER_INTERACTIVE, 0)
            pthread_attr_set_qos_class_np(&attr2, QOS_CLASS_BACKGROUND, 0)
        }
        
        pthread_create(&thread1, &attr1, { pointer in
            let arrayAndMutex = pointer.assumingMemoryBound(to: ArrayAndMutex.self)
            
            pthread_mutex_lock(&arrayAndMutex.pointee.mutex)
            print("mutex locked in thread 1")
            
            for i in 0..<arrayAndMutex.pointee.array.count {
                arrayAndMutex.pointee.array[i] = i % 7
            }
            
            for i in 0..<arrayAndMutex.pointee.array.count {
                arrayAndMutex.pointee.array[i] *= i % 2 == 0 ? 2 : 3
            }
            pthread_mutex_unlock(&arrayAndMutex.pointee.mutex)
            print("mutex unlocked in thread 1")
            
            return nil
        }, &arrayAndMutex)
        
        pthread_create(&thread2, &attr2, { pointer in
            let arrayAndMutex = pointer.assumingMemoryBound(to: ArrayAndMutex.self)
            var negativeCount = 0
            
            pthread_mutex_lock(&arrayAndMutex.pointee.mutex)
            print("mutex locked in thread 2")
            
            for i in 0..<arrayAndMutex.pointee.array.count {
                if arrayAndMutex.pointee.array[i] < 0 { negativeCount += 1}
            }
            
            pthread_mutex_unlock(&arrayAndMutex.pointee.mutex)
            print("mutex unlocked in thread 2")
            print("negative count = \(negativeCount)")
            
            return nil
        }, &arrayAndMutex)
        
        while(true) {  }
    }
}

struct NSMutex {
    static private var mutex = NSLock()
    static private var array = Array(repeating: -1, count: 10_000)
    
    static func mainNoMutex(_ firstThreadLowPriority: Bool? = nil) {
        let thread1 = Thread {
            for index in 0..<array.count {
                array[index] = index % 7
            }
            
            for index in 0..<array.count {
                array[index] *= index % 2 == 0 ? 2 : 3
            }
        }
        
        let thread2 = Thread {
            var negativeCount = 0
            
            for index in 0..<array.count {
                if array[index] < 0 { negativeCount += 1 }
            }
            
            print("negativeCount = \(negativeCount)")
        }
        
        if firstThreadLowPriority == true {
            thread1.qualityOfService = .background
            thread2.qualityOfService = .userInteractive
        } else if firstThreadLowPriority == false {
            thread1.qualityOfService = .userInteractive
            thread2.qualityOfService = .background
        }
        
        thread1.start()
        thread2.start()
        
        while true {  }
    }
    
    static func mainMutex(_ firstThreadLowPriority: Bool? = nil) {
        let thread1 = Thread {
            mutex.lock()
            print("mutex locked in thread 1")
            for index in 0..<array.count {
                array[index] = index % 7
            }
            
            for index in 0..<array.count {
                array[index] *= index % 2 == 0 ? 2 : 3
            }
            mutex.unlock()
            print("mutex unlocked in thread 1")
        }
        
        let thread2 = Thread {
            var negativeCount = 0
            
            mutex.lock()
            print("mutex locked in thread 2")
            
            for index in 0..<array.count {
                if array[index] < 0 { negativeCount += 1 }
            }
            mutex.unlock()
            print("mutex unlocked in thread 2")
            
            print("negativeCount = \(negativeCount)")
        }
        
        if firstThreadLowPriority == true {
            thread1.qualityOfService = .background
            thread2.qualityOfService = .userInteractive
        } else if firstThreadLowPriority == false {
            thread1.qualityOfService = .userInteractive
            thread2.qualityOfService = .background
        }
        
        thread1.start()
        thread2.start()
        
        while true {  }
    }
}
