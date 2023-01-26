import { LightningElement, wire, api } from 'lwc';
import { getRelatedListRecords } from 'lightning/uiRelatedListApi';


export default class GptResponseViewer extends LightningElement {
    @api recordId;
    responses;
    error;

    @wire(getRelatedListRecords, {
        parentRecordId: '$recordId',
        relatedListId: 'MHolt__GPT_Responses__r',
        fields: ['MHolt__GPT_Response__c.MHolt__Response__c', 'MHolt__GPT_Response__c.id', 'MHolt__GPT_Response__c.MHolt__Input__c'] 
        // sortBy: ['Contact.Name']
    })response({ error, data }) {
        if (data) {
            console.log(data);
            this.responses = data.records;
            console.log('Response:');
            console.log(this.responses[0]);
            this.error = undefined;
        } else if (error) {
            console.log(error);
            this.error = error;
            this.records = undefined;
        }
    };
}