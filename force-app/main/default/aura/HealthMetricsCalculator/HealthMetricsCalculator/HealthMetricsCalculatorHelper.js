({
    loadAccountData: function(component, recordId) {
        var action = component.get("c.getAccountData");
        action.setParams({
            accountId: recordId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var account = response.getReturnValue();
                if (account) {
                    component.set("v.name", account.Name);
                    component.set("v.height", account.Height__c);
                    component.set("v.weight", account.Weight__c);
                    component.set("v.age", account.Age__c);
                    
                    // If BMI already exists, show it
                    if (account.BMI__c && account.Weight_Status__c) {
                        component.set("v.bmi", account.BMI__c);
                        component.set("v.weightStatus", account.Weight_Status__c);
                        component.set("v.showResults", true);
                        
                        // Set status class based on weight status
                        var statusClass = this.getStatusClass(account.Weight_Status__c);
                        component.set("v.statusClass", statusClass);
                    }
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                this.showToast('Error', 'Error loading account data', 'error');
            }
        });
        
        $A.enqueueAction(action);
    },
    
    updateAccountBMI: function(component, recordId, bmi, weightStatus) {
        var action = component.get("c.updateAccountBMI");
        action.setParams({
            accountId: recordId,
            bmi: bmi,
            weightStatus: weightStatus
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                this.showToast('Success', 'BMI updated on Account record', 'success');
            } else if (state === "ERROR") {
                var errors = response.getError();
                this.showToast('Error', 'Error updating account', 'error');
            }
        });
        
        $A.enqueueAction(action);
    },
    
    getStatusClass: function(weightStatus) {
        if (weightStatus === 'Normal') {
            return 'slds-theme_success';
        } else if (weightStatus === 'Underweight' || weightStatus === 'Overweight') {
            return 'slds-theme_warning';
        } else if (weightStatus === 'Obese') {
            return 'slds-theme_error';
        }
        return '';
    },
    
    showToast: function(title, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        if (toastEvent) {
            toastEvent.setParams({
                title: title,
                message: message,
                type: type,
                duration: 3000
            });
            toastEvent.fire();
        }
    }
})