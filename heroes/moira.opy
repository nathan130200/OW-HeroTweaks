#!mainFile "../main.opy"

rule "moira: apply slow when damaged by orb":
    @Event playerDealtDamage
    @Condition attacker.getCurrentHero() == Hero.MOIRA
    @Condition eventAbility == Button.ABILITY_2
    victim.setMoveSpeed(random.uniform(60, 80))
    wait(random.uniform(0.5, 1))
    victim.setMoveSpeed(100)

rule "moira: apply speed when healed by orb":
    @Event playerDealtHealing
    @Condition healer.getCurrentHero() == Hero.MOIRA
    @Condition eventAbility == Button.ABILITY_2
    @Condition healer != healer
    healee.setMoveSpeed(random.uniform(90, 120))
    wait(random.uniform(0.5, 1))
    healee.setMoveSpeed(100)