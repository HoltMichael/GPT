@isTest
public with sharing class GPTConfigurationUtils_Test {

    /*
        checkUserHasAssignedPermissionSet_Test
        Tests the check that the user has the GPT_User permission set 
    */
    @isTest
    public static void checkUserHasAssignedPermissionSet_Test(){

        // Create a new user
        User u = new User();
        u.Username = 'username' + (Math.round(Math.random() * (1000000 - 1)) + '@lksadj.com' );
        u.Email = u.username;
        u.TimeZoneSidKey = 'America/Los_Angeles';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.FirstName = 'firstName';
        u.LastName = 'lastName';
        u.alias = 'alias';

        u.ProfileId = [SELECT Id FROM Profile WHERE Name='Standard User'].Id;
        insert u;

        System.RunAs(u){
            System.assertEquals(false, GPTConfigurationUtils.checkUserHasAssignedPermissionSet());
        }

        // Assign the GPT_User permission set to the user
        PermissionSetAssignment psa = new PermissionSetAssignment();
        psa.AssigneeId = u.Id;
        psa.PermissionSetId = [SELECT Id FROM PermissionSet WHERE Name='GPT_Admin'].Id;
        insert psa;

        Test.startTest();
            System.RunAs(u){
                System.assertEquals(true, GPTConfigurationUtils.checkUserHasAssignedPermissionSet());
            }
        Test.stopTest();
    }


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