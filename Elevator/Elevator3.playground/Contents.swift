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

struct Passenger: Hashable {
    let id: Int // unique id to make hashable
    let from: Floor
    let to: Floor
    var up: Bool {
        return to > from
    }
    var hashValue: Int {
        return id
    }
}

func ==(lhs: Passenger, rhs: Passenger) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

struct Elevator {
    let min: Floor // min floor
    let max: Floor // max floor
    var current: Floor // current floor
    private var up: Bool // direction
    private var requests = Set<Passenger>() // requests
    private var passengers = Set<Passenger>() // passengers
    
    init(floors: Int) {
        self.min = 1 // starts at 1st floor
        self.max = floors // max number of floors
        self.current = self.min // set to min floor
        self.up = true // moving up
    }
    
    mutating func add(_ passenger: Passenger) {
        requests.insert(passenger)
    }
    
    mutating func run() {
        while !requests.isEmpty || !passengers.isEmpty {
            print("current floor: \(current)")
            
            // pick up passengers waiting on the current floor if in the same direction
            requests.filter { $0.from == current && $0.up == up }.forEach {
                requests.remove($0)
                passengers.insert($0)
            }
            
            // drop off passengers that requested current floor
            passengers.filter { $0.to == current }.forEach {
                passengers.remove($0)
            }
            
            // all floors queued
            let queued = (requests.flatMap { $0.from } + passengers.flatMap { $0.to })
            
            // move to nearest floor
            if up && current < (queued.max() ?? max) {
                current += 1 // move up
            } else if !up && current > (queued.min() ?? min) {
                current -= 1 // move down
            } else {
                up = !up // change direction
            }
        }
    }
}

// demo
var elevator = Elevator(floors: 4)
elevator.add(Passenger(id: 0, from: 1, to: 3))
elevator.add(Passenger(id: 1, from: 2, to: 1))
elevator.run()
