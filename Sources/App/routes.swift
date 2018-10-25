import Vapor
import PushNotifications
/// Register your application's routes here.
public func routes(_ router: Router) throws {

    router.get("push") { req -> String in
        do {
            try PushNotificationService.send(message: "Hello, new pizza offers are available!")
            return "Push Success"
        } catch {
            return "Push Failed"
        }
    }


    router.post(PizzaOffer.self, at: "push/offer/") { req, data -> String in
        do {
            try PushNotificationService.send(message: "Hello, \(data.pizzaName) has this offer: \(data.pizzaOffer)")
            return "Push Success"
        } catch {
            return "Push Failed"
        }
    }
}



struct PizzaOffer: Content {
    let pizzaName: String
    let pizzaOffer: String
}

class PushNotificationService {

    class func send(message: String) throws {
        let pushNotifications = PushNotifications(instanceId: "6b87bf51-26e3-4117-a312-281c64817f0b" , secretKey:"0B6D73FAEBFC996A863B91B7F5AB9555E1A96042F9AA645E4334F44E4DE08FD6")
        let interests = ["pizza"]
        let publishRequest = [
            "apns": [
                "aps": [
                    "alert": [
                        "title": "Pizza Offer",
                        "body": message
                    ]
                ]
            ]
        ]
        try pushNotifications.publish(interests, publishRequest, completion: { publishID in
            print("Published \(publishID)")
        })
    }
}
