import { LightningElement, api } from 'lwc';

export default class GptResponseItem extends LightningElement {
    @api text;
    @api prompt;

    showPrompt = false;
    buttonIcon = "utility:chevrondown";

    handleTogglePrompt(){
        this.showPrompt = !this.showPrompt;
        this.buttonIcon = this.buttonIcon == "utility:chevrondown" ? "utility:chevronup" : "utility:chevrondown";
    }
}