/*
    GPTCustomMetadataCallback
    Author: Michael Holt
    Date: 27th Jan 2023

    Class to allow custom metadata to be inserted. 
*/

public class GPTUtils {
    //https://beta.openai.com/docs/api-reference/completions
    public static final String ENDPOINT ='https://api.openai.com/v1/completions';


    /*
        getGPTResponseForCaseComments
        Creates a GPT record based on the response from GPT to a callout with case comment body
        Links the GPT_Response record to the parent case of the case comment record 
    */
    @future (callout=true)
    public static void getGPTResponseForCaseComments(Set<Id> commentIds){
        List<CaseComment> comments = [SELECT id, CommentBody, ParentId 
                                        FROM CaseComment
                                        WHERE Id in :commentIds];
        List<GPT_Response__c> gptResponses = new List<GPT_Response__c>();
        for(CaseComment cc : comments){
            String response = handleGPTRequest(cc.CommentBody);
            String parsedResponse = parseResponse(response);
            GPT_Response__c res = new GPT_Response__c(Raw_Response__c = response, Response__c = parsedResponse, Case__c = cc.ParentId, Input__c = cc.CommentBody);
            gptResponses.add(res);
        }
        
        insert gptResponses;
    }

    /*
        getGPTResponseForCases
        Creates a GPT record based on the response from GPT to a callout with subject and case description
        Links the GPT_Response record to the case 
    */
    @future (callout=true)
    public static void getGPTResponseForCases(Set<Id> caseIds){
        List<Case> cases = [SELECT id, subject, description 
                            FROM Case 
                            WHERE ID in :CaseIds];

        List<GPT_Response__c> gptResponses = new List<GPT_Response__c>();
        for(case c : cases){
            String input = c.subject + ' ' + c.description;
            String response = handleGPTRequest(input);
            String parsedResponse = parseResponse(response);
            
            GPT_Response__c res = new GPT_Response__c(Raw_Response__c = response, Response__c = parsedResponse, Case__c = c.id, Input__c = input);
            gptResponses.add(res);
        }

        insert gptResponses;
    }

    /*
        parseResponse
        Parses the response from the callout to GPT and returns the text parameter; the human readable response
    */
    public static String parseResponse(String jsonString){
        JSONParser parser = JSON.createParser(jsonString);
        String parsedResponse = '';
        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                (parser.getText() == 'text')) {
                // Get the value for the 'text' field in the JSON response from GPT
                parser.nextToken();
                parsedResponse = parser.getText();
            }
        }
        return parsedResponse;
    }


    /*
        handleGPTRequest
        Takes a String to be sent to the GPT APIs and returns the payload from the endpoint
    */
    public static String handleGPTRequest(String message){
        GPT_Key__mdt key = [SELECT Key__c, Context_Words__c, Max_Tokens__c, Temperature__c, Top_P__c
                                FROM GPT_Key__mdt
                                WHERE DeveloperName = 'GPTkey'][0];
            System.debug(key);

            String body = '{"model": "text-davinci-003","prompt":"'+ key.MHolt__Context_Words__c  + ': ' + message + '","temperature": ' + key.MHolt__Temperature__c + ',"top_p": ' + key.MHolt__Top_P__c + ',"max_tokens":' + key.MHolt__Max_Tokens__c + '}';
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');
            req.setEndpoint(ENDPOINT);
            req.setHeader('Authorization', 'Bearer '+key.key__c);
            req.setHeader('Content-Type', 'application/json;charset=UTF-8');
            req.setBody(body);

            Http api = new Http();
            HttpResponse response = api.send(req);

            return response.getBody();
    }
}