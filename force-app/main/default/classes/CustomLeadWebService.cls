@RestResource(urlMapping='/api/v1/customlead/*')
global with sharing class CustomLeadWebService {
    
    @HttpPost
    global static LeadResponseData createLeadRecord() {
        LeadResponseData responseData = new LeadResponseData();
        
        try {
            RestRequest req = RestContext.request;
            String requestBody = req.requestBody.toString();
            LeadInputData leadData = (LeadInputData) JSON.deserialize(requestBody, LeadInputData.class);
            
            if (String.isBlank(leadData.LastName)) {
                responseData.isSuccess = false;
                responseData.responseMessage = 'LastName is required';
                RestContext.response.statusCode = 400;
                return responseData;
            }
            
            Lead newLead = new Lead();
            newLead.FirstName = leadData.FirstName;
            newLead.LastName = leadData.LastName;
            newLead.Phone = leadData.Phone;
            newLead.Email = leadData.Email;
            newLead.Street = leadData.Street;
            newLead.City = leadData.City;
            newLead.State = leadData.State;
            newLead.Country = leadData.Country;
            newLead.PostalCode = leadData.PostalCode;
            newLead.Company = String.isNotBlank(leadData.LastName) ? leadData.LastName + ' Company' : 'Unknown';
            newLead.Weight__c = leadData.Weight;
            newLead.Height__c = leadData.Height;
            newLead.ExternalId__c = leadData.ExternalId;
            
            insert newLead;
            
            responseData.isSuccess = true;
            responseData.responseMessage = 'Lead created successfully';
            responseData.recordId = newLead.Id;
            RestContext.response.statusCode = 201;
            
        } catch (Exception e) {
            responseData.isSuccess = false;
            responseData.responseMessage = 'Error: ' + e.getMessage();
            RestContext.response.statusCode = 500;
        }
        
        return responseData;
    }
    
    global class LeadInputData {
        public String FirstName;
        public String LastName;
        public String Phone;
        public String Email;
        public String Street;
        public String City;
        public String State;
        public String Country;
        public String PostalCode;
        public Decimal Weight;
        public Decimal Height;
        public String ExternalId;
    }
    
    global class LeadResponseData {
        public Boolean isSuccess;
        public String responseMessage;
        public String recordId;
    }
}