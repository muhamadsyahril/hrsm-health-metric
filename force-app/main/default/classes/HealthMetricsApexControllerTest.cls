@isTest
private class HealthMetricsApexControllerTest {
    
    @testSetup
    static void setupTestData() {
        // Create test account with custom fields
        Account testAcc = new Account(
            Name = 'Test Account',
            Height__c = 1.75,
            Weight__c = 70.0,
            Age__c = 30,
            BMI__c = 22.9,
            Weight_Status__c = 'Normal'
        );
        insert testAcc;
    }
    
    @isTest
    static void testFetchAccountHealthData() {
        Account acc = [SELECT Id FROM Account LIMIT 1];
        
        Test.startTest();
        Account result = HealthMetricsApexController.fetchAccountHealthData(acc.Id);
        Test.stopTest();
        
        System.assertNotEquals(null, result, 'Account should be returned');
        System.assertEquals('Test Account', result.Name);
        System.assertEquals(1.75, result.Height__c);
        System.assertEquals(70.0, result.Weight__c);
        System.assertEquals(30, result.Age__c);
        System.assertEquals(22.9, result.BMI__c);
        System.assertEquals('Normal', result.Weight_Status__c);
    }
    
    @isTest
    static void testFetchAccountHealthDataInvalidId() {
        
        Test.startTest();
        Object result = HealthMetricsApexController.fetchAccountHealthData('001000000000000');
        Test.stopTest();
        
        System.assertEquals(null, result, 'Should return null for invalid account Id');
    }
    
    @isTest
    static void testPersistAccountHealthMetrics() {
        Account acc = [SELECT Id FROM Account LIMIT 1];
        
        Test.startTest();
        HealthMetricsApexController.persistAccountHealthMetrics(acc.Id, 25.5, 'Overweight');
        Test.stopTest();
        
        Account updatedAcc = [SELECT Id, BMI__c, Weight_Status__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(25.5, updatedAcc.BMI__c, 'BMI should be updated');
        System.assertEquals('Overweight', updatedAcc.Weight_Status__c, 'Weight status should be updated');
    }
    
    @isTest
    static void testPersistAccountHealthMetricsUnderweight() {
        Account acc = [SELECT Id FROM Account LIMIT 1];
        
        Test.startTest();
        HealthMetricsApexController.persistAccountHealthMetrics(acc.Id, 17.5, 'Underweight');
        Test.stopTest();
        
        Account updatedAcc = [SELECT Id, BMI__c, Weight_Status__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(17.5, updatedAcc.BMI__c);
        System.assertEquals('Underweight', updatedAcc.Weight_Status__c);
    }
    
    @isTest
    static void testPersistAccountHealthMetricsObese() {
        Account acc = [SELECT Id FROM Account LIMIT 1];
        
        Test.startTest();
        HealthMetricsApexController.persistAccountHealthMetrics(acc.Id, 32.0, 'Obese');
        Test.stopTest();
        
        Account updatedAcc = [SELECT Id, BMI__c, Weight_Status__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(32.0, updatedAcc.BMI__c);
        System.assertEquals('Obese', updatedAcc.Weight_Status__c);
    }
}