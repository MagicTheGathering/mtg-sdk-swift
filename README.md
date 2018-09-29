## MTGSDKSwift
#### Magic: The Gathering SDK - Swift
##### A lightweight framework that makes interacting with the magicthegathering.io api quick, easy and safe.

<img src="https://img.shields.io/cocoapods/p/MTGSDKSwift.svg?style=flat">
<img src="https://cocoapod-badges.herokuapp.com/v/MTGSDKSwift/badge.png">
<img src="https://img.shields.io/cocoapods/l/MTGSDKSwift.svg?style=flat">


#### Installation

##### Install with Cocoapods
```ruby
pod 'MTGSDKSwift'
```

##### Install with Carthage

* copy the Cartfile above into your project folder
* in terminal, navigate to your project folder and run the command 'carthage update'
* drag the .framework file into your project in xcode. It will be in the newly created Carthage/Build/iOS folder in your project directory
* drag the framework to the Linked Frameworks And Libraries slot and Embedded Frameworks slot

You can also just download this project and drag the framework file into your project instead of messing with Carthage.


#### Use

````swift
import MTGSDKSwift

let magic = Magic()
````
You can

````swift
fetchCards(_:completion:)
fetchSets(_:completion:)
fetchJSON(_:completion:)
fetchImageForCard(_:completion:)
generateBoosterForSet(_:completion:)
````
##### First: Configure your search parameters
Parameters can be constructed as follows:

````swift
let color = CardSearchParameter(parameterType: .colors, value: "black")
let cmc = CardSearchParameter(parameterType: .cmc, value: "2")
let setCode = CardSearchParameter(parameterType: .set, value: "AER")
````

Search parameters come in two flavors: Card and SetSearchParameter. Each one contains an enum holding the valid query names for either cards or sets searches.

Desired search paramters are grouped into an array and passed to the fetch method.

````swift
magic.fetchCards(withParameters: [color,cmc,setCode]) {
	cards, error in

	if let error = error {
		//handle your error
	}

	for c in cards! {
		print(c.name)
	}

}
````


The completion contains an optional array of the appropriate type and an optional error type enum, NetworkError. Details for this enum are further down.

The default number of results that will be retreived is 12. This can be set to 100, and for more results the number of pages must be increased. Page number and page size can be set by calling

````swift
magic.pageTotal = "1"
//and
magic.pageSize = "9000"
````
Additionally, some helpful console messages such as the URL string that is being sent to the server, how many cards or sets were retreived, and a message indicating that the network query has begun can be enabled by calling a static method on Magic.

````swift
Magic.enableLogging = true
````
##### Fetching unparsed json
fetchJSON(_:completion:) can be used to get the unparsed json in case you want to do something specific with it.

##### Fetching The Card Image

fetchImageForCard works similarly to fetchCards, and will retreive the card image of the card you pass to it, if one is available. Some promo and special cards do not contain imageURL data. NetworkError will communicate this if true. Notably, cards in sets whose set code is prepended with "p" (pMEI, pGMD etc) may be missing this data. Most promotional cards will be missing image data as well.

__Important note on image fetching:__ the card imageUrl refers to an HTTP address (gathere.wizards.com), which are as of ios9 by default blocked by App Transport Security. In order for image fetch to succede you must paste the following entry into your plist. This can also be added through the ios Target Properties menu but this is just quicker. [StackOverflow has a more detailed description of this issue.](http://stackoverflow.com/questions/31254725/transport-security-has-blocked-a-cleartext-http)

````xml
 <key>NSAppTransportSecurity</key>
    <dict>
        <key>NSExceptionDomains</key>
        <dict>
            <key>wizards.com</key>
            <dict>
                <key>NSIncludesSubdomains</key>
                <true/>
                <key>NSTemporaryExceptionAllowsInsecureHTTPLoads</key>
                <true/>
                <key>NSTemporaryExceptionMinimumTLSVersion</key>
                <string>TLSv1.1</string>
            </dict>
        </dict>
    </dict>
````

##### Simulating a Booster

generateBoosterForSet(_:completion:) will return an array of [Card] which simulates what one might find opening a physical booster.


#### class - Card
````swift
public var name: String?
public var names: [String]?
public var manaCost: String?
public var cmc: Int?
public var colors: [String]?
public var colorIdentity: [String]?
public var type: String?
public var supertypes: [String]?
public var types: [String]?
public var subtypes: [String]?
public var rarity: String?
public var set: String?
public var text: String?
public var artist: String?
public var number: String?
public var power: String?
public var toughness: String?
public var layout: String?
public var multiverseid: Int?
public var imageURL: String?
public var rulings: [[String:String]]?
public var foreignNames: [[String:String]]?
public var printings: [String]?
public var originalText: String?
public var originalType: String?
public var id: String?
public var flavor: String?

public static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.id == rhs.id
    }
````
Not all properties will exist for all mtg cards.

The ID property is a unique identifier given to all cards and is useful for conforming Card to Equatable for example. Card names are not reliable for use as identifiers: There will be multiple "Serra Angel"s for example, one for each printing, but each one will have a unique ID.

The following static function is provided for convienence in order to filter duplicate cards out of an array of [Card], if you have results containing the same card in multiple printings.

````swift
FilterResults.removeDuplicateCardsByName(_:) -> [Card]
````

#### class CardSet
````swift
public var code: String?
public var name: String?
public var block: String?
public var type: String?
public var border: String?
public var releaseDate: String?
public var magicCardsInfoCode: String?
public var booster: [[String]]?
````
#### class CardSearchParameter, available parameters

````swift
case name
case cmc
case colors
case type
case supertypes
case subtypes
case rarity
case text
case set
case artist
case power
case toughness
case multiverseid
case gameFormat
````

* colors
	* "red,black,white" in quotes will return exact match
	* red,black,white will include multicolors
	* red|black|white will not return multicolors
	* red,black|white will return multicolor red and black, or red and white cards

see the official API documentation for more information about expected inputs and return -
[magicthegathering.io docs](http://docs.magicthegathering.io/#overview)

#### class SetSearchParameter, vailable parameters
````swift
case name
case block
````

#### enum NetworkError

````swift
public enum NetworkError: Error {
    case requestError(Error)
    case unexpectedHTTPResponse(HTTPURLResponse)
    case fetchCardImageError(String)
    case miscError(String)
}
````
* case requestError(Error)
	*  will contain the error generated by the dataTask completion if it exists
* case unexpectedHTTPResponse(HTTPURLResponse)
	* will contain the HTTPresponse generated by dataTask completion if anything other than success 200..<300 is generated
* case fetchCardImageError(String)
	*  associated value will contain information about a failed image fetch
* case miscError(String)
	*  associated value will contain information about errors such as constructing URL failures

#### Typealiases
````swift
public typealias JSONResults = [String:Any]
public typealias JSONCompletionWithError = (JSONResults?, NetworkError?) -> Void
public typealias CardImageCompletion = (UIImage?, NetworkError?) -> Void
public typealias CardCompletion = ([Card]?, NetworkError?) -> Void
public typealias SetCompletion = ([CardSet]?, NetworkError?) -> Void
