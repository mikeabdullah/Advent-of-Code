//
//  CountedSet.swift
//  AoC
//
//  Created by Mike on 16/01/2023.
//

struct CountedSet<Element> : Collection where Element : Hashable {
  
  private var storage = [Element: Int]()
  
  var startIndex: Dictionary<Element, Int>.Index { storage.startIndex }
  
  var endIndex: Dictionary<Element, Int>.Index { storage.endIndex }
  
  func index(after i: Dictionary<Element, Int>.Index) -> Dictionary<Element, Int>.Index {
    storage.index(after: i)
  }
  
  subscript(position: Dictionary<Element, Int>.Index) -> Element {
    storage[position].key
  }
  
  var count: Int { storage.count }
  
  mutating func insert(_ element: Element) {
    storage[element, default: 0] += 1
  }
  
  mutating func remove(_ element: Element) {
    guard let count = storage[element] else { return }
    let decremented = count - 1
    if decremented == .zero {
      storage.removeValue(forKey: element)
    } else {
      storage[element] = decremented
    }
  }
}

extension CountedSet {
  
  init<S>(_ sequence: S) where S: Sequence, S.Element == Element {
    for element in sequence {
      self.insert(element)
    }
  }
}
