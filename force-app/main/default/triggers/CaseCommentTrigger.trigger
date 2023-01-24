trigger CaseCommentTrigger on CaseComment (After Insert) {
    GPTUtils.getGPTResponseForCaseComments(Trigger.newMap.keySet());
}