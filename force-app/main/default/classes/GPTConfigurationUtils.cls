/*
    GPTCustomMetadataCallback
    Author: Michael Holt
    Date: 27th Jan 2023

    Handles the updating of GPT_Key__mdt records and fields
*/

public with sharing class GPTConfigurationUtils {

    /*
        getGPTMetadata
        Gets the current GPT metadata values, but not the API key for security reasons
    */
    @AuraEnabled(cacheable=true)
    public static GPT_Key__mdt getGPTMetadata(){
        return  ([SELECT MHolt__Context_Words__c, MHolt__Max_Tokens__c, MHolt__Temperature__c, MHolt__Top_P__c
                    FROM GPT_Key__mdt
                    WHERE DeveloperName = 'GPTkey'][0]);
    }    

    /*
        saveGPTMetadata
        Creates a new custom metadata record with a dev name of GPTkey or updates
        the existing CMT with this dev name if it already exists.
        If it does already exist, the key will be preserved if the user hasn't added one
        This allows admins to update randomness features like temperature, without always having to update the same API key
    */
    @AuraEnabled
    public static String saveGPTMetadata(String key, String contextWords, String maxTokens, String temperature, String topP){
        
        //Update settings without having to remember the key every time
        if(key == '' || key == null){
            GPT_Key__mdt GPTMetadata = [SELECT Key__c
                                        FROM GPT_Key__mdt
                                        WHERE DeveloperName = 'GPTkey'];
            key = GPTMetadata.Key__c;
        }

        try{
            Metadata.CustomMetadata customMetadata =  new Metadata.CustomMetadata();
            customMetadata.fullName = 'GPT_Key__mdt.'+'GPTkey';
            customMetadata.label = 'Key';

            Metadata.CustomMetadataValue keyField = new Metadata.CustomMetadataValue();
            keyField.field = 'MHolt__Key__c';
            keyField.value = key;
            customMetadata.values.add(keyField);

            keyField = new Metadata.CustomMetadataValue();
            keyField.field = 'MHolt__Context_Words__c';
            keyField.value = contextWords;
            customMetadata.values.add(keyField);

            keyField = new Metadata.CustomMetadataValue();
            keyField.field = 'MHolt__Max_Tokens__c';
            keyField.value = maxTokens;
            customMetadata.values.add(keyField);

            keyField = new Metadata.CustomMetadataValue();
            keyField.field = 'MHolt__Temperature__c';
            keyField.value = temperature;
            customMetadata.values.add(keyField);

            keyField = new Metadata.CustomMetadataValue();
            keyField.field = 'MHolt__Top_P__c';
            keyField.value = topP;
            customMetadata.values.add(keyField);

            Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
            mdContainer.addMetadata(customMetadata);
            MHolt.GPTCustomMetadataCallback callback = new MHolt.GPTCustomMetadataCallback();
            Id jobId = Metadata.Operations.enqueueDeployment(mdContainer, callback);
            return 'Success';
        }catch(Exception e){
            return e.getMessage();
        }
    }
}