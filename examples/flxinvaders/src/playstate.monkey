Strict

Import flixel

Import playership
Import alien

Class PlayState Extends FlxState Implements FlxQuadTreeOverlapNotifyCallback

	Global _CLASS:FlxClass = New PlayStateClass()
	
	Field player:PlayerShip
	Field playerBullets:FlxGroup
	Field aliens:FlxGroup
	Field alienBullets:FlxGroup
	
	Field vsPlayerBullets:FlxGroup
	Field vsAlienBullets:FlxGroup
	
	Method Create:Void()
		player = New PlayerShip()
		Add(player)
		
		Local numPlayerBullets:Int = 8
		playerBullets = New FlxGroup(numPlayerBullets)
		Local sprite:FlxSprite
		For Local i:Int = 0 Until numPlayerBullets
			sprite = New FlxSprite(-100, -100)
			sprite.MakeGraphic(2, 8)
			sprite.exists = False
			playerBullets .Add(sprite)
		Next
		Add(playerBullets)
		
		Local numAlienBullets:Int = 32
		alienBullets = New FlxGroup(numAlienBullets)
		
		For Local i:Int = 0 Until numAlienBullets
			sprite = New FlxSprite(-100, -100)
			sprite.MakeGraphic(2, 8)
			sprite.exists = False
			alienBullets.Add(sprite)
		Next
		Add(alienBullets)		
		
		Local numAliens:Int = 50
		aliens = New FlxGroup(numAliens)		
		Local a:Alien
		Local colors:Int[] = [FlxG.BLUE, FlxG.BLUE | FlxG.GREEN, FlxG.GREEN, FlxG.GREEN | FlxG.RED, FlxG.RED]		
				
		For Local i:Int = 0 Until numAliens
			a = New Alien(8 + (i Mod 10) * 32, 24 + Int(i / 10) * 32, colors[Int(i / 10)], alienBullets)
			aliens.Add(a)
		Next
		Add(aliens)
		
		vsPlayerBullets = New FlxGroup()
		vsPlayerBullets.Add(aliens)
		
		vsAlienBullets = New FlxGroup()
		vsAlienBullets.Add(player)
	End Method
	
	Method Update:Void()
		If (KeyHit(KEY_ESCAPE)) Error ""
		
		Local alien:Alien = Alien(aliens.Members[0])		
		If (alien.x < 0 Or alien.x > 16) Then
			aliens.CallAll(Alien.ReverseVelocity)	
		End If
		
		FlxG.Overlap(playerBullets, vsPlayerBullets, Self)
		FlxG.Overlap(alienBullets, vsAlienBullets, Self)
		
		Super.Update()
	End Method
	
	Method OnOverlap:Void(object1:FlxObject,object2:FlxObject)
		object1.Kill()
		object2.Kill()
	End Method

End Class

Class PlayStateClass Implements FlxClass
	
	Method CreateInstance:FlxBasic()
		Return New PlayState()
	End Method
	
	Method InstanceOf:Bool(Object:FlxBasic)
		Return (PlayState(Object) <> Null)
	End Method

End Class