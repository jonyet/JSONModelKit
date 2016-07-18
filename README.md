[![Cocoapods Compatible](https://img.shields.io/badge/pod-v1.0-blue.svg)](https://cocoapods.org/)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Platform](https://img.shields.io/badge/platform-ios%20%7C%20osx%20%7C%20tvos-lightgrey.svg)](https://github.com/AntonTheDev/JSONModelKit/)
[![License](https://img.shields.io/badge/license-MIT-343434.svg)](https://github.com/AntonTheDev/JSONModelKit/)

#JSONModelKit

##Introduction

JSONModelKit is an an extremely lightweight mapping framework that follows an API-Driven approach to stream line development. JSONModelKit differs from other frameworks by taking an API-first approach and mapping against the response up front, then generatting the model objects based on the definition, so there is one point of update anytime the API changes. 

By providing a single point of configuration, and driving the model definition against an API reponse, it makes it very easy to keep your model in sync with an API and streamline development.

##Features

- [X] Auto-Model Generation .json/.plists configuration files
- [X] String, Int, Double, Float, Bool, Array, Dictionary
- [X] Optional & Non-Optional Property Support:
	* Native Types: String, Int, Double, Float, Bool, Array, Dictionary
	* Collections Types: Array\<AnyObject\>, Dictionary\<String, AnyObject\>
	* Structs, Enums, Closures, Tuples via Transformations
- [X] Mapping Nested Values
- [X] Predefined Default Values

##Installation

* **Requirements** : XCode 7.3+, iOS 8.0+, OSX 10.9+, tvOS 9.0+
* [Installation Instructions](/documentation/installation.md)
* [Release Notes](/documentation/changelog.md)

##Communication

- If you **found a bug**, or **have a feature request**, open an issue.
- If you **need help** or a **general question**, use [Stack Overflow](http://stackoverflow.com/questions/tagged/json-mapperkit). (tag 'json-mapperkit')
- If you **want to contribute**, review the [Contribution Guidelines](/Documentation/CONTRIBUTING.md), and submit a pull request. 

##Basic Use

Once configured per the [Installation](/documentation/installation.md) instructions, run the build script once **⌘+B**. Navigate to your project directory and notice that the script generated the following inside the base directory of your project.

![alt tag](/documentation/readme_assets/folder_structure.png?raw=true)

All JSON Mappings will go into the Mappings directory from this point forward, and your Classes will be generated into the Model directory during build time. 

Note: Anytime a new mapping is added, remove the reference to the Model group folder within your project, then drag and drop the Model folder into your project. This only needed to be done when a new Class is defined. If the mapping changes on an existing Class, all the updates will be reflected automatically without any manual intervention.

#### Simple Example

Let look as a simple mapping that defined a class below in JSON.

```
Input File: JSOModelKit/Mappings/Business.json

{
	"uuid" : {						 
		"key" : "identifier",		 
		"type" : "Double",			 
		"nonoptional" : "true"		 
	},
	"businessName" : {
		"key" : "business_name",	
		"type" : "String"			
	},
	"ratings" : {
		"key" : "ratings",
		"type" : "Array",			
		"subtype" : "Float"			
	},
	"metaTags" : {
		"key" : "metadata.tags",	
		"type" : "Array",			
		"subtype" : "Float"			
	},
	"locations" : {
		"key" : "locations",
		"type" : "Array",			
		"subtype" : "Coordinate"	
	},
	"dateOpened" : {
		"key" : "grand_opening_date",		
		"type" : "Date",					
		"transformer" : "DateTransformer"
	}
}

```
Run the build script once **⌘+B**. and you will see that it generated the following files in the ourput directory.

![alt tag](/documentation/readme_assets/genrerated_folder_structure.png?raw=true)

Observe the internal file that was generated, all the properties are complete


```
class _Business  {

	var metaTags : [Float]?
	var ratings : [Float]?
	var locations : [Coordinate]?
	var dateOpened : Date?
	var businessName : String?
	
	var uuid : Double
	
	..........
	
}

```





```
Input File: JSOModelKit/Mappings/Business.json

{
	"uuid" : {						 // The property to be generated
		"key" : "identifier",		 // The JSON Key In the Response
		"type" : "Double",			 // The property Type
		"nonoptional" : "true"		 // Marks the property as non-optional
	},
	"businessName" : {
		"key" : "business_name",	
		"type" : "String"			// Support for String, Int, Float, Double, Bool
	},
	"ratings" : {
		"key" : "ratings",
		"type" : "Array",			// Support for Arrays and Dictionaries
		"subtype" : "Float"			// Defining a collection type specify the subtype
	},
	"metaTags" : {
		"key" : "metadata.tags",	// Support for mapping nested keys
		"type" : "Array",			// Support for Arrays and Dictionaries
		"subtype" : "Float"			// Defining a collection type specify the subtype
	},
	"locations" : {
		"key" : "locations",
		"type" : "Array",			// Support for Arrays and Dictionaries
		"subtype" : "Coordinate"	// Support for mapping custom types already mapped
	},
	"dateOpened" : {
		"key" : "grand_opening_date",		
		"type" : "Date",					// Non-Default supported datatype
		"transformer" : "DateTransformer"	// Custom Trasformer, that returns a Date
	}
}

```


####Initialization with Dictionary

Once configured per the [Installation](/documentation/installation.md) instructions:

1. Create a plist model mapping and place it in the mapping folder defined during installation.
2. Build the target, navigate to the output directory defined during the installation process, and add the generated files to the project.
3. Map the data to an instance, call the fail-able initializer generated by JSONModelKit with the `Dictionary<String, AnyObject>` data to parse.

	```
let newInstance = TestModelObject(dataDictionary)
	```

####Update with Dictionary

Once an instance has been initialized, we can pass a new dictionary with values to update for the current instance by calling `updateWithDictionary(dictionary : Dictionary<String, AnyObject>?)`. Note that only the values which are being passed within will be updated, defaults values are ignored unline the initialization

```
let instance = TestModelObject(dataDictionary)
let newValuesDictionary = [... : ...]

// Updates the current values only with the new values received, defaults in mapping are ignored
instance.updateWithDictionary(newValuesDictionary)

```

## License

*JSONModelKit is released under the MIT license. See [License](/LICENSE.md) for details.*
