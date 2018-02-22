//
//  MyClass.swift
//  SimpleAsyncTest
//
//  Created by Tineo Adrian on 22.02.18.
//  Copyright © 2018 Tineo Adrian. All rights reserved.
//

import Foundation

protocol MyClassDelegate {
    func call()
}

class MyClass {
    var delegate: MyClassDelegate?
    func someAsyncMethod() {
        DispatchQueue.global(qos: .background).asyncAfter(deadline: DispatchTime(uptimeNanoseconds: 1000000000)) { [weak self] in
            self?.delegate?.call()
        }
    }
}
