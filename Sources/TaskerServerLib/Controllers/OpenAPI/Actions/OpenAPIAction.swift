//
//  OpenAPIAction.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 30.03.2018.
//

import Foundation
import PerfectHTTP
import Swiftgger

class OpenAPIAction: ActionProtocol {

    public var controllers: [ControllerProtocol]?

    public func getHttpMethod() -> HTTPMethod {
        return .get
    }

    public func getUri() -> String {
        return "/openapi"
    }

    public func getMetadataSummary() -> String {
        return "OpenAPI endpoint"
    }

    public func getMetadataDescription() -> String {
        return "Action for getting OpenAPI document."
    }

    public func handler(request: HTTPRequest, response: HTTPResponse) {
        let openAPIDocument = self.generateOpenAPIDocument()
        response.sendJson(openAPIDocument)
    }

    private func getAPIHttpMethod(from method: HTTPMethod) -> APIHttpMethod {
        switch method {
        case .get:
            return APIHttpMethod.get
        case .post:
            return APIHttpMethod.post
        case .put:
            return APIHttpMethod.put
        case .delete:
            return APIHttpMethod.delete
        case .patch:
            return APIHttpMethod.patch
        default:
            return APIHttpMethod.get
        }
    }

    private func generateOpenAPIDocument() -> OpenAPIDocument? {

        let openAPIBuilder = OpenAPIBuilder(
            title: "Tasker server",
            version: "1.0.0",
            description: "This is a sample server for task server application. Authorization is done by `JWT` token. " +
                "You can register in the system, then sign-in and use token from response for authorization.",
            termsOfService: "http://example.com/terms/",
            name: "Marcin Czachurski",
            email: "marcincz@email.com",
            url: URL(string: "http://medium.com/@mczachurski"),
            authorizations: [.jwt(description: "You can get token from *sign-in* action from *Account* controller.")]
        )

        if let apiControllers = self.controllers {
            for controller in apiControllers {

                var actions: [APIAction] = []
                for action in controller.getActions() {
                    let openAPIAction = APIAction(method: self.getAPIHttpMethod(from: action.getHttpMethod()), route: action.getUri(),
                                                  summary: action.getMetadataSummary(),
                                                  description: action.getMetadataDescription(),
                                                  parameters: action.getMetadataParameters(),
                                                  request: action.getMetadataRequest(),
                                                  responses: action.getMetadataResponses(),
                                                  authorization: action.getMetadataAuthorization() == AuthorizationPolicy.anonymous ? false : true
                    )

                    actions.append(openAPIAction)
                }

                _ = openAPIBuilder.addController(
                    APIController(name: controller.getMetadataName(), description: controller.getMetadataDescription(), actions: actions)
                )
            }
        }

        _ = openAPIBuilder.addServer(APIServer(url: "http://localhost:8181", description: "Main server"))
            .addServer(APIServer(url: "http://localhost:{port}/{basePath}", description: "Secure server", variables:
                [
                    APIVariable(name: "port", defaultValue: "80", enumValues: ["80", "443"], description: "Port to the API"),
                    APIVariable(name: "basePath", defaultValue: "v1", description: "Base path to the server API")
                ])
        )

        var document: OpenAPIDocument?
        do {
            document = try openAPIBuilder.build()
        } catch {
            print("Error...")
        }

        return document
    }
}
