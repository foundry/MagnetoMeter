__Magnet-O-Meter__

Magnetometer test app

Demonstrates the various ways of getting Magnetometer and compass data.

Compatible with iPhone, iPad, iOS 5.1+
BEST on iPad as the interface is pretty crowded.

This is posted to support a lengthy Stack Overflow answer

It is hastily pulled from a larger app, hence the odd bit of code cruft around the edges...

![enter image description here][1]


__interface__   
RED arrow  
showing CLHeading.magneticHeading - the iOS 'compass' measure  
GREEN arrow and progress bars  
CLHeading.[x|y|z]  
BLUE arrow and progress bars  
CMDevice.calibratedMagneticField.field  
YELLOW arrow and progress bars  
CMMagnetometer.[x|y|z] raw magentometer data  
PURPLE progress bars  
show difference between green and blue measures.

This is only accurate on a device positioned horizontally on a flat surface as it only uses the x and y magnetometer readings. The point of this app is to make sense of the Apple API's and to get a feel of how the magnetometer works. We could enhance it by correcting for device tilt - some kind of matrix multiplication with Core Motion's attitude rotation matrix - but we are not trying to demonstrate how to get the _best_ reading (Apple already provides that with their CLHeading `magneticHeading` parameter), but rather to show how the raw figures compare.




[__StackOverflow notes__](http://stackoverflow.com/questions/15380632/in-ios-what-is-the-difference-between-the-magnetic-field-values-from-the-core-l)

To unravel this I've spent a bit of time digging through the Apple docs.

There are three ways of obtaining magnetometer data

1/ [Core Motion  framework](http://developer.apple.com/library/ios/#documentation/CoreMotion/Reference/CoreMotion_Reference/_index.html)  
CMMotionManagers's [`CMMagnetometer`](http://developer.apple.com/library/ios/#documentation/CoreMotion/Reference/CMMagnetometerData_Class/Reference/Reference.html#//apple_ref/doc/c_ref/CMMagnetometerData) class

2/ Core Motion  framework  
[CMDeviceMotion](http://developer.apple.com/library/ios/#documentation/CoreMotion/Reference/CMDeviceMotion_Class/Reference/Reference.html#//apple_ref/doc/c_ref/CMDeviceMotion) `CMCalibratedMagneticField` property

3 / [Core Location framework](https://developer.apple.com/library/IOs/#documentation/CoreLocation/Reference/CLLocation_Class/CLLocation/CLLocation.html)  
CLLocationManager's `CLHeading`



1/  supplies 'raw' data from the magnetometer.  
2/ and 3/ return 'derived' data. The  numbers in both cases are similar (though not exactly the same).  

__Difference between Core Motion's CMMagnetometer and CMCalibratedMagneticField__

1/ and 2/ - both from the Core Motion framework - differ as follows:

CMDeviceMotion Class Reference

    @property(readonly, nonatomic) CMCalibratedMagneticField magneticField

>Discussion  
>The CMCalibratedMagneticField returned by this property gives you the total magnetic field in the device’s vicinity without device bias. Unlike the magneticField property of the CMMagnetometer class, these values reflect the earth’s magnetic field plus surrounding fields, minus device bias.

CMMagnetometer gives us raw data, CMCalibratedMagneticField is adjusted data.

__Difference between Core Motion's CMCalibratedMagneticField and Core Location's CLHeading__ 

The docs are not immediately clear on the difference between 2/ and 3/, but they do generate different numbers so let's do some digging….

__Core Location framework__   
__CLHeading__ 

From [Location Awareness Programming Guide](http://developer.apple.com/library/ios/#documentation/UserExperience/Conceptual/LocationAwarenessPG/GettingHeadings/GettingHeadings.html#//apple_ref/doc/uid/TP40009497-CH5-SW1)  

>Getting Heading-Related Events  

>Heading events are available to apps running on a device that contains a magnetometer. A magnetometer measures nearby magnetic fields emanating from the Earth and uses them to determine the precise orientation of the device. Although a magnetometer can be affected by local magnetic fields, such as those emanating from fixed magnets found in audio speakers, motors, and many other types of electronic devices, Core Location is smart enough to filter out fields that move with the device.

Here are the relevant `CLHeading` 'raw' properties  

    @property(readonly, nonatomic) CLHeadingComponentValue x
    @property(readonly, nonatomic) CLHeadingComponentValue y
    @property(readonly, nonatomic) CLHeadingComponentValue z
    
    
>The geomagnetic data (measured in microteslas) for the [x|y|z]-axis. (read-only)  
    This value represents the [x|y|z]-axis deviation from the magnetic field lines being tracked by the device.
    (_older versions of the docs add:_) The value reported by this property is normalized to the range -128 to +128.

I am not clear how a microtesla measurement can be 'normalized' (compressed? clipped?) to a range of +/-128 and still represent the unit it claims to measure. Perhaps that's why the sentence was removed from the docs. The units on an iPad mini do seem to conform to this kind of range, but the iPhone4S gives _CMMagnetometer_ readings in higher ranges, eg 200-500.
    
The API clearly expects you to use the derived properties:  

    @property(readonly, nonatomic) CLLocationDirection magneticHeading
    @property(readonly, nonatomic) CLLocationDirection trueHeading

which give stable N/S E/W compass readings in degrees (0 = North, 180 = South etc). For the true heading, other Core Location services are required (geolocation) to obtain the deviation of magnetic from true north.

Here is a snippet from the `CLHeading` header file

	/*
	 *  CLHeading
	 *  
	 *  Discussion:
	 *    Represents a vector pointing to magnetic North constructed from 
	 *    axis component values x, y, and z. An accuracy of the heading 
	 *    calculation is also provided along with timestamp information.
	 *  
	 *  x|y|z
	 *  Discussion:
	 *    Returns a raw value for the geomagnetism measured in the [x|y|z]-axis.


__Core Motion framework__  
 __CMDeviceMotion__  __CMCalibratedMagneticField__

	/*
	 *  magneticField
	 *  
	 *  Discussion:
	 *			Returns the magnetic field vector with respect to the device for devices with a magnetometer.
	 *			Note that this is the total magnetic field in the device's vicinity without device
	 *			bias (Earth's magnetic field plus surrounding fields, without device bias),
	 *			unlike CMMagnetometerData magneticField.
	 */
	@property(readonly, nonatomic) CMCalibratedMagneticField magneticField NS_AVAILABLE(NA,5_0);
	

		
__CMMagnetometer__



	 *  magneticField
	 *  
	 *  Discussion:
	 *    Returns the magnetic field measured by the magnetometer. Note
	 *        that this is the total magnetic field observed by the device which
	 *        is equal to the Earth's geomagnetic field plus bias introduced
	 *        from the device itself and its surroundings.
	 */
    @property(readonly, nonatomic) CMMagneticField magneticField;  

 

_CMMagneticField_  
This is the struct that holds the vector.   
It's the same for `CMDeviceMotion`'s calibrated magnetic field and `CMMagnetometer`'s uncalibrated version:
	

	/*  CMMagneticField - used in 
	 *  CMDeviceMotion.magneticField.field
	 *  CMMagnetometerData.magneticField
	 *  
	 *  Discussion:
	 *    A structure containing 3-axis magnetometer data.
	 *
	 *  Fields:
	 *    x:
	 *      X-axis magnetic field in microteslas.
	 *    y:
	 *      Y-axis magnetic field in microteslas.
	 *    z:
	 *      Z-axis magnetic field in microteslas.
	 
___
	 
The difference between 2/ and 3/ are hinted at here:

Core Location _CLHeading_
>Represents a vector pointing to magnetic North constructed from axis component values x, y, and z

> Core Location is smart enough to _filter out fields that move with the device_
 
Core Motion  _CMCalibratedMagneticField_
 > [represents] Earth's magnetic field _plus surrounding fields_, without device bias
 
 
So - according to the docs -  we have:

1/ _CMMagnetometer_  
Raw readings from the magnetometer

2/ _CMDeviceMotion (CMCalibratedMagneticField*) magneticField_  
Magnetometer readings corrected for device bias (onboard magnetic fields)

3/ _CLHeading [x|y|z]_  
Magnetometer readings corrected for device bias and filtered to eliminate local external magnetic fields (as detected by device movement - if the field moves with the device, ignore it; otherwise measure it)

__Testing the theory__


I have put a [Magnet-O-Meter demo app on gitHub](https://github.com/foundry/MagnetoMeter) which displays some of these differences. It's quite revealing to wave a magnet around your device when the app is running and watching how the various APIs react:

_CMMagnetometer_ doesn't react much to anything unless you pull a rare earth magnet up close. The onboard magnetic fields seem far more significant than local external fields or the earth's magnetic field. On my iPhone 4S it consistently points to the bottom left of the device; on the iPad mini it points usually to the top right.

_CLHeading.[x|y|z]_  is the most vulnerable to local external fields, whether moving or static relative to the device.  

(CMDevice)_CMCalibratedMagneticField_ is the most steady in the face of varying external fields, but otherwise tracks it's Core Location counterpart _CLHeading.[x|y|z]_ pretty closely.  
 
_CLHeading.magneticHeading_ - Apple's recommendation for magnetic compass reading -  is far more stable than any of these. It is using data from the other sensors to stabilise the magnetometer data. But you don't get a raw breakdown of x,y,z


                 influenced by
	             onboard fields    local external fields   earth's field
	yellow               X                   X                 X
	green                _                   X                 X
	blue                 _                   _                 X
	red                  _                   _                 X           

 yellow _CMMagnetometer_  
 green _CLHeading.[x|y|z]_  
 blue _CMCalibratedMagneticField_  
 red _CLHeading.magneticHeading_  
 
 This does seem to contradict the docs, which suggest that _CLHeading.[x|y|z]_ should be less influenced by local external fields than _CMCalibratedMagneticField_.
 
 
 What approach should you take? Based on my limited testing, I would suggest…  
_If you want a compass reading_  
CLHeading's `magneticHeading` and `trueHeading` will give you the most accurate and most stable compass reading.  
_If you need to avoid Core Location_  
CMDeviceMotion's `CMCalibratedMagneticField` seems to be the next most desirable, although considerably less stable and accurate than `magneticHeading`.  
_If you are interested in local magnetic fields_  
CLHeading's 'raw' x y and z properties seem to be more sensitive to local magnetic fields.  
_If you want all of the  data including onboard magnetic fields_  
Raw magnetometer data from CMMagnetometer. There is really not much point using this unless you are prepared to do tons of filtering, as it is hugely influenced by magnetic fields generated on the device itself.  
	 


  [1]: http://i.stack.imgur.com/32Tgu.png