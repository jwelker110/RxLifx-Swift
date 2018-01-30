/*

Copyright 2017 Florian Sprenger

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

*/

import Foundation
import RxLifx
import LifxDomain
import RxSwift

public class DeviceSetGroupCommand {
    public class func create(light: Light, group: [UInt8], label: String, updatedAt:Date = Date(), ackRequired: Bool = false, responseRequired: Bool = false) -> Observable<Result<StateGroup>> {
        let group = LightGroup(id: group.pad(length: 16, e: 48), label: label.padding(toLength: 32, withPad: "", startingAt: 0), updatedAt: updatedAt)
        let message = Message.createMessageWithPayload(SetGroup(group: group.id, label: group.label, updated_at: UInt64(group.updatedAt.timeIntervalSince1970 * 100_000_000)), target: light.target, source: light.lightSource.source)
        message.header.ackRequired = ackRequired
        message.header.responseRequired = responseRequired
        return AsyncLightCommand.sendMessage(lightSource: light.lightSource, light: light, message: message, sideEffect: {light.group.updateFromClient(value: group)})
    }
}
