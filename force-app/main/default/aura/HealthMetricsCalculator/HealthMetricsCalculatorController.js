({
    doInit: function(component, event, helper) {
        // Load account data if recordId is available
        var recordId = component.get("v.recordId");
        if (recordId) {
            helper.loadAccountData(component, recordId);
        }
    },
    
    handleInputChange: function(component, event, helper) {
        // Input values are automatically bound to attributes
    },
    
    calculateBMI: function(component, event, helper) {
        var height = component.get("v.height");
        var weight = component.get("v.weight");
        var age = component.get("v.age");
        
        // Validation
        if (!age || !height || !weight) {
            helper.showToast('Error', 'Please fill in all fields', 'error');
            return;
        }
        
        if (height <= 0 || weight <= 0) {
            helper.showToast('Error', 'Height and weight must be positive numbers', 'error');
            return;
        }
        
        // Calculate BMI: weight (kg) / height (m)^2
        var bmi = weight / (height * height);
        bmi = Math.round(bmi * 10) / 10; // Round to 1 decimal place
        
        // Determine weight status
        var weightStatus = '';
        var statusClass = '';
        
        if (bmi < 18.5) {
            weightStatus = 'Underweight';
            statusClass = 'slds-theme_warning';
        } else if (bmi >= 18.5 && bmi <= 24.9) {
            weightStatus = 'Normal';
            statusClass = 'slds-theme_success';
        } else if (bmi >= 25.0 && bmi <= 29.9) {
            weightStatus = 'Overweight';
            statusClass = 'slds-theme_warning';
        } else {
            weightStatus = 'Obese';
            statusClass = 'slds-theme_error';
        }
        
        // Set results
        component.set("v.bmi", bmi);
        component.set("v.weightStatus", weightStatus);
        component.set("v.statusClass", statusClass);
        component.set("v.showResults", true);
        
        // Update Account record if recordId exists
        var recordId = component.get("v.recordId");
        if (recordId) {
            helper.updateAccountBMI(component, recordId, bmi, weightStatus);
        }
    }
})