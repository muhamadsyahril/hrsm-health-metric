public with sharing class HealthMetricsApexController {
    
    @AuraEnabled
    public static Account fetchAccountHealthData(String accountId) {
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
    public static void persistAccountHealthMetrics(String accountId, Decimal bmiValue, String statusValue) {
        try {
            Account acc = new Account(
                Id = accountId,
                BMI__c = bmiValue,
                Weight_Status__c = statusValue
            );
            update acc;
        } catch (Exception e) {
            throw new AuraHandledException('Error updating account: ' + e.getMessage());
        }
    }
}