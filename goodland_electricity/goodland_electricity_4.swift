import Foundation

func calculateMinPowerplantCount(k: Int, cities: [Int]) -> Int {
  var builtPowerplantCount = 0

  // we haven't covered anything yet
  var uncoveredCityIndex = 0
  var cityIndex = k - 1
  cityIndex = cityIndex < cities.count ? cityIndex : cities.count-1

  var cityIndexBoundary = 0

  while uncoveredCityIndex < cities.count {
    guard cityIndex >= cityIndexBoundary else { return -1 }

    if cities[cityIndex] == 1 {
      builtPowerplantCount += 1

      uncoveredCityIndex = cityIndex + k
      cityIndex = uncoveredCityIndex + k - 1
      cityIndex = cityIndex < cities.count ? cityIndex : cities.count-1

      cityIndexBoundary = uncoveredCityIndex - k + 1
      cityIndexBoundary = cityIndexBoundary >= 0 ? cityIndexBoundary : 0
    }
    else {
      cityIndex -= 1
    }
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
