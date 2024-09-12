//
//  DateFormatter.swift
//  AvitoInternship
//
//  Created by Владимир on 12.09.2024.
//

import Foundation

extension DateFormatter {
    func convertToReadableFormat(isoDate: String) -> String? {
        let dateFormatter = ISO8601DateFormatter()
        if let date = dateFormatter.date(from: isoDate) {
            let readableFormatter = DateFormatter()
            readableFormatter.dateStyle = .medium
            readableFormatter.timeStyle = .short
            readableFormatter.locale = Locale.current
            return readableFormatter.string(from: date)
        } else {
            return nil
        }
    }
}
