import Foundation

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

print(convertDateFormat(dateString: "2014-07-15", inFormat: "yyyy-MM-dd", outFormat: "eeee, MMMM d"))

struct Semester {
    let startDate: Date
    let endDate: Date
    let inFormat = "yyyy-MM-dd"
    let outFormat = "eeee, MMMM d"
    let inFormatter: DateFormatter
    let outFormatter: DateFormatter
    var offDays: [Date] = []
    init?(starts: String, ends: String) {
        var inFormatter = DateFormatter()
        inFormatter.dateFormat = inFormat
        self.inFormatter = inFormatter
        var outFormatter = DateFormatter()
        outFormatter.dateFormat = outFormat
        self.outFormatter = outFormatter
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
}

var sampleSemest = Semester(starts: "2014-07-15", ends: "2014-07-19")!
let bogusSemest = Semester(starts: "2014-07-20", ends: "2014-07-19")
let otherBogusSemest = Semester(starts: "2014-14-20", ends: "2014-07-19")
sampleSemest.addHoliday(singleDate: "2014-07-16")