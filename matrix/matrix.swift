import Foundation

struct City {
  var hasMachine = false
  // key - city index, value - destruction time
  var roads = [Int: Int]()
}

func minTime(roads: [[Int]], machines: [Int]) -> Int {
  let sortedRoads = roads.sorted {
    $0[2] < $1[2]
  }

  var cities = convertToCities(roads: roads)
  for machineCityIndex in machines {
    cities[machineCityIndex].hasMachine = true
  }

  var roadIndex = 0
  var destroyedRoadCount = 0
  var totalTime = 0

  while destroyedRoadCount < machines.count-1 {
    let currentRoad = sortedRoads[roadIndex]
    let from = currentRoad[0]
    let to = currentRoad[1]

    if isConnectedToAnyMachine(previousCityIndex: from, currentCityIndex: to, cities: cities)
      && isConnectedToAnyMachine(previousCityIndex: to, currentCityIndex: from, cities: cities)
    {
      totalTime += currentRoad[2]
      destroyedRoadCount += 1
      cities[from].roads[to] = nil
      cities[to].roads[from] = nil
    }

    roadIndex += 1
  }

  return totalTime
}

func convertToCities(roads: [[Int]]) -> [City] {
  var cities = Array(repeating: City(), count: roads.count+1)

  for road in roads {
    let firstCityIndex = road[0]
    let secondCityIndex = road[1]
    let time = road[2]

    cities[firstCityIndex].roads[secondCityIndex] = time
    cities[secondCityIndex].roads[firstCityIndex] = time
  }

  return cities
}

func isConnectedToAnyMachine(previousCityIndex: Int, currentCityIndex: Int, cities: [City]) -> Bool {
  if cities[currentCityIndex].hasMachine {
    return true
  }

  for (neigborIndex, _) in cities[currentCityIndex].roads {
    if neigborIndex == previousCityIndex {
      continue
    }

    let isConnected = isConnectedToAnyMachine(previousCityIndex: currentCityIndex, currentCityIndex: neigborIndex, cities: cities)
    if isConnected {
      return true
    }
  }

  return false
}

let stdout = ProcessInfo.processInfo.environment["OUTPUT_PATH"]!
FileManager.default.createFile(atPath: stdout, contents: nil, attributes: nil)
let fileHandle = FileHandle(forWritingAtPath: stdout)!

guard let nkTemp = readLine() else { fatalError("Bad input") }
let nk = nkTemp.split(separator: " ").map{ String($0) }

guard let n = Int(nk[0].trimmingCharacters(in: .whitespacesAndNewlines))
else { fatalError("Bad input") }

guard let k = Int(nk[1].trimmingCharacters(in: .whitespacesAndNewlines))
else { fatalError("Bad input") }

let roads: [[Int]] = AnyIterator{ readLine() }.prefix(n - 1).map {
    let roadsRow: [Int] = $0.split(separator: " ").map {
        if let roadsItem = Int($0.trimmingCharacters(in: .whitespacesAndNewlines)) {
            return roadsItem
        } else { fatalError("Bad input") }
    }

    guard roadsRow.count == 3 else { fatalError("Bad input") }

    return roadsRow
}

guard roads.count == n - 1 else { fatalError("Bad input") }

let machines: [Int] = AnyIterator{ readLine() }.prefix(k).map {
    if let machinesItem = Int($0.trimmingCharacters(in: .whitespacesAndNewlines)) {
        return machinesItem
    } else { fatalError("Bad input") }
}

guard machines.count == k else { fatalError("Bad input") }

let result = minTime(roads: roads, machines: machines)

fileHandle.write(String(result).data(using: .utf8)!)
fileHandle.write("\n".data(using: .utf8)!)
