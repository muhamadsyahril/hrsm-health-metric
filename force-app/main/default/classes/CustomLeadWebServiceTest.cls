@isTest
private class CustomLeadWebServiceTest {
    
    @isTest
    static void testCreateLeadSuccess() {
        // Prepare request body
        String jsonBody = JSON.serialize(new LeadRestService.LeadRequest(
            FirstName = 'John',
            LastName = 'Doe',
            Phone = '1234567890',
            Email = 'john.doe@example.com',
            Street = '123 Main St',
            City = 'San Francisco',
            State = 'CA',
            Country = 'USA',
            PostalCode = '94105',
            Weight = 70.5,
            Height = 180.2,
            ExternalId = 'EXT-001'
        ));

        // Simulate REST request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestUri = '/services/apexrest/api/lead/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(jsonBody);

        RestContext.request = req;
        RestContext.response = res;

        // Call method
        LeadRestService.ResponseWrapper response = LeadRestService.createLead();

        // Assertions
        System.assertEquals(true, response.success);
        System.assertEquals('Lead created successfully', response.message);
        System.assertNotEquals(null, response.leadId);

        // Verify the lead was inserted
        Lead insertedLead = [SELECT Id, FirstName, LastName, Email, ExternalId__c FROM Lead WHERE Id = :response.leadId];
        System.assertEquals('John', insertedLead.FirstName);
        System.assertEquals('Doe', insertedLead.LastName);
        System.assertEquals('john.doe@example.com', insertedLead.Email);
        System.assertEquals('EXT-001', insertedLead.ExternalId__c);
    }
    
    @isTest
    static void testCreateLeadMissingLastName() {
        // Missing LastName to trigger validation error
        String jsonBody = JSON.serialize(new LeadRestService.LeadRequest(
            FirstName = 'Jane',
            Phone = '9876543210'
        ));

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestUri = '/services/apexrest/api/lead/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(jsonBody);

        RestContext.request = req;
        RestContext.response = res;

        LeadRestService.ResponseWrapper response = LeadRestService.createLead();

        System.assertEquals(false, response.success);
        System.assertEquals('LastName is required', response.message);
        System.assertEquals(400, RestContext.response.statusCode);
    }
    
    @isTest
    static void testCreateLeadException() {
        // Force exception by providing invalid decimal
        String invalidJson = '{"FirstName":"Mark","LastName":"Smith","Weight":"NOT_A_DECIMAL"}';

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestUri = '/services/apexrest/api/lead/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(invalidJson);

        RestContext.request = req;
        RestContext.response = res;

        LeadRestService.ResponseWrapper response = LeadRestService.createLead();

        System.assertEquals(false, response.success);
        System.assert(response.message.startsWith('Error:'));
        System.assertEquals(500, RestContext.response.statusCode);
    }
}