public with sharing class HealthMetricsApexController {
    
    @AuraEnabled
    public static Account getAccountData(String accountId) {
        try {
            return [SELECT Id, Name, Height__c, Weight__c, Age__c, BMI__c, Weight_Status__c
                   FROM Account 
                   WHERE Id = :accountId 
                   LIMIT 1];
        } catch (Exception e) {
            throw new AuraHandledException('Error retrieving account data: ' + e.getMessage());
        }
    }
    
    @AuraEnabled
    public static void updateAccountBMI(String accountId, Decimal bmi, String weightStatus) {
        try {
            Account acc = new Account(
                Id = accountId,
                BMI__c = bmi,
                Weight_Status__c = weightStatus
            );
            update acc;
        } catch (Exception e) {
            throw new AuraHandledException('Error updating account: ' + e.getMessage());
        }
    }
}