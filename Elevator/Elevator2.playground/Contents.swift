// Elevator should be able to work for any number of floors (specified when the elevator is first installed)
// Elevator should start on the 1st floor
// A passenger should be able to request a specific floor to go to
// A passenger should be able to make the elevator go to the next requested floor
// A passenger should be able to check what floor the elevator is currently on
//
// Bonus:
// Multiple passengers should be able to request different floors
// Elevator should be able to determine whether it needs to move up or down

import Foundation

typealias Floor = Int

struct Passenger {
    let id: Int = UUID().uuidString.hashValue
    let from: Floor
    let to: Floor
    
    init(from: Floor, to: Floor) {
        self.from = from
        self.to = to
    }
}

extension Passenger: Hashable {
    var hashValue: Int {
        return id
    }
}

func ==(lhs: Passenger, rhs: Passenger) -> Bool {
    return lhs.id == rhs.id
}

struct Elevator {
    let min: Floor // min floor
    let max: Floor // max floor
    var current: Floor // current floor
    private var up = true
    private var waiting = Set<Passenger>() {
        didSet {
            print("waiting: \(waiting)")
        }
    }
    private var carrying = Set<Passenger>() {
        didSet {
            print("carrying: \(carrying)")
        }
    }
    init(floors: Int) {
        self.min = 1
        self.max = floors
        self.current = min
    }
    mutating func add(_ passengers: Set<Passenger>) {
        passengers.forEach { waiting.insert($0) }
    }
    mutating func run() {
        while !waiting.isEmpty || !carrying.isEmpty {
            print("current floor: \(current)")
            
            waiting.filter { $0.from == current }.forEach { waiting.remove($0); carrying.insert($0) }
            carrying.filter { $0.to == current }.forEach { carrying.remove($0) }
            
//            let upCount = waiting.filter { $0.from > current }.count + carrying.filter { $0.to > current }.count
//            let downCount = waiting.filter { $0.from < current }.count + carrying.filter { $0.to < current }.count
//            
//            print(upCount)
//            print(downCount)
            
            if up && current < max {
                current += 1
            } else if !up && current > min {
                current -= 1
            } else {
                up = !up
            }
        }
    }
}

var elevator = Elevator(floors: 4)
elevator.add([Passenger(from: 1, to: 4), Passenger(from: 2, to: 3), Passenger(from: 3, to: 1), Passenger(from: 4, to: 1)])
elevator.add([Passenger(from: 4, to: 4), Passenger(from: 2, to: 4), Passenger(from: 3, to: 2), Passenger(from: 3, to: 2)])
elevator.add([Passenger(from: 1, to: 4), Passenger(from: 2, to: 3), Passenger(from: 2, to: 1), Passenger(from: 2, to: 1)])
elevator.add([Passenger(from: 1, to: 2), Passenger(from: 1, to: 3), Passenger(from: 1, to: 1), Passenger(from: 4, to: 3)])
elevator.run()
