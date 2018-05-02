import Foundation

public class DateHelper {
    private static let formatter = DateFormatter()

    public static func fromISO8601String(_ dateString: String) -> Date? {
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter.date(from: dateString)
    }

    public static func toISO8601String(_ date: Date) -> String {
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter.string(from: date)
    }
}
