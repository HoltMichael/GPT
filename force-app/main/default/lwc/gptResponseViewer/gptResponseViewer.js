import { LightningElement, wire, api } from 'lwc';
import { getRelatedListRecords } from 'lightning/uiRelatedListApi';
import hasAccess from '@salesforce/apex/GPTUtils.checkUserHasAssignedPermissionSet';


export default class GptResponseViewer extends LightningElement {
    @api recordId;
    responses;
    error;
    @wire(hasAccess)userAccess;


    @wire(getRelatedListRecords, {
        parentRecordId: '$recordId',
        relatedListId: 'MHolt__GPT_Responses__r',
        fields: ['MHolt__GPT_Response__c.MHolt__Response__c', 'MHolt__GPT_Response__c.id', 'MHolt__GPT_Response__c.MHolt__Input__c'],
        sortBy: ['MHolt__GPT_Response__c.CreatedDate']
    })response({ error, data }) {
        if (data) {
            this.responses = data.records;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.records = undefined;
        }
    };
}