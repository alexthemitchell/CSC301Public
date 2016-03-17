import Foundation

class AMTNode<T> {
  var data: T
  var left: AMTNode?
  var right: AMTNode?

  init(data: T, left: AMTNode? = nil, right: AMTNode? = nil) {
    self.data = data
    self.left = left
    self.right = right
  }
}

public class AMTree<T> {
  public typealias Action = ((T) -> Void)

  var root: AMTNode<T>!
  var insertionQueue = Queue<AMTNode<T>>()

  public func insert(item: T) {
    let node = AMTNode<T>(data: item)
    if let parent = insertionQueue.peek() {
      if parent.left == nil {
        parent.right = node
      } else {
        parent.right = node
        insertionQueue.dequeue()
      }
    }
    insertionQueue.enqueue(node)
  }

  ///MARK: In Order Traversal
  public func inOrderTraversal(perform action: Action?) {
    inOrderTraversal(perform: action, fromBase: root)
  }

  private func inOrderTraversal(perform action: Action?, fromBase base: AMTNode<T>?) {
    if let base = base {
      inOrderTraversal(perform: action, fromBase: base.left)
      action?(base.data)
      inOrderTraversal(perform: action, fromBase: base.right)
    }
  }

  ///MARK: Pre-Order Traversal

  public func preOrderTraversal(perform action: Action?) {
    preOrderTraversal(perform: action, fromBase: root)
  }

  private func preOrderTraversal(perform action: Action?, fromBase base: AMTNode<T>?) {
    if let base = base {
      action?(base.data)
      preOrderTraversal(perform: action, fromBase: base.left)
      preOrderTraversal(perform: action, fromBase: base.right)
    }
  }

  /// MARK: Post-Order Traversal

  public func postOrderTraversal(perform action: Action?) {
    postOrderTraversal(perform: action, fromBase: root)
  }

  private func postOrderTraversal(perform action: Action?, fromBase base: AMTNode<T>?) {
    if let base = base {
      postOrderTraversal(perform: action, fromBase: base.left)
      postOrderTraversal(perform: action, fromBase: base.right)
      action?(base.data)
    }
  }

  /// MARK: Bredth First Traversal

  public func breadthFirstTraversal(perform action: Action?) {
    let queue = Queue<AMTNode<T>>()
    queue.enqueue(root)
    breadthFirstTraversal(perform: action, withQueue: queue)
  }

  private func breadthFirstTraversal(perform action: Action?, withQueue queue: Queue<AMTNode<T>>) {
    if let node = queue.dequeue() {
      if let left = node.left {
        queue.enqueue(left)
      }
      if let right = node.right {
        queue.enqueue(right)
      }
      action?(node.data)
    }
  }
}
