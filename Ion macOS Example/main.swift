//
//  main.swift
//  Ion macOS Example
//
//  Created by Anton K on 4/2/18.
//

import Foundation
import Ion

let service = Service()
let resultCollector = Collector(source: service.resultSource)
resultCollector.subscribeSuccess { (responseData: Data) in
    print("Got response:")
}

resultCollector.subscribeFailure { (error: Error) in
    print(error)
    exit(1)
}

let responseCollector = Collector(source: service.responseStringSource)

let tailsMatcher = ClosureMatcher(closure: { (content: String) in
    return content.contains("title=\"reverse\"")
})
responseCollector.subscribe(tailsMatcher, handler: { (_) in
    print("Tails")
    exit(0)
})

let headsMatcher = ClosureMatcher(closure: { (content: String) in
    return content.contains("title=\"obverse\"")
})
responseCollector.subscribe(headsMatcher, handler: { (_) in
    print("Heads")
    exit(0)
})

service.fetchCoinFlipResponse()

RunLoop.main.run()
