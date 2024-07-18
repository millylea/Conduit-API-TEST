function fn() {
  var env = karate.env; // get system property 'karate.env'
  karate.log('karate.env system property was:', env);
  if (!env) {
    env = 'dev';
  }
  // API url variable
  var config = {
    apiURL: 'https://api.realworld.io/api/'
  }
  // login
  if (env == 'dev') {
    config.userEmail = 'thaole@gmail.com'
    config.userPassword = '12345'

  } else if (env == 'qa') {
    config.userEmail = 'thaole1@gmail.com'
    config.userPassword = '123456'
  }
  // header variable 
  var accessToken = karate.callSingle('classpath:helpers/CreateToken.feature', config).authtoken
  karate.configure('headers', {Authorization: 'Token ' + accessToken})

  return config;
}