import UIKit

protocol AppViewModel {
    var didChangedState: ((StartViewModel.State)->Void)? { get set }
    var state: StartViewModel.State { get set }
    
    func updateState(state: StartViewModel.State)
}


final class StartViewModel: AppViewModel {
    
    enum State {
        case hasPassword
        case notRegistered
        case confirmPassword(String)
    }
    
    
    var didChangedState: ((StartViewModel.State)->Void)?
    
    var state: State = .notRegistered {
        didSet {
            self.didChangedState?(state)
        }
    }
    
    func updateState(state: State) {
        self.state = state
    }
    
}
