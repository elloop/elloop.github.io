let vega="red pepper"
switch vega {
    case "cele":
    let va="ok"
    case "cucu":
    let vb="ok"
case let x where x.hasSuffix("pepper"):
    let vc="spicy \(x)?"
default:
    let vd="default"
}

let label="the width"
let width=100
let widthLabel=label + String(width)

// define an array
var shoppingList = ["dog", "cat", "orange", "apple"]
shoppingList[0] = "dog1"

//define a dict
var occupation = [
    "sun":"enginner",
    "wang":"designer",
]

occupation["li"] = "server"

// define empty array
let emptyArray = [String]()
let emptyDict = Dictionary<String, Float>()

// emptyArray[0] = "hello" // wrong statement

// for statement	
let someNumbers = [
    "prime":[2, 3, 5],
    "fib":[1, 1, 2, 3],
    "squre":[1, 4, 9],
]

var largest = 0
for (kind, numbers) in someNumbers {
    for number in numbers {
        if number > largest {
            largest = number
        }
    }
}
println("largest is \(largest)")

// while statement
var n = 2
while n < 100 {
    n = n*2
}

var m = 2
do {
    m = m * 2
} while m < 100

// a range 
//this is wrong!!
//var firstLen = 0
//for i in 0..3 {
//    firstLen += i
//}

var firstLen = 0
for var i=0; i<3; ++i {
    firstLen += 1
}

// define a function
func greet(name: String, day: String) -> String {
    return "hello, \(name), today is \(day)."
}

greet("dog", "saturday")

func getATuple() -> (Double, Double, Double) {
    return (11.1, 22.2, 33.3)
}

getATuple()

// variable number of arguments
func sumOf(nubmers: Int ...) -> Int {
    var sum = 0
    for number in nubmers {
        sum += number
    }
    return sum
}

sumOf()

sumOf(1, 1, 1,1)


// nested function
func return15() -> Int {
    var result = 10
    func add5() {
        result += 5
    }
    add5()
    return result
}

return15()



















