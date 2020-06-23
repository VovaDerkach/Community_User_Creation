public with sharing class UserService {
    public static String COMMUNITY_USER_PROFILE_NAME = 'Customer Community User';

    private List<User> records;

    public UserService() {
        records = new List<User>();
    }

    public UserService(List<User> records) {
        this.records = records;
    }

    public static Id communityUserProfileId {
        get {
            if (communityUserProfileId == null) {
                List<Profile> communityUserProfiles = [SELECT Id FROM Profile WHERE Name = :COMMUNITY_USER_PROFILE_NAME];

                if (communityUserProfiles.isEmpty()) {
                    communityUserProfileId = '';
                } else {
                    communityUserProfileId = communityUserProfiles[0].Id;
                }
            }

            return communityUserProfileId;
        }
        private set;
    }

    public static List<User> createCommunityUsersForCustomerContacts(Set<Id> contactIds) {
        if (String.isBlank(communityUserProfileId) || contactIds.isEmpty()) {
            return null;
        }

        List<User> result = new List<User>();

        for(Contact cont : [SELECT Name, LastName, FirstName, Email FROM Contact WHERE Id IN :contactIds LIMIT 50000]){
            User userRec = new User();
            userRec.LastName = cont.LastName;
            userRec.FirstName = cont.FirstName;
            userRec.Username = cont.Email;
            userRec.Email = cont.Email;
            userRec.Alias = cont.Name.length() >= 8 ? cont.Name.toLowerCase().substring(0, 8) : cont.Name.toLowerCase();
            userRec.ProfileId = communityUserProfileId;
            userRec.IsActive = true;
            userRec.TimeZoneSidKey = 'GMT';
            userRec.LanguageLocaleKey = 'en_US';
            userRec.EmailEncodingKey = 'UTF-8';
            userRec.LocaleSidKey = 'en_US';
            userRec.ContactId = cont.Id;

            result.add(userRec);
        }

        if (! result.isEmpty()) {
            insert result;
        }

        return result;
    }

    @future
    public static void deactivateNonCustomerUsers(Set<Id> contactIds) {
        List<User> users = [SELECT Id FROM User WHERE Contact.Id IN :contactIds AND IsActive = TRUE LIMIT 50000];

        for (User userRec : users) {
            userRec.IsActive = false;
        }

        update users;
    }

    @future
    public static void activateCustomerUsers(Set<Id> contactIds) {
        List<User> users = [SELECT Id FROM User WHERE Contact.Id IN :contactIds AND IsActive = FALSE LIMIT 50000];

        for (User userRec : users) {
            userRec.IsActive = true;
        }

        update users;
    }
}