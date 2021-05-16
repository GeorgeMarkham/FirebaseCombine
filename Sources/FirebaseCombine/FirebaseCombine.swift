import Firebase

public struct FirebaseCombine {
    public static let shared: FirebaseCombine = .init()
    
    public func initialize() {
        FirebaseApp.configure()
    }
}
