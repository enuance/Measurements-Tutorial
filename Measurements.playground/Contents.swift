/**
 Measurements Tutorial
 
 Learn Swift SD March 21, 2018
 Clone me from https://github.com/enuance/Measurements-Tutorial.git
 */

import UIKit
import PlaygroundSupport

//Comment this out to run execution
PlaygroundPage.current.finishExecution()

//1. What Are Measurements?

//2. What pain points do Measurements solve?

//3. Example of pain point: Radians & Degrees.
func radians(degrees: Double) -> Double{
    return degrees * (Double.pi / 180)
}

//4. How to create a Measurement.
var degress = Measurement(value: 12, unit: UnitAngle.degrees)

//5. What can Measurements do?

//Returns new Measurment
degress.converted(to: .radians) * 3

//Mutates the Measurement Struct
degress.convert(to: .radians)

//6. How to create a custom Measurement Type: UnitBromance.
class UnitBromance: Dimension{
    //Static properties as the available UnitBromances
    static let handshake = UnitBromance(symbol: "hshk", converter: UnitConverterLinear(coefficient: 1))
    static let fistbump = UnitBromance(symbol: "fbmp", converter: UnitConverterLinear(coefficient: 5))
    static let chestBump = UnitBromance(symbol: "cbmp", converter: UnitConverterLinear(coefficient: 10))
    static let broHug = UnitBromance(symbol: "bhug", converter: UnitConverterLinear(coefficient: 25))
    static let cryOnMyShoulder = UnitBromance(symbol: "cry", converter: UnitConverterLinear(coefficient: 50))
    
    //Overriding the class func to allow Conversion
    override public class func baseUnit() -> UnitBromance{
        return UnitBromance.handshake
    }
}


//Using our custom UnitBromance
let fistBump = Measurement(value: 20, unit: UnitBromance.fistbump)
fistBump.converted(to: .chestBump)
fistBump.converted(to: .cryOnMyShoulder)

//7. How to customize Measurements to your liking: ie 12.feet.toMeters.cgValue

//Initial protocol
protocol SchemaShiftable{
    var entrySchema: Double{get}
    var degrees: Measurement<UnitAngle>{get}
    var radians: Measurement<UnitAngle>{get}
}

//Provide default implementation
extension SchemaShiftable{
    var degrees: Measurement<UnitAngle>{return Measurement(value: entrySchema, unit: UnitAngle.degrees)}
    var radians: Measurement<UnitAngle>{return Measurement(value: entrySchema, unit: UnitAngle.radians)}
}

//Allows the Int type to have access to Measurment through SchemaShiftable
extension Int: SchemaShiftable{var entrySchema: Double{return Double(self)}}

//Allows Measurements to return a CGFloat
extension Measurement{var cgValue: CGFloat{return CGFloat(value)}}

//Provides the Conversion methods to Measurments toUnitType properties
extension Measurement where UnitType: UnitAngle{
    private var mySelf: Measurement<UnitAngle>{return self as! Measurement<UnitAngle>}
    var toRadians: Measurement<UnitAngle>{return mySelf.converted(to: .radians)}
    var toDegrees: Measurement<UnitAngle>{return mySelf.converted(to: .degrees)}
}

//Example of new syntax
let something = 12.degrees.toRadians.cgValue


//8. Measurements in an Animated example.

let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 750))
containerView.backgroundColor = UIColor.lightGray
containerView.clipsToBounds = true

PlaygroundPage.current.liveView = containerView

let playView = UIView()

containerView.addSubview(playView)
playView.translatesAutoresizingMaskIntoConstraints = false

[playView.widthAnchor.constraint(equalToConstant: 100),
 playView.heightAnchor.constraint(equalToConstant: 100),
 playView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
 playView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
    ].forEach{$0.isActive = true}

playView.backgroundColor = UIColor.purple
playView.layer.cornerRadius = 25
playView.clipsToBounds = true

let rotation = CGAffineTransform(rotationAngle: 180.degrees.toRadians.cgValue)

UIView.animate(withDuration: 1){playView.transform = rotation}


