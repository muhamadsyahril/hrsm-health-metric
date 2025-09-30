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
                if (convResult.isSuccess()) {
                    // Copy Lead custom fields to Account
                    Lead originalLead = [
                        SELECT Id, Weight__c, Height__c
                        FROM Lead 
                        WHERE Id = :convResult.getLeadId()
                        LIMIT 1
                    ];
                    
                    Account acc = [
                        SELECT Id FROM Account WHERE Id = :convResult.getAccountId()
                        LIMIT 1
                    ];
                    
                    acc.Weight__c = originalLead.Weight__c;
                    acc.Height__c = originalLead.Height__c;
                    update acc;
                    
                } else {
                    for (Database.Error err : convResult.getErrors()) {
                        System.debug('Lead conversion error: ' + err.getMessage());
                    }
                }
            }
        }
    }
}