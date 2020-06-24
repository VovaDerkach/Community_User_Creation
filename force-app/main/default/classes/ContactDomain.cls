public with sharing class ContactDomain extends Domain {
    private ContactService contactService;

    public ContactDomain(List<Contact> records) {
        super(records);
    }

    protected override void init(List<SObject> records) {
        super.init(records);
        contactService = new ContactService((List<Contact>) records);
    }

    public override void onAfterInsert(Map<Id, SObject> newMap) {
        Set<Id> contactIds = contactService.getCustomerContactIds();
        UserService.createCommunityUsersForCustomerContacts(contactIds);
    }

    public override void onAfterUpdate(Map<Id,SObject> newMap) {
        Set<Id> nonCustomerContactIds = new Map<Id, Contact>(contactService.getNewNonCustomerContacts((Map<Id, Contact>) Trigger.oldMap)).keySet();
        UserService.deactivateNonCustomerUsers(nonCustomerContactIds);

        Set<Id> customerContactIds = new Map<Id, Contact>(contactService.getNewCustomerContacts((Map<Id, Contact>) Trigger.oldMap)).keySet();
        UserService.upsertActiveCustomerUsers(customerContactIds);
    }
}