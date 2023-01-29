@isTest
public with sharing class GPTUtils_Test {



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
            System.assertEquals(false, GPTUtils.checkUserHasAssignedPermissionSet());
        }

        // Assign the GPT_User permission set to the user
        PermissionSetAssignment psa = new PermissionSetAssignment();
        psa.AssigneeId = u.Id;
        psa.PermissionSetId = [SELECT Id FROM PermissionSet WHERE Name='GPT_User'].Id;
        insert psa;

        Test.startTest();
            System.RunAs(u){
                System.assertEquals(true, GPTUtils.checkUserHasAssignedPermissionSet());
            }
        Test.stopTest();
    }

    /*
        insertCase_Test
        Test that when a case is created, a callout is made to GPT
    */
    @isTest
    public static void insertCase_Test(){
        Case c = new Case (subject = 'Subject', description = 'Description', origin='Email');        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        Test.startTest();
            insert c;
        Test.stopTest();

        List<MHolt__GPT_Response__c> gr = [SELECT id FROM MHolt__GPT_Response__c];
        System.assertEquals(1, gr.size());
    }

    /*
        insertCaseComment_Test
        Test that when a case comment is created, a callout is made to GPT
    */
    @isTest
    public static void insertCaseComment_Test(){
        Case c = new Case (subject = 'Subject', description = 'Description', origin='Email');   
        insert c;
        CaseComment cc = new CaseComment(CommentBody = 'Test Body', ParentId = c.id);
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        Test.startTest();
            insert cc;
        Test.stopTest();

        List<MHolt__GPT_Response__c> gr = [SELECT id FROM MHolt__GPT_Response__c];
        
        //2 GPT Responses will have been created, 1 for the case and 1 for the case comment
        System.assertEquals(2, gr.size());
    }


    /*
        getGPTResponseForCaseComments_Test
        Per insertCaseComment_Test but directly test the case comment callout method
    */
    @isTest
    public static void getGPTResponseForCaseComments_Test(){
        Case c = new Case (subject = 'Subject', description = 'Description', origin='Email');   
        insert c;
        CaseComment cc = new CaseComment(CommentBody = 'Test Body', ParentId = c.id);
        insert cc;
        Set<Id> ccIds = new Set<Id>{cc.id};
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        Test.startTest();
            GPTUtils.getGPTResponseForCaseComments(ccIds);
        Test.stopTest();

        List<MHolt__GPT_Response__c> gr = [SELECT id FROM MHolt__GPT_Response__c];
        //3 GPT Responses will have been created, 1 for inserting the case and case comment and a 3rd for directly testing the method
        System.assertEquals(3, gr.size());
    }

    /*
        getGPTResponseForCases_Test
        Per insertCase_Test but directly test the case callout method
    */
    @isTest
    public static void getGPTResponseForCases_Test(){
        Case c = new Case (subject = 'Subject', description = 'Description', origin='Email');   
        insert c;
        Set<Id> cIds = new Set<Id>{c.id};
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        Test.startTest();
            GPTUtils.getGPTResponseForCases(cIds);
        Test.stopTest();

        List<MHolt__GPT_Response__c> gr = [SELECT id FROM MHolt__GPT_Response__c];
        //3 GPT Responses will have been created, 1 for inserting the case and case a 2nd for directly testing the method
        System.assertEquals(2, gr.size());
    }

    /*
        parseResponse_Test
        Defines a real life example of a GPT response and tests that we are able to extract the human readable response text, "Test Response"
    */
    @isTest
    public static void parseResponse_Test(){
        String testJSON = '{"id":"cmpl-6cYIagtiL8GfocKxbu6DG2Cw8Algm","object":"text_completion","created":1674646328,"model":"text-davinci-003","choices":[{"text":"Test Response","index":0,"logprobs":null,"finish_reason":"stop"}],"usage":{"prompt_tokens":16,"completion_tokens":2,"total_tokens":18}}';

        Test.startTest();
            String response = GPTUtils.parseResponse(testJSON);
        Test.stopTest();
        System.assertEquals('Test Response', response);
    }

    /*
        handleGPTRequest_Test
        Tests the handleGPTRequest method, not the best test as it only really tests the response from the MockHttpResponseGenerator. 
    */
    @isTest
    public static void handleGPTRequest_Test(){
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        String testMessage = 'Random Text'; 
        Test.startTest();
            String response = GPTUtils.handleGPTRequest(testMessage);
        Test.stopTest();

        List<GPT_Key__mdt> keys = [SELECT Key__c, Context_Words__c, Max_Tokens__c, Temperature__c, Top_P__c
                                    FROM GPT_Key__mdt
                                    WHERE DeveloperName = 'GPTkey'];

        System.assertEquals('{"id":"cmpl-6cYIagtiL8GfocKxbu6DG2Cw8Algm","object":"text_completion","created":1674646328,"model":"text-davinci-003","choices":[{"text":"Test Response","index":0,"logprobs":null,"finish_reason":"stop"}],"usage":{"prompt_tokens":16,"completion_tokens":2,"total_tokens":18}}', response);
    }
    

}