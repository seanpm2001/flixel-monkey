Strict

Import flxextern
Import flxobject

Class FlxTilemap Extends FlxObject

	Method Overlaps:Bool(objectOrGroup:FlxBasic, inScreenSpace:Bool = False, camera:FlxCamera = Null)
		'TODO
		Return False	
	End Method
	
	Method OverlapsAt:Bool(x:Float, y:Float, objectOrGroup:FlxBasic, inScreenSpace:Bool = False, camera:FlxCamera = Null)
		'TODO
		Return False	
	End Method
	
	Method OverlapsWithCallback:Bool(object:FlxObject, callback:FlxTilemapOverlapListener = Null, flipCallbackParams:Bool = False, position:FlxPoint = Null)
		'TODO
		Return False	
	End Method
	
	Method ToString:String()
		Return "FlxTilemap"
	End Method

End Class

Interface FlxTilemapOverlapListener
	
	Method OnTilemapOverlap:Bool(object1:FlxObject, object2:FlxObject)

End Interface