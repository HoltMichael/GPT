import { LightningElement, wire, api } from 'lwc';
import { getRelatedListRecords } from 'lightning/uiRelatedListApi';


export default class GptResponseViewer extends LightningElement {
    @api recordId;
    responses;
    error;

    @wire(getRelatedListRecords, {
        parentRecordId: '$recordId',
        relatedListId: 'MHolt__ChatGPT_Responses__r',
        fields: ['MHolt__Response__c','Id']
        // sortBy: ['Contact.Name']
    })response({ error, data }) {
        if (data) {
            console.log(data);
            this.responses = data.records;
            this.error = undefined;
        } else if (error) {
            console.log(error);
            this.error = error;
            this.records = undefined;
        }
    };
}