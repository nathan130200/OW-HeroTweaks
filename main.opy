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
# #!extension spawnMoreDummyBots

#!extension kineticExplosionEffects


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
        "skirmish": {
            "enabledMaps": [
                "workshopChamber"
            ]
        }
    }
}

globalvar g_debugMode = createWorkshopSetting(bool, "Misc", "Enable Testing Mode", false, 0)

rule "[DEBUG ONLY] Used for testing with bots!":
    @Event eachPlayer
    @Condition eventPlayer != hostPlayer
    @Condition g_debugMode
    eventPlayer.setPrimaryFireEnabled(false)
    eventPlayer.setSecondaryFireEnabled(false)
    eventPlayer.setAbility1Enabled(false)
    eventPlayer.setUltEnabled(false)

#!define destination(pos, rot, len) ((pos + rot) * len)
#!define clamp(value, min, max) min if value < min else max if value > max else value

#!define defineVariables(type, section, variables) __script__("api/defineVariables.js")
#!define defineConfigs(category, props) __script__("api/defineConfigs.js")

#!include "util.opy"

#!include "heroes/cassidy.opy"