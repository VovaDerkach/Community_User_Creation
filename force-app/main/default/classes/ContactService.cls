public with sharing class ContactService {

    private List<Contact> records;

    public ContactService() {
        records = new List<Contact>();
    }

    public ContactService(List<Contact> records) {
        this.records = records;
    }

    public Set<Id> getCustomerContactIds() {
        Set<Id> result = new Set<Id>();

        for (Contact cont : records) {
            if (cont.IsCustomer__c) {
                result.add(cont.Id);
            }
        }

        return result;
    }

    public List<Contact> getNewNonCustomerContacts(Map<Id, Contact> oldContacts) {
        List<Contact> result = new List<Contact>();

        if (oldContacts == null || oldContacts.isEmpty()) {
            return result;
        }

        for (Contact cont : records) {
            if (oldContacts.get(cont.Id).IsCustomer__c && !cont.IsCustomer__c) {
                result.add(cont);
            }
        }

        return result;
    }

    public List<Contact> getNewCustomerContacts(Map<Id, Contact> oldContacts) {
        List<Contact> result = new List<Contact>();

        if (oldContacts == null || oldContacts.isEmpty()) {
            return result;
        }

        for (Contact cont : records) {
            if (!oldContacts.get(cont.Id).IsCustomer__c && cont.IsCustomer__c) {
                result.add(cont);
            }
        }

        return result;
    }
}