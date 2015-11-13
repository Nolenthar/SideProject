//---=== modFriendlyHUD ===---
function SortInventoryFlashArray( tabIndex : int, out entries : CScriptedFlashArray )
{
	switch( tabIndex )
	{
		case InventoryMenuTab_Potions:
			SortInventoryPotions( entries );
			break;
		default:
			break;
	}
}

function SortInventoryPotions( out entries : CScriptedFlashArray )
{
	var numEntries, eIdx : int;
	var itemEntry : CScriptedFlashObject;
	var oils, bombs, potions, mutagens, others : array< CScriptedFlashObject >;
	
	numEntries = entries.GetLength();
	for( eIdx = 0; eIdx < numEntries; eIdx += 1 )
	{
		itemEntry = entries.GetElementFlashObject( eIdx );
		if ( IsMutagenPotion( itemEntry ) )
		{
			AddItemSorted( mutagens, itemEntry );
		}
		else if ( IsPotion( itemEntry ) )
		{
			AddItemSorted( potions, itemEntry );
		}
		else if ( IsOil( itemEntry ) )
		{
			AddItemSorted( oils, itemEntry );
		}
		else if ( IsBomb( itemEntry ) )
		{
			AddItemSorted( bombs, itemEntry );
		}
		else
		{
			AddItemSorted( others, itemEntry );
		}
	}
	entries.ClearElements();
	PushBackItems( entries, oils, entries.GetLength() );
	PushBackItems( entries, bombs, entries.GetLength() );
	PushBackItems( entries, potions, entries.GetLength() );
	PushBackItems( entries, mutagens, entries.GetLength() );
	PushBackItems( entries, others, entries.GetLength() );
}

function IsMutagenPotion( itemEntry : CScriptedFlashObject ) : bool
{
	var category, iconPath : string;

	category = itemEntry.GetMemberFlashString( "category" );
	iconPath = itemEntry.GetMemberFlashString( "iconPath" );
	if ( category == "potion" && StrContains( iconPath, "mutagen_potion" ) )
	{
		return true;
	}
	return false;
}

function IsPotion( itemEntry : CScriptedFlashObject ) : bool
{
	var category : string;

	category = itemEntry.GetMemberFlashString( "category" );
	if ( category == "potion" )
	{
		return true;
	}
	return false;
}

function IsOil( itemEntry : CScriptedFlashObject ) : bool
{
	var category : string;

	category = itemEntry.GetMemberFlashString( "category" );
	if ( category == "oil" )
	{
		return true;
	}
	return false;
}

function IsBomb( itemEntry : CScriptedFlashObject ) : bool
{
	var category : string;

	category = itemEntry.GetMemberFlashString( "category" );
	if ( category == "petard" )
	{
		return true;
	}
	return false;
}

function AddItemSorted( out entries : array< CScriptedFlashObject >, newEntry : CScriptedFlashObject )
{
	var newItemGridPosition, gridPosition : int;
	var numEntries, eIdx : int;
	var itemEntry : CScriptedFlashObject;
	
	newItemGridPosition = newEntry.GetMemberFlashInt( "gridPosition" );
	numEntries = entries.Size();
	for( eIdx = 0; eIdx < numEntries; eIdx += 1 )
	{
		itemEntry = entries[ eIdx ];
		gridPosition = itemEntry.GetMemberFlashInt( "gridPosition" );
		if ( newItemGridPosition < gridPosition )
		{
			entries.Insert( eIdx, newEntry );
			return;
		}
	}
	entries.PushBack( newEntry );
}

function PushBackItems( out entries : CScriptedFlashArray, newEntries : array< CScriptedFlashObject >, startingPosition : int )
{
	var numEntries, eIdx : int;
	var itemEntry : CScriptedFlashObject;
	
	numEntries = newEntries.Size();
	for( eIdx = 0; eIdx < numEntries; eIdx += 1 )
	{
		itemEntry = newEntries[ eIdx ];
		itemEntry.SetMemberFlashInt( "gridPosition", startingPosition + eIdx );
		entries.PushBackFlashObject( itemEntry );
	}
}
//---=== modFriendlyHUD ===---