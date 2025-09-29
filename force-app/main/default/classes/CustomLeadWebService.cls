@RestResource(urlMapping='/api/lead/*')
global with sharing class CustomLeadWebService {
    
    @HttpPost
    global static ResponseWrapper createLead() {
        ResponseWrapper response = new ResponseWrapper();
        
        try {
            RestRequest req = RestContext.request;
            String requestBody = req.requestBody.toString();
            LeadRequest leadReq = (LeadRequest) JSON.deserialize(requestBody, LeadRequest.class);
            
            // Validate required fields
            if (String.isBlank(leadReq.LastName)) {
                response.success = false;
                response.message = 'LastName is required';
                RestContext.response.statusCode = 400;
                return response;
            }
            
            // Create Lead record
            Lead newLead = new Lead();
            newLead.FirstName = leadReq.FirstName;
            newLead.LastName = leadReq.LastName;
            newLead.Phone = leadReq.Phone;
            newLead.Email = leadReq.Email;
            newLead.Street = leadReq.Street;
            newLead.City = leadReq.City;
            newLead.State = leadReq.State;
            newLead.Country = leadReq.Country;
            newLead.PostalCode = leadReq.PostalCode;
            newLead.Company = String.isNotBlank(leadReq.LastName) ? leadReq.LastName + ' Company' : 'Unknown';
            
            // Custom fields (ensure these exist in your org)
            newLead.Weight__c = leadReq.Weight;
            newLead.Height__c = leadReq.Height;
            newLead.ExternalId__c = leadReq.ExternalId;
            
            insert newLead;
            
            response.success = true;
            response.message = 'Lead created successfully';
            response.leadId = newLead.Id;
            RestContext.response.statusCode = 201;
            
        } catch (Exception e) {
            response.success = false;
            response.message = 'Error: ' + e.getMessage();
            RestContext.response.statusCode = 500;
        }
        
        return response;
    }
    
    // Request wrapper class
    global class LeadRequest {
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
    
    // Response wrapper class
    global class ResponseWrapper {
        public Boolean success;
        public String message;
        public String leadId;
    }
}