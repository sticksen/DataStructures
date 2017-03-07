import Foundation

class TrieNode: CustomDebugStringConvertible {
    
    var val: String
    var next: [String : TrieNode] = [:]
    var isWordEnding: Bool = false
    
    init(_ val: String) {
        self.val = val
    }
    
    var debugDescription: String {
        return "\(val) -> \(Array(next.keys))"
    }
    
}

class Trie {
    
    var root = TrieNode("")
    
    func insert(_ word: String) {
        let array = Array(word.lowercased().characters)
        var current = root
        for char in array {
            let char = String(char)
            if let next = current.next[char] {
                current = next
            } else {
                let node = TrieNode(char)
                current.next[char] = node
                current = node
            }
        }
        current.isWordEnding = true
    }
    
    func search(_ word: String) -> Bool {
        let array = Array(word.lowercased().characters)
        var current = root
        for char in array {
            let char = String(char)
            if let next = current.next[char] {
                current = next
            } else {
                return false
            }
        }
        return current.isWordEnding
    }
    
    func startsWith(_ prefix: String) -> Bool {
        let array = Array(prefix.lowercased().characters)
        var current = root
        for char in array {
            let char = String(char)
            if let next = current.next[char] {
                current = next
            } else {
                return false
            }
        }
        return true
    }
}
