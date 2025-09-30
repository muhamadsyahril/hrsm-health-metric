trigger AutoLeadConversionTrigger on Lead (after insert, after update) {
    LeadConversionProcessor.processLeadConversion(Trigger.new);
}