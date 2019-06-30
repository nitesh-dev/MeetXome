//
//  File.swift
//  MeetingXome
//
//  Created by Cognizant Technology Solutions # 2 on 26/06/19.
//  Copyright © 2019 Nitesh Singh. All rights reserved.
//
import Foundation

class Dynamic<T> {
    typealias Listener = (T) -> Void
    var listener: Listener?
    
    func bind(listener: Listener?) {
        self.listener = listener
    }
    
    func bindAndFire(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ v: T) {
        self.value = v
    }}
