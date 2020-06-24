@IsTest
public with sharing class TestUtils {
    public static final Boolean DO_INSERT = true;
    public static final Boolean DO_NOT_INSERT = false;

    public static List<Account> createAccounts(Integer numOfAccounts, Boolean doInsert) {
        List<Account> accounts = new List<Account>();

        for (Integer i = 0; i < numOfAccounts; i++) {
            accounts.add(new Account(Name = 'Test ' + i));
        }

        if (doInsert) {
            insert accounts;
        }

        return accounts;
    }

    public static List<Contact> createContacts(Integer numOfContacts, Id accountId, Boolean doInsert) {
        List<Contact> contacts = new List<Contact>();

        for (Integer i = 0; i < numOfContacts; i++) {
            contacts.add(new Contact(
                    LastName = 'Test ' + i,
                    AccountId = accountId,
                    Email = 'testmail' + i + '@mail.com')
            );
        }

        if (doInsert) {
            insert contacts;
        }

        return contacts;
    }
}