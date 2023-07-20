trigger CareOpportunityTrigger on Opportunity(after update ){

    TriggerFactory.initiateHandler(Opportunity.sObjectType);
}