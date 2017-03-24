//: Playground - noun: a place where people can play

indirect enum BinaryTree<T> {
    case empty
    case node(BinaryTree, T, BinaryTree)
}

extension BinaryTree: CustomStringConvertible {
    var description: String {
        switch self {
        case let .node(left, value, right):
            return "value: \(value), left = [\(left.description)], right = [\(right.description)]"
        case .empty:
            return ""
        }
    }
}

extension BinaryTree {
    var count: Int {
        switch self {
        case let .node(left, _, right):
            return left.count + 1 + right.count
        case .empty:
            return 0
        }
    }
    
    func traverseInOrder(_ process: (T) -> Void) {
        if case let .node(left, value, right) = self {
            left.traverseInOrder(process)
            process(value)
            right.traverseInOrder(process)
        }
    }
    
    func traversePreOrder(_ process: (T) -> Void) {
        if case let .node(left, value, right) = self {
            process(value)
            left.traversePreOrder(process)
            right.traversePreOrder(process)
        }
    }
    
    func traversePostOrder(_ process: (T) -> Void) {
        if case let .node(left, value, right) = self {
            left.traversePostOrder(process)
            right.traversePostOrder(process)
            process(value)
        }
    }
    
    func invert() -> BinaryTree {
        if case let .node(left, value, right) = self {
            return .node(right.invert(), value, left.invert())
        } else {
            return .empty
        }
    }
}

// leaf nodes
let node5 = BinaryTree.node(.empty, "5", .empty)
let nodeA = BinaryTree.node(.empty, "a", .empty)
let node10 = BinaryTree.node(.empty, "10", .empty)
let node4 = BinaryTree.node(.empty, "4", .empty)
let node3 = BinaryTree.node(.empty, "3", .empty)
let nodeB = BinaryTree.node(.empty, "b", .empty)

// intermediate nodes on the left
let Aminus10 = BinaryTree.node(nodeA, "-", node10)
let timesLeft = BinaryTree.node(node5, "*", Aminus10)

// intermediate nodes on the right
let minus4 = BinaryTree.node(.empty, "-", node4)
let divide3andB = BinaryTree.node(node3, "/", nodeB)
let timesRight = BinaryTree.node(minus4, "*", divide3andB)

// root node
let tree = BinaryTree.node(timesLeft, "+", timesRight)

// count
tree.count

// invert tree
tree.traverseInOrder { print($0) }

// invert tree
tree.invert().traverseInOrder { print($0) }
