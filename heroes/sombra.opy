#!mainFile "../main.opy"

globalvar sombraEnhancedHacked

rule "sombra: enhanced hacked status":
    @Event eachPlayer
    @Condition eventPlayer.hasStatusEffect(Status.HACKED)
    @Condition getState(sombraEnhancedHacked, eventPlayer) == 0
    setState(sombraEnhancedHacked, eventPlayer, 1)
    eventPlayer.setMoveSpeed(70)
    eventPlayer.startModifyingVoicelinePitch(0.5, true)
    waitUntil(eventPlayer.isDead(), random.uniform(6, 8))
    eventPlayer.setMoveSpeed(100)
    eventPlayer.stopModifyingVoicelinePitch()
    setState(sombraEnhancedHacked, eventPlayer, 0)

rule "sombra: disable abilities while hacked":
    @Event eachPlayer
    @Condition getState(sombraEnhancedHacked, eventPlayer) == 1
    @Condition eventPlayer.isAlive()
    printLog("loop disable abilities")
    setHeroCaps(eventPlayer, false)
    wait(0.5)

    if RULE_CONDITION:
        goto RULE_START

    setHeroCaps(eventPlayer, true)