import Foundation

func calculateMinPowerplantCount(k: Int, cities: [Int]) -> Int {
  var builtPowerplantCount = 0

  // we haven't covered anything yet
  var closestUncoveredCityIndex = 0

  while closestUncoveredCityIndex < cities.count {
    var powerplantBuiltAt: Int? = nil

    // from k-1 to -k+1, starting with the farthest city
    var distance = k-1
    while distance > -k {
      let cityIndex = closestUncoveredCityIndex + distance
      if cityIndex < 0 {
        break
      }
      else if cityIndex < cities.count && cities[cityIndex] == 1 {
        powerplantBuiltAt = cityIndex
        break
      }

      distance -= 1
    }

    guard let builtAt = powerplantBuiltAt else { return -1 }

    builtPowerplantCount += 1
    closestUncoveredCityIndex = builtAt + k
  }

  return builtPowerplantCount
}

let shouldReadInputFromFile = CommandLine.arguments.count > 1
let lines: [String]! = shouldReadInputFromFile
  ? try String(contentsOfFile: CommandLine.arguments[1], encoding: .utf8).components(separatedBy: .newlines)
  : nil

let nkTemp = shouldReadInputFromFile ? lines[0] : readLine()!
let nk = nkTemp.split(separator: " ").map{ String($0) }

let n = Int(nk[0].trimmingCharacters(in: .whitespacesAndNewlines))!
let k = Int(nk[1].trimmingCharacters(in: .whitespacesAndNewlines))!

let citiesTemp = shouldReadInputFromFile ? lines[1] : readLine()!
let cities: [Int] = citiesTemp.split(separator: " ").map {
  if let city = Int($0.trimmingCharacters(in: .whitespacesAndNewlines)) {
      return city
  } else { fatalError("Bad input") }
}

guard cities.count == n else { fatalError("Bad input") }

let startedAt = Date().timeIntervalSince1970
let result = calculateMinPowerplantCount(k: k, cities: cities)
print("took \(Date().timeIntervalSince1970 - startedAt) seconds")

print(result)
