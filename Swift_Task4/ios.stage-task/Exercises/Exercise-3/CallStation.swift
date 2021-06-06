import Foundation

final class CallStation {
    private var usersList: [User] = []
    private var callsList: [Call] = []
}

extension CallStation: Station {
    func users() -> [User] {
        return usersList
    }
    
    func add(user: User) {
        if !(usersList.contains(user)) {
            usersList.append(user)
        }
    }
    
    func remove(user: User) {
        if let index = usersList.firstIndex(of: user) {
            usersList.remove(at: index)
        }
    }
    
    func execute(action: CallAction) -> CallID? {
        
        switch action {
        case .start(from: let incomingUser, to: let outgoingUser):
            guard users().contains(incomingUser) else {
                return nil
            }
            let call = Call(id: CallID(), incomingUser: incomingUser, outgoingUser: outgoingUser, status: .calling)
            if currentCall(user: outgoingUser)?.status == CallStatus.talk {
                let busyCall = Call(id: CallID(), incomingUser: incomingUser, outgoingUser: outgoingUser, status: .ended(reason: CallEndReason.userBusy))
                callsList.append(busyCall)
                return busyCall.id
            }
            callsList.append(call)
            if !(users().contains(outgoingUser)), let index = calls().firstIndex(where: { $0.id == call.id })  {
                let errorCall = Call(id: call.id, incomingUser: call.incomingUser, outgoingUser: call.outgoingUser, status: .ended(reason: CallEndReason.error))
                callsList[index] = errorCall
            }
            return call.id
            
        case .answer(from: let answeringUser):
            guard let index = calls().firstIndex(where: { $0.outgoingUser == answeringUser }) else { return nil }
            let call = callsList[index]
            if !(users().contains(answeringUser)) {
                let errorCall = Call(id: call.id, incomingUser: call.incomingUser, outgoingUser: answeringUser, status: .ended(reason: .error))
                callsList[index] = errorCall
                return nil
            }
            let updatedCall = Call(id: call.id, incomingUser: call.incomingUser, outgoingUser: answeringUser, status: .talk)
            callsList[index] = updatedCall
            return updatedCall.id
            
        case .end(from: let endingUser):
            guard let index = calls().firstIndex(where: { $0.outgoingUser == endingUser || $0.incomingUser == endingUser }) else { return nil }
            let call = callsList[index]
            var endReason: CallEndReason = .error
            if call.status == .calling {
                endReason = .cancel
            } else if call.status == .talk {
                endReason = .end
            } else if currentCall(user: call.outgoingUser)?.status == .talk {
                endReason = .userBusy
            }
            let updatedCall = Call(id: call.id, incomingUser: call.incomingUser, outgoingUser: call.outgoingUser, status: .ended(reason: endReason))
            callsList[index] = updatedCall
            return updatedCall.id
            
        default:
            return nil
        }
    }
    
    func calls() -> [Call] {
        return callsList
    }
    
    func calls(user: User) -> [Call] {
        let callsOfUser = callsList.filter{ $0.incomingUser == user || $0.outgoingUser == user }
        return callsOfUser
    }
    
    func call(id: CallID) -> Call? {
        let call = callsList.first(where: { $0.id == id })
        return call
    }
    
    func currentCall(user: User) -> Call? {
        let call = callsList.first(where: { ($0.incomingUser == user || $0.outgoingUser == user) && ($0.status == .calling || $0.status == .talk) })
        return call
    }
}
