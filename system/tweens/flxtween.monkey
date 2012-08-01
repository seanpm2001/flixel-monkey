Strict

Import flixel.flxbasic
Import flixel.flxg
Import util.flxease

Class FlxTween
	
	Const PERSIST:Int = 0
	
	Const LOOPING:Int = 1
	
	Const ONESHOT:Int = 2
	
	Field active:Bool
	
	Field complete:FlxTweenListener
	
	Field _finish:Bool
	
	Field _parent:FlxBasic
	
	Field _prev:FlxTween
	
	Field _next:FlxTween
	
	Field _target:Float
	
	Field _ease:FlxEaseFunction

	Field _type:Int
	
	Field _t:Float
	
	Field _time:Float

Public
	Method New(duration:Float, type:Int = 0, complete:FlxTweenListener = Null, ease:FlxEaseFunction = Null)
		_target = duration
		_type = type
		Self.complete = complete
		_ease = ease
		_t = 0
	End Method
	
	Method Update:Void()
		_time += FlxG.Elapsed
		_t = _time / _target
		
		If (_ease <> Null) _t = _ease.Ease(_t)
		
		If (_time >= _target) Then
			_t = 1
			_finish = True
		End If
	End Method
	
	Method Start:Void()
		_time = 0
				
		If (_target = 0) Then
			active = False
			Return
		End If
		
		active = True
	End Method
	
	Method Finish:Void()
		Select(_type)
			Case PERSIST
				_time = _target
				active = False
				
			Case LOOPING
				_time Mod = _target
				_t = _time / _target
				
				If (_ease <> Null And _t > 0 And _t < 1) Then
					_t = _ease.Ease(_t)
				End If
				
				Start()
				
			Case ONESHOT
				_time = _target
				active = False
				_parent.RemoveTween(Self)
		End Select
		
		_finish = False
		If (complete <> Null) complete.OnTweenComplete()
	End Method
	
	Method Percent:Float() Property
		Return _time / _target
	End Method
	
	Method Percent:Void(value:Float) Property
		_time = _target * value
	End Method
	
	Method Scale:Float() Property
		Return _t
	End Method

End Class

Interface FlxTweenListener
	
	Method OnTweenComplete:Void()

End Interface