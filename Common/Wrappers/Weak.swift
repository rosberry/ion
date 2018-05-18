//
//  Weak.swift
//  Ion
//
//  Created by Anton K on 4/2/18.
//

protocol Weak: class {
    associatedtype T: AnyObject
    var object: T? { get }
}

final class WeakRef<T: AnyObject>: Weak {
    private(set) weak var object: T?
    init(object: T) {
        self.object = object
    }
}

extension Array where Element: Weak {

    var strongReferences: [Element.T] {
        return compactMap({ (element: Element) -> Element.T? in
            return element.object
        })
    }

    mutating func append(weak: Element.T) {
        let object: Element = WeakRef(object: weak) as! Element
        append(object)
    }

    mutating func remove(_ weak: Element.T) {
        for (index, element) in enumerated() where element.object === weak {
            remove(at: index)
            break
        }
    }

    mutating func compact() {
        self = filter({ (element: Element) -> Bool in
            return element.object != nil
        })
    }
}
