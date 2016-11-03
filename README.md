# Rails5 JWT Authentication with Facebook Login

This rails5 API application is a proof of concept for JWT authentication alongside facebook login.

It uses [Knock](https://github.com/nsarno/knock), which [doesn't provide multiple strategies](https://github.com/nsarno/knock/issues/11) (yet).

## Gems used

- [Knock](https://github.com/nsarno/knock) for API authentication.
- [Figaro](https://github.com/laserlemon/figaro) for ENV variables.
- [Koala](https://github.com/arsduo/koala) for facebook access_token validation and user information retrieval.
 
## Configuration

1) Configure figaro:

        cp config/application.yml.sample config/application.yml

2) Create a facebook application:

- Visit [Facebook Developers](https://developers.facebook.com/)
- Click **My Apps**, then select *_Add a New App_ from the dropdown menu
- Select **Website** platform and enter a new name for your app
- Click on the **Create New Facebook App ID** button
- Choose a **Category** that best describes your app
- Click on **Create App ID** button
- In the upper right corner click on **Skip Quick Star**
- Copy and paste _App ID_ and _App Secret_ keys into config/application.yml.

    _Note_: App ID is **FB_APP_ID**, App Secret is **FB_SECRET_KEY**
    
    For example:
        
        # config/application.yml
        FB_APP_ID: 'fb app id'
        FB_SECRET_KEY: 'fb secret key'

- Click on the *Settings* tab in the left nav, then click on **+ Add Platform**
- Select **Website**
- Enter http://localhost:3000 under Site URL

Note: those steps were based on [hackaton-starter github](https://github.com/sahat/hackathon-starter#obtaining-api-keys).

3) Database:

Sqlite for simplicity.

Just run

    rake db:migrate
        
## Running

    rails s
    
## API

The API endpoint for facebook authentication is

    POST /facebook_user_token
    
Which will create a user in the database using the facebook uid.
    
And the expected JSON payload

    {
        "auth": {
            "access_token": "facebook access token for the application"
        }
    }
    
You can get a valid _access_token_ for your facebook app using the [Graph API Explorer](https://developers.facebook.com/tools/explorer/)

Then, you can use CURL to retrieve a JWT Token:

    curl -H "Content-Type: application/json" -X POST -d '{"auth": {"access_token": "YOUR ACCESS_TOKEN"}}' http://localhost:3000/facebook_user_token

Example response from the API:
    
    201 Created
    {"jwt": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9"}
    
## How to get access_token using Facebook Web SDK

Head to [Facebook Login for the Web with the JavaScript SDK >>](https://developers.facebook.com/docs/facebook-login/web) for a working example.

The ```statusChangeCallback``` function is called with the results of a login attempt. You can access to the user access token in this function:

    // This is called with the results from from FB.getLoginStatus().
    function statusChangeCallback(response) {
        if (response.status === 'connected') {
            var accessToken = esponse['authResponse']['accessToken'];
            // EXAMPLE: Register or authenticate the user in our API
            $.post('/facebook_user_token', { auth: { access_token: accessToken } })
                .done(function(data){
                    console.log('jwt token:', data['jwt']);
                })
                .fail(function(error){
                    console.log(error);
                })
        }
    }