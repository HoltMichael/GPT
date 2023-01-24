trigger CaseTrigger on Case (After Insert) {
    GPTUtils.getGPTResponseForCases(Trigger.newMap.keySet());
}