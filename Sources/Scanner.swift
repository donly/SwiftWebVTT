import Foundation

internal class CustomScanner {
    private let scanner: Scanner
    init(string: String) {
        scanner = Scanner(string: string)
        scanner.charactersToBeSkipped = nil
    }
    
    var scanLocation: String.Index {
        get { return scanner.currentIndex }
        set { scanner.currentIndex = newValue }
    }
    var isAtEnd: Bool { return scanLocation == scanner.string.endIndex }
    
    @discardableResult
    func scanUpToCharacters(from set: CharacterSet, thenSkip skipCount: Int = 0) -> String? {
        let string = scanner.scanUpToCharacters(from: set)
        if string != nil, skipCount > 0 { skip(skipCount) }
        return string
    }
    
    @discardableResult
    func scanCharacters(from set: CharacterSet, thenSkip skipCount: Int = 0) -> String? {
        let string = scanner.scanCharacters(from: set)
        if string != nil, skipCount > 0 { skip(skipCount) }
        return string
    }
    
    func scanInt(hexadecimal: Bool = false) -> Int? {
        switch hexadecimal {
        case true:
            let allowedSet = CharacterSet(charactersIn: "0123456789ABCDEFabcdef")
            guard let text = scanner.scanCharacters(from: allowedSet) else { break }
            let scanner = Scanner(string: "0x\(text)")
            var value: UInt64 = 0
            guard scanner.scanHexInt64(&value) else { break }
            return Int(value)
        case false:
            guard let text = scanner.scanCharacters(from: .decimalDigits) else { break }
            return Int(text)
        }
        return nil
    }
    
    func scanCharacter() -> Character? {
        return peekCharacter(thenSkip: true)
    }
    
    func scan(_ count: Int) -> String? {
        return peek(count, thenSkip: true)
    }
    
    func peek(_ count: Int, thenSkip: Bool = false) -> String? {
        guard !isAtEnd else { return nil }
        let count = min(count,  scanner.string.distance(from: scanLocation, to: scanner.string.endIndex))
        let start = scanLocation
        let end = scanner.string.index(scanLocation, offsetBy: count)
        if thenSkip { scanLocation = scanner.string.index(scanLocation, offsetBy: count) }
        return String(scanner.string[start..<end])
    }
    
    func peekCharacter(thenSkip: Bool = false) -> Character? {
        guard !isAtEnd else { return nil }
        let c = scanner.string[scanLocation]
        if thenSkip { scanLocation = scanner.string.index(scanLocation, offsetBy: 1) }
        if let scalar = Unicode.Scalar(String(c)) { return Character(scalar) }
        return nil
    }
    
    func skip(_ count: Int) {
        if !scanner.isAtEnd {
            scanLocation = scanner.string.index(scanLocation, offsetBy: count)
        }
    }
}

