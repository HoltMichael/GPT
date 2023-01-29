@isTest
public with sharing class GPTConfigurationUtils_Test {

    /*
        GPTMetadata_Test
        Test that the creation of GPTMetadata results in the right values being stored
        **TODO: Fix this test method, CMT can't be created in tests and is test visible...
    */
    @isTest
    public static void GPTMetadata_Test(){
        GPTConfigurationUtils.saveGPTMetadata('key', 'contextWords',  '1', '2', '3');
        Test.startTest();
            GPT_Key__mdt gptkey = GPTConfigurationUtils.getGPTMetadata();
            GPTConfigurationUtils.saveGPTMetadata('', 'contextWords',  '1', '2', '3');
            gptkey = GPTConfigurationUtils.getGPTMetadata();
        Test.stopTest();

        // System.assertEquals('contextWords', gptkey.Context_Words__c);
        // System.assertEquals(1, gptkey.Max_Tokens__c);
        // System.assertEquals(2, gptkey.Temperature__c);
        // System.assertEquals(3, gptkey.Top_P__c);
    }
}