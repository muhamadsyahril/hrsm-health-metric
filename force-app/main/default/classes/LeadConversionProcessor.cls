public class LeadConversionProcessor {
    
    public static void processLeadConversion(List<Lead> newLeadRecords) {
        List<Database.LeadConvert> leadsToConvert = new List<Database.LeadConvert>();
        
        for (Lead leadRec : newLeadRecords) {
            if (leadRec.Phone != null && 
                leadRec.Email != null && 
                leadRec.Weight__c != null && 
                leadRec.Height__c != null && 
                leadRec.ExternalId__c != null &&
                !leadRec.IsConverted) {
                
                Database.LeadConvert convertOperation = new Database.LeadConvert();
                convertOperation.setLeadId(leadRec.Id);
                
                LeadStatus conversionStatus = [SELECT Id, MasterLabel 
                                               FROM LeadStatus 
                                               WHERE IsConverted = true 
                                               LIMIT 1];
                convertOperation.setConvertedStatus(conversionStatus.MasterLabel);
                convertOperation.setDoNotCreateOpportunity(true);
                
                leadsToConvert.add(convertOperation);
            }
        }
        
        if (!leadsToConvert.isEmpty()) {
            List<Database.LeadConvertResult> conversionResults = Database.convertLead(leadsToConvert, false);
            
            for (Database.LeadConvertResult convResult : conversionResults) {
                if (!convResult.isSuccess()) {
                    for (Database.Error err : convResult.getErrors()) {
                        System.debug('Lead conversion error: ' + err.getMessage());
                    }
                }
            }
        }
    }
}