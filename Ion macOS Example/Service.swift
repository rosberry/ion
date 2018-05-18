//
//  Service.swift
//  Ion macOS Example
//
//  Created by Anton K on 4/2/18.
//

import Foundation
import Ion

class Service {

    typealias APIResult = Result<Data>
    private lazy var resultEmitter = Emitter<APIResult>()
    lazy var resultSource = AnyEventSource(resultEmitter)

    private lazy var responseStringEmitter = Emitter<String>()
    lazy var responseStringSource = AnyEventSource(responseStringEmitter)

    func fetchCoinFlipResponse() {
        guard let url = URL(string: "https://www.random.org/coins/?num=1&cur=60-brl.1real") else {
            return
        }

        let task = URLSession.shared.dataTask(with: url) { [weak self] (data: Data?, response: URLResponse?, error: Error?) in
            if let taskError = error {
                self?.resultEmitter.emit(.failure(taskError))
            } else if let taskData = data {
                self?.resultEmitter.emit(.success(taskData))

                if let responseString = String(data: taskData, encoding: .utf8) {
                    self?.responseStringEmitter.emit(responseString)
                }
            }
        }
        task.resume()
    }
}
