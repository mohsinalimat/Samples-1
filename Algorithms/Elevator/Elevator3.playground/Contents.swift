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

// Passenger
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

// Elevator
struct Elevator {
    let min: Floor // min floor
    let max: Floor // max floor
    private(set) var current: Floor // current floor
    private(set) var up: Bool // direction
    private(set) var requests = Set<Passenger>() // requests
    private(set) var passengers = Set<Passenger>() // passengers
    
    init(floors: Int) {
        self.min = 1 // starts at 1st floor
        self.max = floors // max number of floors
        self.current = self.min // set to min floor
        self.up = true // moving up
    }
    
    mutating func add(_ passenger: Passenger) {
        requests.insert(passenger) // add passenger to request queue
    }
    
    mutating func run() {
        while true {
            print("current floor: \(current)")
            print("requests: \(requests.count), passengers: \(passengers.count)")
            
            // pick up passengers waiting on the current floor if in the same direction
            requests.filter { $0.from == current && $0.up == up }.forEach {
                print("picked up: \($0)")
                requests.remove($0)
                passengers.insert($0)
            }
            
            // drop off passengers that requested current floor
            passengers.filter { $0.to == current }.forEach {
                print("dropped off: \($0)")
                passengers.remove($0)
            }
            
            // stop elevator if no requests or passengers
            if requests.isEmpty && passengers.isEmpty {
                break
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
                print("changed direction: \(up ? "up" : "down")")
            }
        }
    }
}

// Tests
class TestCase: XCTestCase {
    
    // Elevator should be able to work for any number of floors (specified when the elevator is first installed)
    func testAssertions() {
        let elevator = Elevator(floors: 4)
        XCTAssertEqual(elevator.max, 4, "Should be 4 floors")
    }
    
    // Elevator should start on the 1st floor
    func testAssertions1() {
        let elevator = Elevator(floors: 4)
        XCTAssertEqual(elevator.current, 1, "Should start at 1st floor")
    }
    
    // A passenger should be able to request a specific floor to go to
    func testAssertions2() {
        let passenger = Passenger(id: 0, from: 1, to: 2)
        XCTAssertEqual(passenger.to, 2, "Should request floor 2")
    }
    
    // A passenger should be able to make the elevator go to the next requested floor
    func testAssertions3() {
        var elevator = Elevator(floors: 4)
        elevator.add(Passenger(id: 0, from: 1, to: 2))
        elevator.run()
        XCTAssertEqual(elevator.current, 2, "Should make elevator go to floor 2")
    }
    
    // A passenger should be able to check what floor the elevator is currently on
    func testAssertions4() {
        var elevator = Elevator(floors: 4)
        elevator.add(Passenger(id: 0, from: 1, to: 2))
        elevator.run()
        XCTAssertEqual(elevator.current, 2, "Should be on floor 2")
    }
    
    // Multiple passengers should be able to request different floors
    func testAssertions5() {
        var elevator = Elevator(floors: 4)
        elevator.add(Passenger(id: 0, from: 1, to: 2))
        elevator.add(Passenger(id: 1, from: 4, to: 3))
        elevator.add(Passenger(id: 2, from: 2, to: 4))
        elevator.add(Passenger(id: 3, from: 3, to: 1))
        XCTAssertEqual(elevator.requests.count, 4, "Should be 4 requests")
    }
    
    // Elevator should be able to determine whether it needs to move up or down
    func testAssertions6() {
        var elevator = Elevator(floors: 4)
        elevator.add(Passenger(id: 0, from: 1, to: 2))
        elevator.run()
        XCTAssertEqual(elevator.current, 2, "Should be on floor 2")
        XCTAssertEqual(elevator.up, true, "Should be going up")
        elevator.add(Passenger(id: 1, from: 2, to: 1))
        elevator.run()
        XCTAssertEqual(elevator.current, 1, "Should be on floor 1")
        XCTAssertEqual(elevator.up, false, "Should be going down")
        elevator.add(Passenger(id: 2, from: 1, to: 3))
        elevator.run()
        XCTAssertEqual(elevator.current, 3, "Should be on floor 3")
        XCTAssertEqual(elevator.up, true, "Should be going up")
    }
    
//    func testAssertions7() {
//        var elevator = Elevator(floors: 4)
//        elevator.add(Passenger(id: 0, from: 4, to: 3))
//        elevator.add(Passenger(id: 1, from: 1, to: 2))
//        elevator.add(Passenger(id: 2, from: 2, to: 4))
//        elevator.add(Passenger(id: 3, from: 3, to: 1))
//        elevator.run()
//        
//        XCTAssertTrue(elevator.requests.isEmpty, "Passengers still waiting")
//        XCTAssertTrue(elevator.passengers.isEmpty, "Passengers still inside elevator")
//    }
//    
//    func testAssertions8() {
//        let passengers = [
//            Passenger(id: 0, from: 4, to: 3),
//            Passenger(id: 1, from: 1, to: 2),
//            Passenger(id: 2, from: 2, to: 4),
//            Passenger(id: 3, from: 3, to: 1)
//        ]
//        
//        var elevator = Elevator(floors: 4)
//        // take passengers to their requested floor
//        passengers.forEach {
//            elevator.add($0)
//        }
//        elevator.run()
//        
//        // bring passengers back to their original floor
//        passengers.forEach {
//            elevator.add(Passenger(id: $0.id, from: $0.to, to: $0.from))
//        }
//        elevator.run()
//        
//        XCTAssertTrue(elevator.requests.isEmpty, "Passengers still waiting")
//        XCTAssertTrue(elevator.passengers.isEmpty, "Passengers still inside elevator")
//    }
    
}

TestCase()
