
const float TIMESHIFT_Z_OFFSET = 11520.0;

bool function Toolgun_Func_TimeshiftMirror( entity player, array<string> args )
{
#if SERVER
	vector eyePosition = player.EyePosition()
	vector viewVector = player.GetViewVector()
	TraceResults traceResults = TraceLine( eyePosition, eyePosition + viewVector * 10000, player, TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_PLAYER )

	if( traceResults.hitEnt )
	{
		Toolgun_Utils_FireToolTracer( player );
		if( traceResults.hitEnt.GetClassName() == "worldspawn" )
		{
			return false;
		}

		for( int i = 0; i < ToolgunData.SpawnedEntities.len(); ++i )
		{
			// Can only mirror props we've placed
			if( ToolgunData.SpawnedEntities[i] == traceResults.hitEnt )
			{				
				vector TimeshiftOffset = (player.GetOrigin().z > 5000) ? Vector( 0, 0, TIMESHIFT_Z_OFFSET * -1 ) : Vector( 0, 0, TIMESHIFT_Z_OFFSET );
				asset Asset = traceResults.hitEnt.GetModelName();
				vector Pos = traceResults.hitEnt.GetOrigin() + TimeshiftOffset;
				vector Ang = traceResults.hitEnt.GetAngles();
				Toolgun_Func_SpawnAsset( Asset, Pos, Ang );
				return true;
			}
		}		
	}
	return false;
#else
	return false;
#endif
}

// 14:38:17 | Location: <10672.7, -2002.8, -68.8177> // Present
// 14:38:22 | Location: <10672.7, -2002.8, 11451.2> // Past