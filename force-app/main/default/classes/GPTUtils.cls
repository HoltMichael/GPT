public class GPTUtils {
    //https://beta.openai.com/docs/api-reference/completions
    public static final String ENDPOINT ='https://api.openai.com/v1/completions';
    public static final Decimal TEMPERATURE = 0.6; //Randomness
    public static final Decimal TOP_P = 1; //Probability Mass
    public static final Integer MAX_TOKENS = 2048; //Maximum number of tokens to generate and return (includes count of prompt tokens as well)
    

    @future (callout=true)
    public static void getGPTResponseForCases(Set<Id> caseIds){

        List<Case> cases = [SELECT id, subject, description 
                            FROM Case WHERE ID in :CaseIds];


        List<GPT_Response__c> cgptResponses = new List<GPT_Response__c>();
        for(case c : cases){
            String input = c.subject + ' ' + c.description;
            String response = handleGPTRequest(input);
            GPT_Response__c res = new GPT_Response__c(Response__c = response, Case__c = c.id, Input__c = input);
            cgptResponses.add(res);
        }

        insert cgptResponses;
    }



    public static String handleGPTRequest(String message){
        GPT_Key__mdt key = [SELECT Key__c
                                FROM GPT_Key__mdt][0];

            String body = '{"model": "text-davinci-003","prompt":"'+ message + '","temperature": ' + TEMPERATURE + ',"top_p": ' + TOP_P + ',"max_tokens":' + MAX_TOKENS + '}';
            System.debug(body);
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');
            req.setEndpoint(ENDPOINT);
            req.setHeader('Authorization', 'Bearer '+key.key__c);
            req.setHeader('Content-Type', 'application/json;charset=UTF-8');
            req.setBody(body);

            Http api = new Http();
            HttpResponse response = api.send(req);

            System.debug('Code: ' + response.getStatusCode());
            System.debug('Response: ' + response.getBody());

            return response.getBody();
    }
}