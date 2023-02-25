#!mainFile "main.opy"

#!define declareForEach(array) array = [0, array.slice(0, len(array))]\
    printLog("size of for-each like array: {}".format(len(array)))

#!define forEachArray(array) while array[0] < len(array[1])

#!define loopBody(array) array[1][array[0]]

#!define loopIndex(array) array[0]

#!define setHeroCaps(entity, value) entity.setAbility1Enabled(value)\
    entity.setAbility2Enabled(value)\
    entity.setUltEnabled(value)\
    entity.setSecondaryFireEnabled(value)

#!define enableHeroCaps(entity)\
    # Reset abilities availability\
    entity.setAbility1Enabled(true)\
    entity.setAbility2Enabled(true)\
    entity.setUltEnabled(true)\
    entity.setJumpEnabled(true)\
    entity.setMeleeEnabled(true)\
    entity.setCrouchEnabled(true)\
    entity.setReloadEnabled(true)\
    entity.setPrimaryFireEnabled(true)\
    entity.setSecondaryFireEnabled(true)\
    entity.allowButton(Button.INTERACT)\
    entity.allowButton(Button.JUMP)\
    entity.allowButton(Button.RELOAD)\
    entity.allowButton(Button.MELEE)\
    entity.allowButton(Button.ULTIMATE)\
    entity.allowButton(Button.PRIMARY_FIRE)\
    entity.allowButton(Button.SECONDARY_FIRE)\
    entity.allowButton(Button.ABILITY_1)\
    entity.allowButton(Button.ABILITY_2)\
    entity.allowButton(Button.CROUCH)

#!define disableHeroCaps(entity)\
    # Reset abilities availability\
    entity.setAbility1Enabled(false)\
    entity.setAbility2Enabled(false)\
    entity.setUltEnabled(false)\
    entity.setJumpEnabled(false)\
    entity.setMeleeEnabled(false)\
    entity.setCrouchEnabled(false)\
    entity.setReloadEnabled(false)\
    entity.setPrimaryFireEnabled(false)\
    entity.setSecondaryFireEnabled(false)\
    entity.disallowButton(Button.INTERACT)\
    entity.disallowButton(Button.JUMP)\
    entity.disallowButton(Button.RELOAD)\
    entity.disallowButton(Button.MELEE)\
    entity.disallowButton(Button.ULTIMATE)\
    entity.disallowButton(Button.PRIMARY_FIRE)\
    entity.disallowButton(Button.SECONDARY_FIRE)\
    entity.disallowButton(Button.ABILITY_1)\
    entity.disallowButton(Button.ABILITY_2)\
    entity.disallowButton(Button.CROUCH)

#!define destination(pos, rot, len) ((pos + rot) * len)
#!define clamp(value, min, max) min if value < min else max if value > max else value
#!define getState(array, player) array[player.getSlot() * (1 if player.getTeam() == Team.1 else 2)]
#!define setState(array, player, value) getState(array, player) = value
#!define toggleState(array, player) setState(array, player, not getState(array, player))
