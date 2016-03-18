import Foundation

func processFile(file: String) {
  let tree = AMTree<String>()

  if let dir : NSString = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {

    let path = dir.stringByAppendingPathComponent(file);
    do {
      var words = try String(contentsOfFile: path).componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
      words = words.filter({ (word) -> Bool in
        return word != ""
      })

      for word in words {
        if word != "" {
          tree.insert(word)
        }
      }
    } catch {
      print("Failure.")
      return
    }
  }

  let action = { (word) -> Void in
    print(word)
  }

  print("In Order:")
  tree.inOrderTraversal(perform: action)

  print("Pre Order:")
  tree.preOrderTraversal(perform: action)

  print("Post Order:")
  tree.postOrderTraversal(perform: action)

  print("Breadth First:")
  tree.breadthFirstTraversal(perform: action)

}

processFile("in-order.txt")