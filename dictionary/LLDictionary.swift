import Foundation

public class AMDictionary {
  private class AMDNode {
    var previous : AMDNode?
    var word : String
    var count: UInt = 1
    var next : AMDNode?
    var description : String {
      return "\(word): \(count)"
    }

    init(word: String, previous : AMDNode? = nil, next : AMDNode? = nil) {
      self.word = word
      self.previous = previous
      self.next = next
    }
  }

  private func sanitizeWord(var word : String) -> String {
    // "Files have been stripped so as to contain only capital, lower case, space, and newline characters. Words are separated by any number of spaces and/or newline characters. Make sure your parser is case insensitive."
    // Force lowercase
    word = word.lowercaseString

    return word
  }

  public var empty : Bool {
    return first == nil
  }
  private var first : AMDNode?
  private var last : AMDNode?

  private func startWithWord(word : String) {
    let node = AMDNode(word: word)
    first = node
    last = node
  }

  public func printList() {
    var consider = first
    while let current = consider {
      print(current.description)
      consider = current.next
    }
  }

  // O(mn)
  public func processWords(words strWords: String, separatedBy : Character = " ") {
    let words = strWords.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    touchWords(words)
  }

  // O(mn)
  public func touchWords(words : [String]) {
    for word in words {
      touchWord(word)
    }
  }

  // O(n)
  // Creates an entry or increases the existing entry by one
  public func touchWord(var word : String) {
    word = sanitizeWord(word)
    if empty {
      startWithWord(word)
      return
    }
    var consider = first
    while let current = consider {
      if current.word > word {
        let new = AMDNode(word: word)
        insertNode(new, beforeNode: current)
        return
      } else if current.word == word {
        current.count++
        return
      }
      consider = current.next
    }
    let new = AMDNode(word: word)
    // We know that last will be non-nil here because we tested whether the list was empty in a precondition test at the beginning of the function.
    insertNode(new, afterNode: last!)
  }

  // Inserts node before another node, and updates first accordingly
  private func insertNode(node: AMDNode, beforeNode after: AMDNode) {
    if node.word == after.word {
      return
    }
    node.previous = after.previous
    after.previous?.next = node
    node.next = after
    after.previous = node
    if first == nil || after.word == first!.word {
      first = node
    }
  }

  // Inserts node after another node, and updates last accordingly
  private func insertNode(node: AMDNode, afterNode before: AMDNode) {
    node.next = before.next
    before.next?.previous = node
    node.previous = before
    before.next = node
    if last == nil || before.word == last!.word {
      last = node
    }
  }

  public func max() -> (word: String, count : UInt)? {
    var max = first
    var consider = first

    while let current = consider {
      if current.count > max?.count {
        max = current
      }
      consider = current.next
    }
    if let max = max {
      return (max.word, max.count)
    } else {
      return nil
    }
  }

  public func min() -> (word: String, count : UInt)? {
    var min = first
    var consider = first

    while let current = consider {
      if current.count < min?.count {
        min = current
      }
      consider = current.next
    }
    if let min = min {
      return (min.word, min.count)
    } else {
      return nil
    }
  }
}

func testFile(file : String) throws {
  if let dir : NSString = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
    let dict = AMDictionary()

    let path = dir.stringByAppendingPathComponent(file);
    let words = try String(contentsOfFile: path)

    let startTime = NSDate()
    dict.processWords(words: words)
    let endTime = NSDate()

    let timeElapsed = endTime.timeIntervalSinceDate(startTime)

    print("\n\(file) completed in \(timeElapsed) seconds.")
    let max = dict.max()!
    let min = dict.min()!
    print("Max: \(max.word)- \(max.count)")
    print("Min: \(min.word)- \(min.count)")

  }
}

try testFile("words.txt")
try testFile("words2.txt")
try testFile("Holmes.txt")
try testFile("OxfordMedical.txt")




