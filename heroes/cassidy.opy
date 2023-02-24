#!mainFile "../main.opy"

#!define CASSIDY_MAGNETICBOMB_MIN_STRENGTH 10

defineVariables("player", "magneticBomb", [/* "posX", "posY", "posZ",*/ "strength", 
    "velocity", "state", "target", "#effects", "#entities", "startVec", "endVec", "#cdTarget", "#cdAbility", "#viewVect" ])

defineConfigs("Cassidy: Magnetic Bomb", [
    { key: "magneticBomb_isActive", name: "Enalbed", type: "bool", value: true },
    { key: "magneticBomb_cdDelayHit", name: "Time Out (When Change Target)", type: "float[1:10]", value: 1 },
    { key: "magneticBomb_cdNoHit", name: "Cooldown (When No Hit)", type: "float[1:10]", value: 3 },
    { key: "magneticBomb_cdSomeHit", name: "Cooldown (When Hit Someone)", type: "float[1:10]", value: 5 },
    { key: "magneticBomb_cdKill", name: "Cooldown (When Kill Someone)", type: "float[1:10]", value: 9 },
    { key: "magneticBomb_explosionRadius", name: "Explosion Radius", type: "float[5:50]", value: 5 }
])

subroutine magneticBomb_OnHit
subroutine magneticBomb_OnDestroy

rule "cassidy magnetic bomb: init":
    @Event eachPlayer
    @Hero mccree
    @Condition magneticBomb_isActive
    eventPlayer.disallowButton(Button.ABILITY_2)
    eventPlayer.magneticBomb_target = -1
    eventPlayer.magneticBomb_state = 0

rule "cassidy magnetic bomb: trigger":
    @Event eachPlayer
    @Hero mccree
    @Condition magneticBomb_isActive
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2)
    @Condition eventPlayer.magneticBomb_state == 0
    @Condition entityExists(eventPlayer.magneticBomb_target) and eventPlayer.magneticBomb_target.isAlive()
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) == 0
    eventPlayer.setAbility2Enabled(false)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 9999)
    eventPlayer.magneticBomb_state = 1
    eventPlayer.magneticBomb_startVec = worldVector(vect(0, 0.5, 1.25), eventPlayer, Transform.ROTATION_AND_TRANSLATION)
    eventPlayer.magneticBomb_viewVect = eventPlayer.magneticBomb_startVec
    eventPlayer.magneticBomb_effects = []

    createEffect(getAllPlayers(), Effect.GOOD_AURA, Color.WHITE, updateEveryTick(eventPlayer.magneticBomb_viewVect), 0.16, EffectReeval.VISIBILITY_POSITION_RADIUS_AND_COLOR)
    eventPlayer.magneticBomb_effects.append(getLastCreatedEntity())

    createEffect(getAllPlayers(), Effect.BAD_AURA, Color.RED, updateEveryTick(eventPlayer.magneticBomb_viewVect), 0.16, EffectReeval.VISIBILITY_POSITION_RADIUS_AND_COLOR)
    eventPlayer.magneticBomb_effects.append(getLastCreatedEntity())

    createEffect(getAllPlayers(), Effect.BAD_AURA_SOUND, Color.WHITE, updateEveryTick(eventPlayer.magneticBomb_viewVect), 75, EffectReeval.VISIBILITY_POSITION_RADIUS_AND_COLOR)

    eventPlayer.magneticBomb_effects.append(getLastCreatedEntity())
    eventPlayer.magneticBomb_strength = eventPlayer.magneticBomb_target.getMaxHealth() / 1.25

rule "cassidy magnetic bomb: update view":
    @Event eachPlayer
    @Hero mccree
    @Condition eventPlayer.isAlive()
    @Condition magneticBomb_isActive
    @Condition eventPlayer.magneticBomb_state == 1
    @Condition eventPlayer.magneticBomb_target != -1
    @Condition eventPlayer.magneticBomb_strength > CASSIDY_MAGNETICBOMB_MIN_STRENGTH
    eventPlayer.magneticBomb_strength -= CASSIDY_MAGNETICBOMB_MIN_STRENGTH
    eventPlayer.magneticBomb_startVec = eventPlayer.magneticBomb_target.getEyePosition()
    chase(eventPlayer.magneticBomb_viewVect, eventPlayer.magneticBomb_startVec, rate=clamp(eventPlayer.magneticBomb_velocity, 10, 40), ChaseReeval.DESTINATION_AND_RATE)

    if distance(eventPlayer.magneticBomb_viewVect, eventPlayer.magneticBomb_target.getEyePosition()) <= 2:
        magneticBomb_OnHit()
        return
    else:
        wait(0.16)

        if RULE_CONDITION:
            goto RULE_START

        magneticBomb_OnDestroy()

rule "cassidy magnetic bomb: change target":
    @Event playerDealtDamage
    @Condition attacker != victim
    @Condition entityExists(attacker)
    @Condition attacker.getCurrentHero() == Hero.MCCREE or attacker.getHeroOfDuplication() == Hero.MCCREE
    @Condition magneticBomb_isActive
    attacker.magneticBomb_target = victim
    attacker.magneticBomb_cdTarget = magneticBomb_cdDelayHit
    chase(attacker.magneticBomb_cdTarget, 0, rate=1, ChaseReeval.DESTINATION_AND_RATE)

rule "cassidy magnetic bomb: reset target (lost power)":
    @Event eachPlayer
    @Hero mccree
    @Condition magneticBomb_isActive
    @Condition eventPlayer.magneticBomb_strength <= CASSIDY_MAGNETICBOMB_MIN_STRENGTH
    eventPlayer.magneticBomb_target = null
    eventPlayer.magneticBomb_cdAbility = magneticBomb_cdSomeHit
    magneticBomb_OnDestroy()

rule "cassidy magnetic bomb: reset target (invalid)":
    @Event eachPlayer
    @Hero mccree
    @Condition eventPlayer.magneticBomb_state == 1
    @Condition not entityExists(eventPlayer.magneticBomb_target) or eventPlayer.magneticBomb_target.isDead()
    eventPlayer.magneticBomb_cdAbility = magneticBomb_cdNoHit
    magneticBomb_OnDestroy()

def magneticBomb_OnHit():
    @Name "cassidy magnetic bomb: hit detection"
    eventPlayer.magneticBomb_cdAbility = magneticBomb_cdKill

    eventPlayer.magneticBomb_entities = getPlayersInRadius(eventPlayer.magneticBomb_viewVect, magneticBomb_explosionRadius, eventPlayer.magneticBomb_target.getTeam(), LosCheck.SURFACES_AND_ENEMY_BARRIERS)
        damage(eventPlayer.magneticBomb_entities, eventPlayer, eventPlayer.magneticBomb_strength)
    
    wait()

    magneticBomb_OnDestroy()


def magneticBomb_OnDestroy():
    @Name "cassidy magnetic bomb: cleanup"

    declareForEach(eventPlayer.magneticBomb_effects)

    forEachArray(eventPlayer.magneticBomb_effects):
        destroyEffect(loopBody(eventPlayer.magneticBomb_effects))
        loopIndex(eventPlayer.magneticBomb_effects)++
        wait()

    eventPlayer.setAbility2Enabled(true)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, eventPlayer.magneticBomb_cdAbility)
    eventPlayer.magneticBomb_state = 0