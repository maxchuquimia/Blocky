//
//  MessageFilterExtension.swift
//  MessageFilter
//
//  Created by Max Chuquimia on 15/9/20.
//  Copyright © 2020 Chuquimian Productions. All rights reserved.
//

import IdentityLookup

final class MessageFilterExtension: ILMessageFilterExtension {

    let interpreter = AggregateFilterInterpreter()

}

extension MessageFilterExtension: ILMessageFilterQueryHandling {

    func handle(_ queryRequest: ILMessageFilterQueryRequest, context: ILMessageFilterExtensionContext, completion: @escaping (ILMessageFilterQueryResponse) -> Void) {
        let response = ILMessageFilterQueryResponse()
        response.action = .none
        
        if let message = queryRequest.messageBody {
            if interpreter.isSpam(message: message) {
                response.action = .filter
            }
        }

        completion(response)
    }

}
