#!mainFile "../main.opy"

globalvar lucioBoopTrigger

rule "lúcio: boops decrease gravity":
    @Event playerDealtDamage
    @Condition attacker.getCurrentHero() == Hero.LUCIO
    @Condition eventAbility == Button.SECONDARY_FIRE
    @Condition getState(lucioBoopTrigger, victim) == 0
    toggleState(lucioBoopTrigger, victim)
    victim.setStatusEffect(attacker, Status.STUNNED, 0.85)
    wait(0.85)
    toggleState(lucioBoopTrigger, victim)