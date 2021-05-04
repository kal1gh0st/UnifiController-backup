# UnifiController-backup
![image](https://user-images.githubusercontent.com/56889513/116996951-74f61900-acdc-11eb-99c2-4aee5f90f781.png)

Backblaze

You’ll need to create a Backblaze account aswell as a Bucket. At the time of writing this is completely free.
With the account created, head over to the B2 page and sign up using the same email address. Verify your email, setup your phone number as well as the not needed but highly recommended two-factor authentication option.
When the processing is done you should be able to see “B2 Cloud Storage” in the left hand side menu of Backblazes “My account” section, this however might take a few minutes.
Begin by selecting “Show Account ID and Application Key” followed by “Create Application Key”, note the provided values, as these can’t for all intended purposes be changed later.
While you’re here, go ahead and create a Private Bucket, give it a unique name.


Make sure that the cronjob runs After the auto backup setup on the Controller, 15 minutes or so should be fine.
Make sure you swap the variables for B2_UNIFI.CONTROLLER.NAME and B2_UNIFI.CONTROLLER.NAME:BUCKETNAME-unifi to match your environment.
This setup will have a retention of 6 weeks in the bucket, to change thing, adjust the --max-age and --min-age values accordingly.
