import Foundation

class Node: CustomDebugStringConvertible {
    
    var key: String
    var val: String
    var next: Node?
    
    init(_ val: String, _ key: String) {
        self.val = val
        self.key = key
    }
    
    var debugDescription: String {
        return "[\(key) : \(val)] " + (next != nil ? next!.debugDescription : "")
    }
}

class HashTable: CustomDebugStringConvertible {
    
    private static let sizeOfArray = 20
    
    private var array: [Node?] = Array(repeating: nil, count: sizeOfArray)
    
    func insert(key: String, value: String) {
        let success = performUpdateIfExists(key: key, value: value)
        if !success {
            performInsert(key: key, value: value)
        }
    }
    
    private func performUpdateIfExists(key: String, value: String) -> Bool {
        if let node = getNodeForKey(key) {
            node.val = value
            return true
        }
        return false
    }
    
    private func performInsert(key: String, value: String) {
        let hash = hashCode(key)
        let node = Node(value, key)
        if let existingNode = array[hash] {
            appendNode(existingNode, withNode: node)
            array[hash] = existingNode
        } else {
            array[hash] = node
        }
    }
    
    func get(_ key: String) -> String? {
        if let node = array[hashCode(key)] {
            var current: Node? = node
            while current != nil {
                if let value = checkNodeForKey(node: current!, key: key) {
                    return value
                } else {
                    current = node.next
                }
            }
        }
        return nil
    }
    
    private func getNodeForKey(_ key: String) -> Node? {
        if let node = array[hashCode(key)] {
            var current: Node? = node
            while current != nil {
                if let _ = checkNodeForKey(node: current!, key: key) {
                    return current!
                } else {
                    current = node.next
                }
            }
        }
        return nil
    }

    
    private func appendNode(_ existingNode: Node, withNode nextNode: Node) {
        let last = getLastNode(existingNode)
        last.next = nextNode
    }
    
    private func getLastNode(_ node: Node) -> Node {
        var cur = node
        while let next = cur.next {
            cur = next
        }
        return cur
    }
    
    private func checkNodeForKey(node: Node, key: String) -> String? {
        if node.key == key {
            return node.val
        }
        return nil
    }
    
    func delete(_ key: String) {
        if let node = array[hashCode(key)] {
            var current: Node? = node
            var last: Node? = nil
            while current != nil {
                if current!.key == key {
                    if let last = last {
                        last.next = current!.next
                    } else {
                        array[hashCode(key)] = current!.next != nil ? current!.next! : nil
                    }
                    break
                } else {
                    last = current
                    current = current!.next
                }
            }
        }
    }
    
    private func hashCode(_ str: String) -> Int {
        return Int(str.unicodeScalars.filter({ $0.isASCII }).map({ $0.value }).reduce(0, +)) % HashTable.sizeOfArray
    }
    
    
    var debugDescription: String {
        var out = ""
        for (index, item) in array.enumerated() {
            if let item = item {
                out+="\(index) \(item)\n"
            }
        }
        return out
    }
    
}

