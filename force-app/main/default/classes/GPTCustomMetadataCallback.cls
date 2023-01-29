/*
    GPTCustomMetadataCallback
    Author: Michael Holt
    Date: 27th Jan 2023

    Class to allow custom metadata to be inserted. 
*/

public without sharing class GPTCustomMetadataCallback implements Metadata.DeployCallback {
    public void handleResult(Metadata.DeployResult result,
                             Metadata.DeployCallbackContext context) {
        if (result.status == Metadata.DeployStatus.Succeeded) {
        } else {
            // Deployment was not successful

        }
    }
}