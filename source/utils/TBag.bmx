

rem
	bbdoc: an unsorted collection type, using array for speed.
	about: contains objects which can be retrieved by index	
end rem
Type TBag

	'content goes here
	Field array:Object[16]	
	
	'we have this many active elements in the array.
	'also, this points to the next empty slot
	'as array starts at 0
	Field currentSlot:Int
	
	
	Method New()
		currentSlot = 0
	End Method
	
	

	Rem
		bbdoc: removes the element at the specified position
		returns: the removed object.
	endrem
	Method RemoveByIndex:Object(index:Int)
	
		'save the element to remove
		Local o:Object = array[index]
		
		'put the last element in its place
		array[index] = array[currentSlot - 1]
		
		'empty the last slot
		array[currentSlot - 1] = Null
		
		'move slot count back by 1
		currentSlot:- 1
		
		'return removed element
		Return o
	End Method
	
	
	
	Rem
		bbdoc: removes and returns the last item in the bag
		returns: removed object or null
	endrem
	Method RemoveLast:Object()
		If currentSlot > 0
			currentSlot:- 1
			Local o:Object = array[currentSlot]
			array[currentSlot] = Null
			Return o
		End If
		Return Null
	End Method
	
	
	
	Rem
		bbdoc: removes the first occurance of the specified element.
		returns: true if remove succeeded.
	endrem
	Method Remove:Int(o:Object)	
		For Local i:Int = 0 To currentSlot - 1	
			If array[i] = o
				RemoveByIndex(i)
				Return True
			End If
		Next
		Return False
	End Method
	
	
	
	Rem
		bbdoc: returns the number of element slots in the bag.
	endrem
	Method GetCapacity:Int()
		Return array.Length
	End Method
	

	
	Rem
		bbdoc: returns the number of elements in the bag.
	endrem	
	Method GetSize:Int()
		Return currentSlot
	End Method
	
	
	
	Rem
		bbdoc: returns true if the bag contains no elements.
	endrem
	Method IsEmpty:Int()
		If currentSlot = 0 Then Return True
		Return False
	End Method
	
	
	
	Rem
		bbdoc: grows bag array capacity.
		about: each grow step is bigger than the previous.
		more growth calls = more need for more space.
	endrem	
	Method Grow(newSize:Int = 0 )

		'find a new size.			
		If newSize = 0 Then newSize = (array.Length *3) / 2 + 1

		array = array[..newSize]	
	End Method
	

	
	Rem
		bbdoc: adds specified element to end of this bag. if needed
		also increases the capacity of the bag.
	endrem	
	Method Add(o:Object)
		'could be out of bounds
		If currentSlot = array.Length Then Grow()
		
		array[currentSlot] = o	
		currentSlot:+ 1
	End Method
	

		
	Rem
		bbdoc: set element at specified index in the bag.
		about: sizes bag if needed.
	endrem
	Method Set(index:Int, o:Object)
		If index >= array.Length
			Grow(index *2)
			currentSlot = index + 1
		ElseIf index >= currentSlot
			currentSlot = index+1				
		End If		
		array[index] = o
	End Method
	
	
	
	rem
		bbdoc: returns true if specified element is in the bag.
		about: only finds the first occurance.
	endrem	
	Method Contains:Int(o:Object)
		For Local i:Int = 0 To currentSlot - 1
			If array[i] = o Then Return True
		Next
		Return False
	End Method
	
	

	Rem
		bbdoc: returns the element at the specified index
	endrem	
	Method Get:Object(index:Int)
		Return array[index]
	End Method
	
	
	
	Rem
		bbdoc: Removes from this bag all of its elements that are
		contained in the specified bag.
		returns: true if contents of this bag are changed.
	endrem
	Method RemoveAllFrom:Int(b2:TBag)
		Local modified:Int = False		
		
		For Local index2:Int = 0 To b2.GetSize() -1			
			For Local index:Int = 0 To GetSize() -1
				If b2.array[index2] = array[index]
					RemoveByIndex(index)
					modified = True
					index:-1
					Continue
				EndIf
			Next
		Next
		
		Return modified
	End Method
	
	
	
	Rem
		bbdoc: removes all elements from this bag.
	endrem
	Method Clear()
		For Local i:Int = 0 To array.Length -1
			array[i] = Null
		Next
		currentSlot = 0
	End Method
	
	
	
	Rem
		bbdoc: add all items into this bag.
	endrem
	Method AddAllFrom(b2:TBag)
		For Local i:Int = 0 To b2.GetSize() -1
			Add(b2.Get(i))
		Next
	End Method
End Type

