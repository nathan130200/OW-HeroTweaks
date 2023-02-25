#!mainFile "../main.opy"

globalvar lucioBoopTrigger

rule "lúcio: boops decrease gravity":
    @Event playerDealtDamage
    @Condition attacker.getCurrentHero() == Hero.LUCIO
    @Condition eventAbility == Button.SECONDARY_FIRE
    @Condition getState(lucioBoopTrigger, victim) == 0
    setState(lucioBoopTrigger, victim, 1)
    victim.setStatusEffect(attacker, Status.STUNNED, 0.85)
    wait(0.85)
    setState(lucioBoopTrigger, victim, 0)