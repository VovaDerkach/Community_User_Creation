# Community Users Creation by Volodymyr Derkach (June 2020)

After you've pushed the medatada to the scratch org please assign the 'Admin' permission set
by running the following command in your CLI:
`sfdx force:user:permset:assign -n Admin -u <your_user_name>`

## Additional Requirements

Before you start testing the functionality please ensure that following requirements are true on your org:

1. Communities are enabled.
2. Setup => Communities Settings => 'Allow using standard external profiles for self-registration and user creation' is 
checked.
3. Running User has a role.

