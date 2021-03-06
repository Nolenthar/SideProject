class RoachInventoryConfig
{
	private var GeraltEncumberLimit : float;
	private var RoachRangeToAccessStash : float;
	
	private var rangeToCheckForDoors : float;
	private var rangeToCheckForCamps : float;
	private var rangeToCheckForSignPosts : float;
	
	private var doorEntityCount : int;
	private var campEntityCount : int;
	private var signPostEntityCount : int;
	
	default GeraltEncumberLimit = 80;
	default RoachRangeToAccessStash = 10;
	
	default rangeToCheckForDoors = 300;
	default rangeToCheckForCamps = 300;
	default rangeToCheckForSignPosts = 300;
	
	default doorEntityCount = 30;
	default campEntityCount = 10;
	default signPostEntityCount = 20;
	
	public function GetGeraltEncumber() : float
	{
		return GeraltEncumberLimit;
	}
	
	public function GetRangeToAccessStash() : float
	{
		return RoachRangeToAccessStash;
	}
	
	public function GetDoorRange() : float
	{
		return rangeToCheckForDoors;
	}
	
	public function GetCampRange() : float
	{
		return rangeToCheckForCamps;
	}
	
	public function GetSignPostRange() : float
	{
		return rangeToCheckForSignPosts;
	}

	public function GetDoorEntity() : int
	{
		return doorEntityCount;
	}
	
	public function GetCampEntity() : int
	{
		return campEntityCount;
	}
	
	public function GetSignPostEntity() : int
	{
		return signPostEntityCount;
	}
}