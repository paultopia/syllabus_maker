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
    let startDate: Date?
    let endDate: Date?
    let inFormat = "yyyy-MM-dd"
    let outFormat = "eeee, MMMM d"
    init?(starts: String, ends: String) {
        var formatter = DateFormatter()
        formatter.dateFormat = inFormat
        if let sd = formatter.date(from: starts), let ed = formatter.date(from: ends) {
            self.startDate = sd
            self.endDate = ed
        } else {
            return nil
        }
    }
}

let sampleSemest = Semester(starts: "2014-07-15", ends: "2014-07-19")
