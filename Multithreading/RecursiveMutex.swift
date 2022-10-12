//
//  RecursiveMutex.swift
//  Multithreading
//
//  Created by (_:) on 11.10.2022.
//

import Foundation

/* Problems with threads
 - Race condition
 - Resource contention
 - Deadlock
 - Starvation
 - Priority inversion
 - Non-deterministic and Fairness */

struct CRecursiveMutex {
    static var mutex = pthread_mutex_t()
    static var mutex_attr = pthread_mutexattr_t()
    
    static func main(isRecursive: Bool = true) {
        pthread_mutexattr_init(&mutex_attr)
        if isRecursive { pthread_mutexattr_settype(&mutex_attr, PTHREAD_MUTEX_RECURSIVE) }
        pthread_mutex_init(&mutex, &mutex_attr)
        
        print("Trying to obtain mutex in main()...")
        pthread_mutex_lock(&mutex)
        print("Obtained mutex in main().")
        
        defer {
            print("Realeasing mutex in main()...")
            pthread_mutex_unlock(&mutex)
            print("Relesed mutex in main().")
        }
        
        print("Calling some_func()...")
        some_func()
    }
    
    static func some_func() {
        print("Trying to obtain mutex in some_func()...")
        pthread_mutex_lock(&mutex)
        print("Obtained mutex in some_func().")
        
        defer {
            print("Releasing mutex in some_func()...")
            pthread_mutex_unlock(&mutex)
            print("Released mutex in some_func().")
        }
        
        print("Doing some stuff inside some_func().")
        // Doing stuff...
    }
}

struct NSRecursiveMutex {
    private static var recursiveMutex = NSRecursiveLock()
    private static var nonRecursiveMutex = NSLock()
    
    private static func recursiveMain() {
        print("Trying to obtain mutex in main()...")
        recursiveMutex.lock()
        print("Obtained mutex in main().")
        
        defer {
            print("Realeasing mutex in main()...")
            recursiveMutex.unlock()
            print("Relesed mutex in main().")
        }
        
        print("Calling some_func()...")
        recursiveSomeFunc()
    }
    
    private static func recursiveSomeFunc() {
        print("Trying to obtain mutex in someFunc()...")
        recursiveMutex.lock()
        print("Obtained mutex in some_func().")
        
        defer {
            print("Releasing mutex in someFunc()...")
            recursiveMutex.unlock()
            print("Released mutex in someFunc().")
        }
        
        print("Doing some stuff inside someFunc().")
        // Doing stuff...
    }
    
    private static func nonRecursiveMain() {
        print("Trying to obtain mutex in main()...")
        nonRecursiveMutex.lock()
        print("Obtained mutex in main().")
        
        defer {
            print("Realeasing mutex in main()...")
            nonRecursiveMutex.unlock()
            print("Relesed mutex in main().")
        }
        
        print("Calling some_func()...")
        nonRecursiveSomeFunc()
    }
    
    private static func nonRecursiveSomeFunc() {
        print("Trying to obtain mutex in someFunc()...")
        nonRecursiveMutex.lock()
        print("Obtained mutex in some_func().")
        
        defer {
            print("Releasing mutex in someFunc()...")
            nonRecursiveMutex.unlock()
            print("Released mutex in someFunc().")
        }
        
        print("Doing some stuff inside someFunc().")
        // Doing stuff...
    }
    
    static func main(isRecursive: Bool = true) {
        isRecursive ? recursiveMain() : nonRecursiveMain()
    }
}
