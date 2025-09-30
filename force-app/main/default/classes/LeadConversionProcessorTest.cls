@isTest
private class LeadConversionProcessorTest {
    
    @isTest
    static void testAutoLeadConversion() {
        Lead testLead = new Lead();
        testLead.FirstName = 'Jane';
        testLead.LastName = 'Smith';
        testLead.Company = 'Test Company';
        testLead.Phone = '9876543210';
        testLead.Email = 'jane.smith@test.com';
        testLead.Weight__c = 65.0;
        testLead.Height__c = 1.65;
        testLead.ExternalId__c = 'EXT456';
        
        Test.startTest();
        insert testLead;
        Test.stopTest();
        
        Lead convertedLead = [SELECT Id, IsConverted, ConvertedAccountId, ConvertedContactId 
                             FROM Lead WHERE Id = :testLead.Id];
        System.assertEquals(true, convertedLead.IsConverted);
        System.assertNotEquals(null, convertedLead.ConvertedAccountId);
        System.assertNotEquals(null, convertedLead.ConvertedContactId);
    }
    
    @isTest
    static void testLeadNotConvertedWithMissingFields() {
        Lead testLead = new Lead();
        testLead.FirstName = 'John';
        testLead.LastName = 'Doe';
        testLead.Company = 'Test Company';
        testLead.Phone = '1234567890';
        testLead.Email = 'john.doe@test.com';
        testLead.Weight__c = 70.0;
        testLead.Height__c = 1.80;
        
        Test.startTest();
        insert testLead;
        Test.stopTest();
        
        Lead notConvertedLead = [SELECT Id, IsConverted FROM Lead WHERE Id = :testLead.Id];
        System.assertEquals(false, notConvertedLead.IsConverted);
    }
}