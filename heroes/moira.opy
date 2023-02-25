#!mainFile "../main.opy"

rule "moira: apply slow when damaged by orb":
    @Event playerDealtDamage
    @Condition attacker.getCurrentHero() == Hero.MOIRA
    @Condition eventAbility == Button.ABILITY_2
    @Condition eventDamage != 0
    victim.setMoveSpeed(random.uniform(65, 75))
    wait(random.uniform(0.65, 1))
    victim.setMoveSpeed(100)

rule "moira: apply speed when healed by orb":
    @Event playerDealtHealing
    @Condition healer.getCurrentHero() == Hero.MOIRA
    @Condition eventAbility == Button.ABILITY_2
    @Condition healer != healer
    @Condition eventHealing != 0
    healee.setMoveSpeed(random.uniform(105, 125))
    wait(random.uniform(0.65, 1))
    healee.setMoveSpeed(100)