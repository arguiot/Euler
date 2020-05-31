//
//  DateTime.swift
//  Euler
//
//  Created by Arthur Guiot on 2020-05-31.
//

import Foundation

public extension Tables {
    // MARK: Date & Time
    
    /// Tables' original date
    internal var d1900: Date {
        var dateComponents = DateComponents()
        dateComponents.year = 1900
        dateComponents.month = 0
        dateComponents.day = 1
        let userCalendar = Calendar.current // user calendar
        guard let time = userCalendar.date(from: dateComponents) else { return Date(timeIntervalSince1970: -70*365.2425*24*60*60) }
        return time
    }
    
    /// Week starts, for easier computation
    internal var WEEK_STARTS: [Int?] {
        return [
            nil,
            0,
            1,
            nil,
            nil,
            nil,
            nil,
            nil,
            nil,
            nil,
            nil,
            nil,
            1,
            2,
            3,
            4,
            5,
            6,
            0
        ]
    }
    
    /// Types of week
    internal var WEEK_TYPES: [[Int]] {
        return [
            [],
            [1, 2, 3, 4, 5, 6, 7],
            [7, 1, 2, 3, 4, 5, 6],
            [6, 0, 1, 2, 3, 4, 5],
            [],
            [],
            [],
            [],
            [],
            [],
            [],
            [7, 1, 2, 3, 4, 5, 6],
            [6, 7, 1, 2, 3, 4, 5],
            [5, 6, 7, 1, 2, 3, 4],
            [4, 5, 6, 7, 1, 2, 3],
            [3, 4, 5, 6, 7, 1, 2],
            [2, 3, 4, 5, 6, 7, 1],
            [1, 2, 3, 4, 5, 6, 7]
        ]
    }
    
    /// Type of weekend
    internal var WEEKEND_TYPES: [[Int]?] {
        return [
          [],
          [6, 0],
          [0, 1],
          [1, 2],
          [2, 3],
          [3, 4],
          [4, 5],
          [5, 6],
          nil,
          nil,
          nil,
          [0, 0],
          [1, 1],
          [2, 2],
          [3, 3],
          [4, 4],
          [5, 5],
          [6, 6]
        ]
    }
    
     /// Encapsulate the logic to use date format strings
     internal struct DateFormats {

        /// This is the built-in list of all supported formats for auto-parsing of a string to a date.
        internal static let builtInAutoFormat: [String] =  [
            DateFormats.iso8601,
            DateFormats.extended,
            DateFormats.altRSS,
            DateFormats.rss,
            DateFormats.httpHeader,
            DateFormats.standard,
            DateFormats.sql,
            "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'",
            "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'",
            "yyyy-MM-dd'T'HH:mm:ss.SSSZ",
            "yyyy-MM-dd HH:mm:ss",
            "yyyy-MM-dd HH:mm",
            "yyyy-MM-dd",
            "h:mm:ss A",
            "h:mm A",
            "MM/dd/yyyy",
            "MMMM d, yyyy",
            "MMMM d, yyyy LT",
            "dddd, MMMM D, yyyy LT",
            "yyyyyy-MM-dd",
            "yyyy-MM-dd",
            "yyyy-'W'ww-E",
            "GGGG-'['W']'ww-E",
            "yyyy-'W'ww",
            "GGGG-'['W']'ww",
            "yyyy'W'ww",
            "yyyy-ddd",
            "HH:mm:ss.SSSS",
            "HH:mm:ss",
            "HH:mm",
            "HH"
        ]

        /// This is the ordered list of all formats SwiftDate can use in order to attempt parsing a passaed
        /// date expressed as string. Evaluation is made in order; you can add or remove new formats as you wish.
        /// In order to reset the list call `resetAutoFormats()` function.
        internal static var autoFormats: [String] = DateFormats.builtInAutoFormat

        /// Default ISO8601 format string
        internal static let iso8601: String = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"

        /// Extended format
        internal static let extended: String = "eee dd-MMM-yyyy GG HH:mm:ss.SSS zzz"

        /// The Alternative RSS formatted date "d MMM yyyy HH:mm:ss ZZZ" i.e. "09 Sep 2011 15:26:08 +0200"
        internal static let altRSS: String = "d MMM yyyy HH:mm:ss ZZZ"

        /// The RSS formatted date "EEE, d MMM yyyy HH:mm:ss ZZZ" i.e. "Fri, 09 Sep 2011 15:26:08 +0200"
        internal static let rss: String = "EEE, d MMM yyyy HH:mm:ss ZZZ"

        /// The http header formatted date "EEE, dd MMM yyyy HH:mm:ss zzz" i.e. "Tue, 15 Nov 1994 12:45:26 GMT"
        internal static let httpHeader: String = "EEE, dd MMM yyyy HH:mm:ss zzz"

        /// A generic standard format date i.e. "EEE MMM dd HH:mm:ss Z yyyy"
        internal static let standard: String = "EEE MMM dd HH:mm:ss Z yyyy"

        /// SQL date format
        internal static let sql: String = "yyyy-MM-dd'T'HH:mm:ss.SSSX"

        /// Reset the list of auto formats to the initial settings.
        internal static func resetAutoFormats() {
            autoFormats = DateFormats.builtInAutoFormat
        }

        /// Parse a new string optionally passing the format in which is encoded. If no format is passed
        /// an attempt is made by cycling all the formats set in `autoFormats` property.
        ///
        /// - Parameters:
        ///   - string: date expressed as string.
        ///   - suggestedFormat: optional format of the date expressed by the string (set it if you can in order to optimize the parse task).
        ///   - region: region in which the date is expressed.
        /// - Returns: parsed absolute `Date`, `nil` if parse fails.
        internal static func parse(string: String, format: String?) -> Date? {
            let formats = (format != nil ? [format!] : DateFormats.autoFormats)
            return DateFormats.parse(string: string, formats: formats)
        }

        internal static func parse(string: String, formats: [String]) -> Date? {
            let formatter = DateFormatter()

            var parsedDate: Date?
            for format in formats {
                formatter.dateFormat = format
                if let date = formatter.date(from: string) {
                    parsedDate = date
                    break
                }
            }
            return parsedDate
        }
    }
    
    internal func serial(date time: Date) -> BigDouble {
        let getTime = time.timeIntervalSince1970 * 1000
        let returnDateTime: BigDouble = 25569.0 + (getTime / (1000 * 60 * 60 * 24))
        return BigDouble(returnDateTime.rounded()) ?? returnDateTime
    }
    
    internal func date(serial: BigDouble) -> Date {
        guard let interval = (serial - BN(25569) * BN(86400)).asDouble() else { return Date() }
        let date = Date(timeIntervalSince1970: interval)
        return date
    }
    
    /// The DATE function returns the sequential serial number that represents a particular date.
    /// - Parameters:
    ///   - year: The year of your date
    ///   - month: The month of your date
    ///   - day: The day of your date
    /// - Returns: Serial Date
    func DATE(_ year: Int, _ month: Int, _ day: Int) throws -> BigDouble {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.timeZone = TimeZone(abbreviation: "UTC")
        let userCalendar = Calendar.current // user calendar
        guard let time = userCalendar.date(from: dateComponents) else { throw TablesError.Arguments }
        return serial(date: time)
    }
    
    /// The DATEVALUE function converts a date that is stored as text to a serial number.
    ///
    /// For example, the formula =DATEVALUE("1/1/2008") returns 39448, the serial number of the date 1/1/2008. Remember, though, that your computer's system date setting may cause the results of a DATEVALUE function to vary from this example
    /// The DATEVALUE function is helpful in cases where a worksheet contains dates in a text format that you want to filter, sort, or format as dates, or use in date calculations.
    /// - Parameter str: Text that represents a date in an Euler date format, or a reference to a cell that contains text that represents a date in an Euler date format. For example, "1/30/2008" is a text string within quotation marks that represent a date.
    /// - Returns: Serial Date
    func DATEVALUE(_ str: String) throws -> BigDouble {
        guard let date = DateFormats.parse(string: str, format: nil) else { throw TablesError.Arguments }
        return serial(date: date)
    }
    internal func daysBetween(firstDate: Date, secondDate: Date) -> Int {
        let calendar = Calendar.current

        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: firstDate)
        let date2 = calendar.startOfDay(for: secondDate)

        let components = calendar.dateComponents([.day], from: date1, to: date2)
        return components.day ?? 0
    }
    internal func isLeap(year: Int) -> Bool {
        guard year % 4 == 0 else { return false }
        guard year % 100 == 0 else { return true }
        guard year % 400 == 0 else { return false }
        return true
    }
    
    /// YEARFRAC calculates the fraction of the year represented by the number of whole days between two dates (the start and the end).
    ///
    /// For instance, you can use YEARFRAC to identify the proportion of a whole year's benefits, or obligations to assign to a specific term.
    /// - Parameters:
    ///   - start: A date that represents the start date.
    ///   - end: A date that represents the end date.
    ///   - basis: The type of day count basis to use.
    /// - Returns: The proportion of the year
    func YEARFRAC(start: BigDouble, end: BigDouble, basis: Int = 0) throws -> BigDouble {
        let start = date(serial: start)
        let end = date(serial: end)
        
        let calendar = Calendar.current
        let start_components = calendar.dateComponents([.day, .month, .year], from: start)
        guard var sd = start_components.day else { return 0 }
        guard var sm = start_components.month else { return 0 }
        sm += 1 // Compensation
        guard let sy = start_components.year else { return 0 }
        let end_components = calendar.dateComponents([.day, .month, .year], from: end)
        guard var ed = end_components.day else { return 0 }
        guard var em = end_components.month else { return 0 }
        em += 1 // Compensation
        guard let ey = end_components.year else { return 0 }
        
        switch basis {
        case 0:
            // US (NASD) 30/360
            if (sd == 31 && ed == 31) {
              sd = 30;
              ed = 30;
            } else if (sd == 31) {
              sd = 30;
            } else if (sd == 30 && ed == 31) {
              ed = 30;
            }
            let p1 = ed + em * 30 + ey * 360
            let p2 = sd + sm * 30 + sy * 360
            return BN(p1 - p2) / BN(360)
        case 1:
            // Actual/actual
            var ylength = 365
            if isLeap(year: sy) || isLeap(year: ey) {
                ylength = 366
            }
            return BigDouble(daysBetween(firstDate: start, secondDate: end) / ylength)
        case 2:
            // Actual/360
            return BigDouble(daysBetween(firstDate: start, secondDate: end) / 360)
        case 3:
            // Actual/365
            return BigDouble(daysBetween(firstDate: start, secondDate: end) / 365)
        case 4:
            // European 30/360
            let p1 = ed + em * 30 + ey * 360
            let p2 = sd + sm * 30 + sy * 360
            return BN(p1 - p2) / BN(360)
        default:
            throw TablesError.Arguments
        }
    }
}
