import Foundation

extension DateFormatter {
    convenience init(format: String) {
        self.init()
        self.dateFormat = format
    }
}

extension Date: Strideable {
    public func distance(to other: Date) -> TimeInterval {
        return other.timeIntervalSinceReferenceDate - self.timeIntervalSinceReferenceDate
    }
    public func advanced(by n: TimeInterval) -> Date {
        return self + n
    }
}

extension Date {
    func weekday() -> String {
        var formatter = DateFormatter(format: "eeee")
        return formatter.string(from: self)
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

struct Semester {
    let startDate: Date
    let endDate: Date
    let inFormatter = DateFormatter(format: "yyyy-MM-dd")
    let outFormatter = DateFormatter(format: "eeee, MMMM d")
    let classDays: [String]
    var offDays: [Date] = []
    init?(starts: String, ends: String, classDays: [String]) {
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
            if classDays.contains(date.weekday()) && !offDays.contains(date) {
                out.append(outFormatter.string(from: date))
            }
        }
        return out
    }
}

var sampleSemest = Semester(starts: "2019-02-01", ends: "2019-02-27", classDays: ["Monday", "Tuesday"])!
sampleSemest.addHoliday(startDate: "2019-02-15", endDate: "2019-02-24")
sampleSemest
let foo = sampleSemest.validDates()
