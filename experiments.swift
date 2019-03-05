import Foundation

extension Date: Strideable {
    public func distance(to other: Date) -> TimeInterval {
        return other.timeIntervalSinceReferenceDate - self.timeIntervalSinceReferenceDate
    }
    public func advanced(by n: TimeInterval) -> Date {
        return self + n
    }
}

func dateSpan(from: Date, to: Date) -> [Date] {
    let dayDurationInSeconds = 60*60*24
    var out: [Date] = []
    for date in stride(from: from, to: to, by: TimeInterval(dayDurationInSeconds)) {
        out.append(date)
    }
    return out
}

func convertDateFormat(dateString: String, inFormat: String, outFormat: String) -> String? {
    var inFormatter = DateFormatter()
    inFormatter.dateFormat = inFormat
    var outFormatter = DateFormatter()
    outFormatter.dateFormat = outFormat
    if let date = inFormatter.date(from: dateString) {
        return outFormatter.string(from: date)
    }
    return nil
}

convertDateFormat(dateString: "2014-07-15", inFormat: "yyyy-MM-dd", outFormat: "eeee, MMMM d")

struct Semester {
    let startDate: Date
    let endDate: Date
    let inFormat = "yyyy-MM-dd"
    let outFormat = "eeee, MMMM d"
    let inFormatter: DateFormatter
    let outFormatter: DateFormatter
    let classDays: [String]
    var offDays: [Date] = []
    init?(starts: String, ends: String, classDays: [String]) {
        var inFormatter = DateFormatter()
        inFormatter.dateFormat = inFormat
        self.inFormatter = inFormatter
        var outFormatter = DateFormatter()
        outFormatter.dateFormat = outFormat
        self.outFormatter = outFormatter
        self.classDays = classDays
        if let sd = inFormatter.date(from: starts), let ed = inFormatter.date(from: ends) {
            guard ed > sd else {return nil}
            self.startDate = sd
            self.endDate = ed
        } else {
            return nil
        }
    }
    mutating func addHoliday(singleDate: String) {
        if let date = inFormatter.date(from: singleDate) {
            self.offDays.append(date)
        }
    }
    mutating func addHoliday(severalDates: [String]) {
        for dateString in severalDates {
            if let date = inFormatter.date(from: dateString) {
                self.offDays.append(date)
            }
        }
    }
    mutating func addHoliday(startDate: String, endDate: String) {
        if let start = inFormatter.date(from: startDate), let end = inFormatter.date(from: endDate) {
            if end > start {
                for date in dateSpan(from: start, to: end) {
                    self.offDays.append(date)
                }
                self.offDays.append(end)
            }
        }
    }
    func validDates() -> [String] {
        var out = [String]()
        for date in dateSpan(from: startDate, to: endDate) {
            if !offDays.contains(date) {
                out.append(outFormatter.string(from: date))
            }
        }
        return out
    }
}

var sampleSemest = Semester(starts: "2014-07-15", ends: "2014-07-30", classDays: ["Monday"])!
sampleSemest.addHoliday(startDate: "2014-07-16", endDate: "2014-07-20")
sampleSemest
let foo = sampleSemest.validDates()
