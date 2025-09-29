public class LeadConversionProcessor {
    
    public static void handleLeadConversion(List<Lead> newLeads) {
        List<Database.LeadConvert> leadConverts = new List<Database.LeadConvert>();
        
        for (Lead l : newLeads) {
            // Check if all required fields are not null
            if (l.Phone != null && 
                l.Email != null && 
                l.Weight__c != null && 
                l.Height__c != null && 
                l.ExternalId__c != null &&
                !l.IsConverted) {
                
                Database.LeadConvert lc = new Database.LeadConvert();
                lc.setLeadId(l.Id);
                
                // Get default lead status for conversion
                LeadStatus convertStatus = [SELECT Id, MasterLabel 
                                           FROM LeadStatus 
                                           WHERE IsConverted = true 
                                           LIMIT 1];
                lc.setConvertedStatus(convertStatus.MasterLabel);
                
                // Don't create an opportunity
                lc.setDoNotCreateOpportunity(true);
                
                leadConverts.add(lc);
            }
        }
        
        // Convert leads if any qualify
        if (!leadConverts.isEmpty()) {
            List<Database.LeadConvertResult> results = Database.convertLead(leadConverts, false);
            
            // Log any errors
            for (Database.LeadConvertResult result : results) {
                if (!result.isSuccess()) {
                    for (Database.Error err : result.getErrors()) {
                        System.debug('Lead conversion error: ' + err.getMessage());
                    }
                }
            }
        }
    }
}
