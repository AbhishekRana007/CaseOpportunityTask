public with sharing class CareOpportunityHandler implements ITrigger{
    list<Care__c> AllCare = new list<Care__c>();
    map<id, decimal> mapedAccounts = new map<id, decimal>();
    map<id, decimal> mapedCount = new map<id, decimal>();
    map<id, decimal> mapedMin = new map<id, decimal>();
    map<id, decimal> mapedMax = new map<id, decimal>();
    public void bulkBefore(){
        system.debug('--- bulkBefore is called');
    }

    public void bulkAfter(){
        set<id> ids = new set<id>();
        List<Opportunity> opportunityList = (List<Opportunity>)Trigger.new;
        for (Opportunity acc : opportunityList){
            ids.add(acc.Care__c);
        }
        AllCare = [SELECT Name, Id, TotalOpportunityAmount__c, TotalOpportunityAverage__c, MinimumOpportunity__c, MaxOpportunityAmount__c, (SELECT Name, Id, Amount, StageName
                                                                                                                                            FROM Opportunities__r
                                                                                                                                            WHERE StageName = 'Closed Won')
                   FROM Care__c
                   WHERE Id IN (SELECT Care__c
                                FROM Opportunity
                                WHERE StageName = 'Closed Won') and Id in:ids];
        if (!AllCare.isEmpty()){
            mapedAccounts = CareOpportunityHelper.MapperFunction(trigger.new, AllCare);
            mapedCount = CareOpportunityHelper.CountFunction(trigger.new, AllCare);
            mapedMin = CareOpportunityHelper.MinFunction(trigger.new, AllCare);
            mapedMax = CareOpportunityHelper.MaxFunction(trigger.new, AllCare);
        }
        system.debug('--- bulkAfter is called');
    }

    public void beforeInsert(sObject so){
        system.debug('--- beforeInsert is called');
    }

    public void beforeUpdate(SObject oldSo, SObject so){
        system.debug('--- beforeUpdate is called');
    }

    public void beforeDelete(SObject so){
        system.debug('--- beforeDelete is called');
    }

    public void afterInsert(SObject so){
        system.debug('--- afterInsert is called');
    }

    public void afterUpdate(SObject oldSo, SObject so){

        system.debug('--- afterUpdate is called');
    }

    public void afterDelete(SObject so){
        system.debug('--- afterDelete is called');
    }

    public void andFinally(){
        if (!mapedAccounts.isEmpty()){
            CareOpportunityHelper.AccountUpdate(mapedAccounts, AllCare, mapedCount, mapedMin, mapedMax);
        }
        system.debug('--- andFinally called');
    }

}