trigger AutoLeadConversionTrigger on Lead (after insert, after update) {
    LeadConversionProcessor.handleLeadConversion(Trigger.new);
}