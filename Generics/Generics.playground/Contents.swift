//: Playground - noun: a place where people can play

protocol Food {}

struct Grass: Food {}

protocol Animal {
    init()
}

extension Animal {
    func eat(food: Food) {}
}

struct Dog: Animal {}
struct Cat: Animal {}
struct Kangaroo: Animal {}

struct Pet<A: Animal> {
    func animal() -> A {
        return A()
    }
}

func createPet() {
    let animal = Pet<Dog>().animal()
    animal.eat(Grass())
}
