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
import UIKit

typealias Floor = Int

enum ElevatorError: Error {
    case invalidFloor(Floor)
}

enum Direction {
    case up, down
    
    prefix static func !(a: Direction) -> Direction {
        return a == .up ? .down : .up
    }
}

struct Passenger {
    var floor: Floor
}

struct Elevator {
    
    private var floors: Range<Floor>
    var currentFloor: Floor {
        didSet {
            print("current floor: \(currentFloor)")
        }
    }
    private var selectedFloors = Set<Floor>() {
        didSet {
            print("selected floors: \(selectedFloors)")
        }
    }
    private var direction: Direction = .up {
        didSet {
            print("going: \(direction)")
        }
    }
    
    init(floors: Int) {
        self.floors = Range<Floor>(1...floors)
        self.currentFloor = self.floors.lowerBound
    }
    
    mutating func take(passenger: inout Passenger, to floor: Floor) throws {
        print("take passenger: floor \(passenger.floor) -> \(floor)")
        try go(to: passenger.floor)
        try go(to: floor)
        passenger.floor = floor
    }
    
    private mutating func go(to floor: Floor) throws {
        guard floors.contains(floor) else {
            throw ElevatorError.invalidFloor(floor)
        }
        
        if !selectedFloors.contains(floor) {
            selectedFloors.insert(floor)
            move()
            selectedFloors.remove(floor)
        }
    }
    
    private mutating func move() {
        guard let nextFloor = nextFloor() else { return }
        currentFloor = nextFloor
    }
    
    private mutating func nextFloor() -> Floor? {
        if let nextFloor = self.nextFloor(direction) { return nextFloor }
        if let nextFloor = self.nextFloor(!direction) { direction = !direction; return nextFloor }
        return nil
    }
    
    private func nextFloor(_ direction: Direction) -> Floor? {
        switch direction {
        case .up:
            return selectedFloors.lazy.filter { $0 > self.currentFloor }.first
        case .down:
            return selectedFloors.lazy.filter { $0 < self.currentFloor }.first
        }
    }
    
}

var elevator = Elevator(floors: 4)

var passenger1 = Passenger(floor: 4)
var passenger2 = Passenger(floor: 1)
var passenger3 = Passenger(floor: 2)

do {
    try elevator.take(passenger: &passenger1, to: 2)
    try elevator.take(passenger: &passenger2, to: 3)
    try elevator.take(passenger: &passenger3, to: 4)
    try elevator.take(passenger: &passenger3, to: 2)
    try elevator.take(passenger: &passenger1, to: 1)
    try elevator.take(passenger: &passenger2, to: 8)
} catch ElevatorError.invalidFloor(let floor) {
    print("invalid floor: \(floor)")
}
