@IsTest
private class ContactDomainTest {
    private static final String TEST_CONTACT_LASTNAME1 = 'Test Contact 1';
    private static final String TEST_CONTACT_LASTNAME2 = 'Test Contact 2';
    private static final String TEST_CONTACT_LASTNAME3 = 'Test Contact 3';
    private static final String TEST_CONTACT_LASTNAME4 = 'Test Contact 4';

    @TestSetup
    static void setup() {
        Account acc = TestUtils.createAccounts(1, TestUtils.DO_INSERT)[0];
        List<Contact> contacts = TestUtils.createContacts(4, acc.Id, TestUtils.DO_NOT_INSERT);
        contacts[0].LastName = TEST_CONTACT_LASTNAME1;
        contacts[1].LastName = TEST_CONTACT_LASTNAME2;

        contacts[2].LastName = TEST_CONTACT_LASTNAME3;
        contacts[2].IsCustomer__c = true;
        contacts[3].LastName = TEST_CONTACT_LASTNAME4;
        contacts[3].IsCustomer__c = true;

        insert contacts;

        contacts[2].IsCustomer__c = false;
        contacts[3].IsCustomer__c = false;
        update new List<Contact>{contacts[2], contacts[3]};
    }

    @IsTest
    static void testAfterInsert_CreateCommunityUsersForCustomerContacts() {
        Account acc = [SELECT Id FROM Account LIMIT 1];
        List<Contact> contacts = TestUtils.createContacts(2, acc.Id, TestUtils.DO_NOT_INSERT);

        Test.startTest();
            contacts[0].IsCustomer__c = true;
            contacts[1].IsCustomer__c = true;
            insert contacts;
        Test.stopTest();

        List<User> communityUsers = [SELECT Id FROM User WHERE Contact.Id = :contacts AND IsActive = TRUE];

        final Integer expectedNumOfCreatedUsers = 2;
        System.assertEquals(expectedNumOfCreatedUsers, communityUsers.size(), 'There is a mismatch in users size');
    }

    @IsTest
    static void testAfterUpdate_DeactivateNonCustomerUsers() {
        List<Contact> contacts = [SELECT Id FROM Contact WHERE LastName IN :new List<String>{TEST_CONTACT_LASTNAME1, TEST_CONTACT_LASTNAME2} LIMIT 2];
        contacts[0].IsCustomer__c = true;
        contacts[1].IsCustomer__c = true;
        update contacts;

        List<User> communityUsers = [SELECT Id FROM User WHERE Contact.Id IN :contacts AND IsActive = TRUE];

        final Integer expectedNumOfCreatedUsers = 2;
        System.assertEquals(expectedNumOfCreatedUsers, communityUsers.size(), 'There is a mismatch in users size');

        Test.startTest();
            contacts[0].IsCustomer__c = false;
            contacts[1].IsCustomer__c = false;
            update contacts;
        Test.stopTest();

        List<User> inactiveUsers = [SELECT Id FROM User WHERE Contact.Id IN :contacts AND IsActive = FALSE];

        final Integer expectedNumOfRetrievedUsers = 2;
        System.assertEquals(expectedNumOfRetrievedUsers, inactiveUsers.size(), 'There is a mismatch in users size');
    }

    @IsTest
    static void testAfterUpdate_UpsertActiveCustomerUsers_Create() {
        List<Contact> contacts = [SELECT Id FROM Contact WHERE LastName IN :new List<String>{TEST_CONTACT_LASTNAME1, TEST_CONTACT_LASTNAME2} LIMIT 2];
        List<User> communityUsers = [SELECT Id FROM User WHERE Contact.Id IN :contacts];
        System.assert(communityUsers.isEmpty(), 'There is a mismatch in users size');

        Test.startTest();
            contacts[0].IsCustomer__c = true;
            contacts[1].IsCustomer__c = true;
            update contacts;
        Test.stopTest();

        List<User> activeUsers = [SELECT Id FROM User WHERE Contact.Id IN :contacts AND IsActive = TRUE];

        final Integer expectedNumOfRetrievedUsers = 2;
        System.assertEquals(expectedNumOfRetrievedUsers, activeUsers.size(), 'There is a mismatch in users size');
    }

    @IsTest
    static void testAfterUpdate_UpsertActiveCustomerUsers_Update() {
        List<Contact> contacts = [SELECT Id FROM Contact WHERE LastName IN :new List<String>{TEST_CONTACT_LASTNAME3, TEST_CONTACT_LASTNAME4} LIMIT 2];

        Test.startTest();
            contacts[0].IsCustomer__c = true;
            contacts[1].IsCustomer__c = true;
            update contacts;
        Test.stopTest();

        List<User> activeUsers = [SELECT Id FROM User WHERE Contact.Id IN :contacts AND IsActive = TRUE];

        final Integer expectedNumOfRetrievedUsers = 2;
        System.assertEquals(expectedNumOfRetrievedUsers, activeUsers.size(), 'There is a mismatch in users size');
    }
}