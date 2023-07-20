public with sharing class CareOpportunityHelper{
    public static map<id, decimal> MapperFunction(list<Opportunity> Opps, list<Care__c> Allaccounts){
        map<id, decimal> allMapper = new map<id, decimal>();

        for (Opportunity allOpps : Opps){
            Decimal x = 0;
            for (Care__c accs : Allaccounts){
                if (allOpps.Care__c == accs.Id){
                    for (Opportunity Oo : accs.Opportunities__r){
                        if (Oo.StageName == 'Closed Won'){
                            x += Oo.Amount;
                        }
                    }
                    System.debug(x);
                    allMapper.put(allOpps.Care__c, x);
                }
            }
        }
        return allMapper;
    }

    public static map<id, decimal> CountFunction(list<Opportunity> Opps, list<Care__c> Allaccounts){
        map<id, decimal> allCount = new map<id, decimal>();

        for (Opportunity allOpps : Opps){
            Decimal x = 0;
            for (Care__c accs : Allaccounts){
                if (allOpps.Care__c == accs.Id){
                    for (Opportunity Oo : accs.Opportunities__r){
                        if (Oo.StageName == 'Closed Won'){
                            ++x;
                        }
                    }
                    System.debug(x);
                    allCount.put(allOpps.Care__c, x);
                }
            }
        }
        return allCount;
    }

    public static map<id, decimal> MinFunction(list<Opportunity> Opps, list<Care__c> Allaccounts){
        map<id, decimal> MIN = new map<id, decimal>();


        for (Opportunity allOpps : Opps){
            List<Decimal> myList = new List<Decimal>();
            for (Care__c accs : Allaccounts){
                if (allOpps.Care__c == accs.Id){
                    for (Opportunity Oo : accs.Opportunities__r){
                        if (Oo.StageName == 'Closed Won'){
                            mylist.add(Oo.Amount);
                        }
                    }
                    mylist.sort ();

                    MIN.put(allOpps.Care__c, mylist[0]);
                }
            }


        }
        return MIN;
    }

    //max
    public static map<id, decimal> MaxFunction(list<Opportunity> Opps, list<Care__c> Allaccounts){
        map<id, decimal> Max = new map<id, decimal>();


        for (Opportunity allOpps : Opps){
            List<Decimal> myList = new List<Decimal>();
            for (Care__c accs : Allaccounts){
                if (allOpps.Care__c == accs.Id){
                    for (Opportunity Oo : accs.Opportunities__r){
                        if (Oo.StageName == 'Closed Won'){
                            mylist.add(Oo.Amount);
                        }
                    }
                    mylist.sort ();
                    if (mylist.size() > 0){
                        integer y = mylist.size() - 1;
                        Max.put(allOpps.Care__c, mylist[y]);
                    }
                }
            }


        }
        return Max;
    }

    public static void AccountUpdate(map<id, decimal> allmaps, list<Care__c> acc, map<id, decimal> countMap, map<id, decimal> minMap, map<id, decimal> maxMap){

        for (Care__c accs : acc){
            accs.TotalOpportunityAmount__c = allmaps.get(accs.Id);
            accs.TotalOpportunityAverage__c = allmaps.get(accs.Id) / countMap.get(accs.id);
            accs.MinimumOpportunity__c = minMap.get(accs.Id);
            accs.MaxOpportunityAmount__c = maxMap.get(accs.Id);
        }

        // system.debug(acc[0].TotalOpportunityAmount__c);
        if (!acc.isEmpty()){
            update acc;
        }
    }

}