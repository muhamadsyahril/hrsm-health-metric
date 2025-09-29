@isTest
private class LeadConversionProcessorTest {
    
    @isTest
    static void testLeadAutoConversion() {
        // Create a lead with all required fields
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
        
        // Verify lead was converted
        Lead convertedLead = [SELECT Id, IsConverted, ConvertedAccountId, ConvertedContactId 
                             FROM Lead WHERE Id = :testLead.Id];
        System.assertEquals(true, convertedLead.IsConverted, 'Lead should be converted');
        System.assertNotEquals(null, convertedLead.ConvertedAccountId, 'Account should be created');
        System.assertNotEquals(null, convertedLead.ConvertedContactId, 'Contact should be created');
        
        // Verify Account was created
        Account acc = [SELECT Id, Name FROM Account WHERE Id = :convertedLead.ConvertedAccountId];
        System.assertNotEquals(null, acc);
        
        // Verify Contact was created
        Contact con = [SELECT Id, FirstName, LastName, Email FROM Contact WHERE Id = :convertedLead.ConvertedContactId];
        System.assertEquals('Jane', con.FirstName);
        System.assertEquals('Smith', con.LastName);
        System.assertEquals('jane.smith@test.com', con.Email);
    }
    
    @isTest
    static void testLeadNotConvertedMissingFields() {
        // Create a lead without all required fields (missing ExternalId)
        Lead testLead = new Lead();
        testLead.FirstName = 'John';
        testLead.LastName = 'Doe';
        testLead.Company = 'Test Company';
        testLead.Phone = '1234567890';
        testLead.Email = 'john.doe@test.com';
        testLead.Weight__c = 70.0;
        testLead.Height__c = 1.80;
        // ExternalId__c is null
        
        Test.startTest();
        insert testLead;
        Test.stopTest();
        
        // Verify lead was NOT converted
        Lead notConvertedLead = [SELECT Id, IsConverted FROM Lead WHERE Id = :testLead.Id];
        System.assertEquals(false, notConvertedLead.IsConverted, 'Lead should not be converted');
    }
    
    @isTest
    static void testLeadUpdateTriggersConversion() {
        // Create a lead without all required fields
        Lead testLead = new Lead();
        testLead.FirstName = 'Mike';
        testLead.LastName = 'Johnson';
        testLead.Company = 'Test Company';
        testLead.Phone = '5555555555';
        testLead.Email = 'mike.johnson@test.com';
        testLead.Weight__c = 80.0;
        testLead.Height__c = 1.85;
        // ExternalId__c is null initially
        insert testLead;
        
        // Verify not converted yet
        Lead checkLead = [SELECT Id, IsConverted FROM Lead WHERE Id = :testLead.Id];
        System.assertEquals(false, checkLead.IsConverted);
        
        Test.startTest();
        // Update with ExternalId to trigger conversion
        testLead.ExternalId__c = 'EXT789';
        update testLead;
        Test.stopTest();
        
        // Verify lead was converted after update
        Lead convertedLead = [SELECT Id, IsConverted FROM Lead WHERE Id = :testLead.Id];
        System.assertEquals(true, convertedLead.IsConverted, 'Lead should be converted after update');
    }
}