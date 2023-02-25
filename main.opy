#!disableOptimizations
#!suppressWarnings w_ow2_rule_condition_chase

# #!obfuscate
# #!extension beamEffects
# #!extension beamSounds
# #!extension buffAndDebuffSounds
# #!extension buffStatusEffects
# #!extension debuffStatusEffects
# #!extension energyExplosionEffects
# #!extension explosionSounds
# #!extension playMoreEffects
#!extension spawnMoreDummyBots


#!define delimiterRule()\
rule "____________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________":\
    @Delimiter\
    @Disabled\
    @Event global\
    

#!define importScript(path) #!include path\
delimiterRule()

#!extension kineticExplosionEffects

playervar tag = "reset"
playervar lastHero = null

#!defineMember hasTag(name) tag.strIndex(name) != -1
#!defineMember setTag(name) tag = name
#!defineMember isReady() tag.strIndex("reset") == -1
#!defineMember setReady() tag = ""

settings {
    "main": {
        "description": "Some ideas and concepts for heroes changes that can impact in gameplay.\n\nI'm focusing add some new stuff to existing heroes to make game more interesting and funny.\n\nCreated by Nathan#1826\nDiscord: ",
        "modeName": "HERO TWEAKS v1.0"
    },
    "lobby": {
        "allowPlayersInQueue": true,
        "mapRotation": "afterGame",
        "enableMatchVoiceChat": true,
        "returnToLobby": "afterGame"
    },
    "gamemodes": {
        "general": {
            "gamemodeStartTrigger": "manual",
            #"heroLimit": "off",
            "enableKillCam": false,
            "enableKillFeed": false,
            "respawnTime%": 50,
            #"enableRandomHeroes": true
        },
        "assault": {
            "enabledMaps": [
                "hanamura",
                #"midtown"
            ],
            "enableCompetitiveRules": true
        }
    },
    "heroes": {
        "allTeams": {
            /*"enabledHeroes": [
                "mccree",
                "mercy",
                "sombra",
                "lucio",
                "moira"
            ],*/
            "sombra": {
                "secondaryFireCooldown%": 250
            }
        }
    }
}

#!define defineVariables(type, section, variables) __script__("api/defineVariables.js")
#!define defineConfigs(category, props) __script__("api/defineConfigs.js")


#!include "util.opy"

globalvar g_debugMode = createWorkshopSetting(bool, "Misc", "Debug Mode", true, 0)

/*rule "[DEBUG ONLY] Used for testing with bots!":
    @Event eachPlayer
    @Condition eventPlayer != hostPlayer
    @Condition g_debugMode
    @Disabled
    eventPlayer.setPrimaryFireEnabled(false)
    eventPlayer.setSecondaryFireEnabled(false)
    eventPlayer.setAbility1Enabled(false)
    eventPlayer.setUltEnabled(false)*/

rule "player: soft reset":
    @Event eachPlayer
    @Condition eventPlayer.isInSpawnRoom()
    @Condition eventPlayer.isAlive()
    @Condition eventPlayer.hasTag("reset") == false or eventPlayer.lastHero != eventPlayer.getCurrentHero()
    # Track hero changes (work-around fix for cassidy tweak, after change hero cannot use ability 2)
    eventPlayer.lastHero = eventPlayer.getCurrentHero()

    # Enable player abilities & buttons.
    enableHeroCaps(eventPlayer)

    # Reset player movement params.
    eventPlayer.setMoveSpeed(100)
    eventPlayer.setGravity(100)

    # Some tweaks can change projectile speed & gravity, so reset both them.
    eventPlayer.setProjectileGravity(100)
    eventPlayer.setProjectileSpeed(100)

    # Some delay to all changes get submited.
    wait(0.25)

    # Notify current tweak script we have done soft resetting the player (for example cassidy initial setup will disable ABILITY_2 button).
    eventPlayer.setTag("reset")

delimiterRule()

importScript("heroes/cassidy.opy")
importScript("heroes/lucio.opy")
#importScript("heroes/mercy.opy")
importScript("heroes/moira.opy")
importScript("heroes/sombra.opy")