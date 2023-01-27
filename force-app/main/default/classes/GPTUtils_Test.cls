@isTest
public with sharing class GPTUtils_Test {

    @isTest
    public static void insertCase(){
        Case c = new Case (subject = 'Subject', description = 'Description', origin='Email');
        
        Test.startTest();
            List<MHolt__GPT_Response__c> gr = [SELECT id FROM MHolt__GPT_Response__c];
        Test.stopTest();

        //Needs to be a callout test

        System.assertEquals(1, gr.size());
    }

}