@isTest
private class CustomLeadWebServiceTest {
    
    @isTest
    static void testCreateLeadRecordSuccess() {
        // Setup test data
        String requestBody = JSON.serialize(new Map<String, Object>{
            'FirstName' => 'John',
            'LastName' => 'Doe',
            'Phone' => '1234567890',
            'Email' => 'john.doe@example.com',
            'Street' => '123 Main St',
            'City' => 'San Francisco',
            'State' => 'CA',
            'Country' => 'USA',
            'PostalCode' => '94105',
            'Weight' => 75.5,
            'Height' => 180,
            'ExternalId' => 'EXT123'
        });
        
        // Setup REST context
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/api/v1/customlead/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(requestBody);
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        CustomLeadWebService.LeadResponseData responseData = CustomLeadWebService.createLeadRecord();
        Test.stopTest();
        
        // Assertions
        System.assertEquals(true, responseData.isSuccess, 'Response should be successful');
        System.assertEquals('Lead created successfully', responseData.responseMessage);
        System.assertNotEquals(null, responseData.recordId, 'Lead ID should not be null');
        System.assertEquals(201, RestContext.response.statusCode);
        
        // Verify Lead was created
        Lead createdLead = [SELECT Id, FirstName, LastName, Email, Phone, Weight__c, Height__c, ExternalId__c 
                           FROM Lead WHERE Id = :responseData.recordId];
        System.assertEquals('John', createdLead.FirstName);
        System.assertEquals('Doe', createdLead.LastName);
        System.assertEquals('john.doe@example.com', createdLead.Email);
        System.assertEquals(75.5, createdLead.Weight__c);
        System.assertEquals(1.75, createdLead.Height__c);
        System.assertEquals('EXT123', createdLead.ExternalId__c);
    }
    
    @isTest
    static void testCreateLeadRecordMissingLastName() {
        // Setup test data without LastName
        String requestBody = JSON.serialize(new Map<String, Object>{
            'FirstName' => 'John',
            'Email' => 'john.doe@example.com'
        });
        
        // Setup REST context
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/api/v1/customlead/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(requestBody);
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        CustomLeadWebService.LeadResponseData responseData = CustomLeadWebService.createLeadRecord();
        Test.stopTest();
        
        // Assertions
        System.assertEquals(false, responseData.isSuccess, 'Response should fail');
        System.assertEquals('LastName is required', responseData.responseMessage);
        System.assertEquals(400, RestContext.response.statusCode);
    }
    
    @isTest
    static void testCreateLeadRecordMinimalData() {
        // Setup test data with minimal required fields
        String requestBody = JSON.serialize(new Map<String, Object>{
            'LastName' => 'Smith'
        });
        
        // Setup REST context
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/api/v1/customlead/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(requestBody);
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        CustomLeadWebService.LeadResponseData responseData = CustomLeadWebService.createLeadRecord();
        Test.stopTest();
        
        // Assertions
        System.assertEquals(true, responseData.isSuccess, 'Response should be successful');
        System.assertNotEquals(null, responseData.recordId);
        
        Lead createdLead = [SELECT Id, LastName FROM Lead WHERE Id = :responseData.recordId];
        System.assertEquals('Smith', createdLead.LastName);
    }
}