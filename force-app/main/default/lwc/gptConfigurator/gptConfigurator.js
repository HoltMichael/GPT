import { LightningElement, wire } from 'lwc';
import save from '@salesforce/apex/GPTConfigurationUtils.saveGPTMetadata';
import load from '@salesforce/apex/GPTConfigurationUtils.getGPTMetadata';
import hasAccess from '@salesforce/apex/GPTConfigurationUtils.checkUserHasAssignedPermissionSet';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';




export default class GptConfigurator extends LightningElement {
    words;
    maxTokens;
    temperature;
    topP;

   @wire(hasAccess)userAccess;

    /*
        loadGPTMetadata
        Pull in the CMT data into the input fields, so users can see the current values
        Doesn't pull in the API key for sercurity reasons
    */
    @wire(load)
    loadGPTMetadata({ error, data }) {
        if (data) {
            this.words = data.MHolt__Context_Words__c;
            this.maxTokens = data.MHolt__Max_Tokens__c;
            this.temperature = data.MHolt__Temperature__c;
            this.topP = data.MHolt__Top_P__c
            console.log(this.userAccess);
        } else if (error) {
            console.log('error');
            console.log(error);
        }
    }

    /*
        handleClick
        Get all of values from all the input fields on screen and call the Apex method to store them all in CMT
    */
    handleClick(){
        let key = this.template.querySelectorAll("lightning-input")[0].value;
        let words = this.template.querySelectorAll("lightning-input")[1].value;
        let maxTokens = this.template.querySelectorAll("lightning-input")[2].value;
        let temperature = this.template.querySelectorAll("lightning-input")[3].value;
        let topP = this.template.querySelectorAll("lightning-input")[4].value;

        save({key: key, contextWords: words, maxTokens: maxTokens, temperature: temperature, topP: topP})
        .then((result) => {
            this.showToast('Success', result, 'success');
        }).catch((error) => {
            this.showToast('Error', error, 'error');
        })
    }

    /*
        handleFindKey
        Open the (current - Jan 2023) URL for opening the Open API Api Key window
    */
    handleFindKey(){
        window.open('https://beta.openai.com/account/api-keys');
    }


    /*
        showToast
        Fires a toast with a specified title and message
        Variant changes colour, according to slds Toast specs
    */
    showToast(title, msg, variant) {

        const event = new ShowToastEvent({
            title: title,
            message: msg,
            variant: variant
        });
        this.dispatchEvent(event);
    }


}