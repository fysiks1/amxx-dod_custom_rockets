#include <amxmodx>
#include <amxmisc>
#include <fakemeta>
#include <engine>
#include <dodfun>
#include <fun>

#define chance(%1) ( %1 > random(100) )

new g_szModels[6][64], g_iModelCount = 0
new g_iChances[sizeof g_szModels], g_iChanceSum = 0
new g_pRocketMode, g_pRocketChance, g_pRocketModel

public plugin_init()
{
	register_plugin("DOD Custom Rockets", "1.0.0", "Fysiks")
	
	g_pRocketMode = register_cvar("custom_rocket_mode", "0")
	g_pRocketChance = register_cvar("custom_rocket_chance", "10")
	g_pRocketModel = register_cvar("custom_rocket_model", "0")
}

public plugin_precache()
{
	LoadSettings()
	
	for(new i = 0; i < sizeof g_szModels; i++)
	{
		if( file_exists(g_szModels[i]) )
		{
			precache_model(g_szModels[i])
			copy(g_szModels[g_iModelCount], charsmax(g_szModels[]), g_szModels[i])
			g_iChances[g_iModelCount] = g_iChances[i]
			g_iChanceSum += g_iChances[g_iModelCount]
			g_iModelCount++
		}
	}

	if( !g_iModelCount )
	{
		set_fail_state("Failed to load any custom rocket models")
	}
}

public set_rocket_model(ent)
{
	if( pev_valid(ent) )
	{
		new select = get_pcvar_num(g_pRocketModel)
		new iModel = select < 0 ? random_item(g_iChances, g_iModelCount) : clamp(select, 0, g_iModelCount-1)
		entity_set_model(ent, g_szModels[iModel])
	}
}

public rocket_shoot(index, ent, iType)
{
	if( !g_pRocketMode ) return // If the cvar is not yet populated, dont' execute the code here.
	
	if( pev_valid(ent) && get_pcvar_num(g_pRocketMode) && chance(get_pcvar_num(g_pRocketChance)) )
	{
		remove_task(ent)
		set_task(0.1, "set_rocket_model", ent)
	}
}

stock random_item(itemChances[], count=sizeof itemChances)
{
	static rand, i, sum
	rand = random(g_iChanceSum)
	i = sum = 0
	for( i = 0; i < count; i++ )
	{
		sum += itemChances[i]
		if( sum > rand )
			break
	}
	return i
}

LoadSettings()
{
	// Load models and chance values from file
	new szConfigsDir[64], szFilePath[128]

	get_configsdir(szConfigsDir, charsmax(szConfigsDir))
	formatex(szFilePath, charsmax(szFilePath), "%s/custom_rockets.ini", szConfigsDir)

	new f = fopen(szFilePath, "rt")

	if( f )
	{
		new szBuffer[64], i = 0, szModel[sizeof g_szModels[]], szChance[5]
		
		while( fgets(f, szBuffer, charsmax(szBuffer)) )
		{
			parse(szBuffer, szModel, charsmax(szModel), szChance, charsmax(szChance))

			if( szModel[0] && szModel[0] != ';' )
			{
				copy(g_szModels[i], charsmax(g_szModels[]), szModel)
				g_iChances[i] = str_to_num(szChance)
				i++
			}
		}
		fclose(f)
	}
}
