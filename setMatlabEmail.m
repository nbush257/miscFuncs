setpref('Internet','E_mail','nbushmatlab@gmail.com');
setpref('Internet','SMTP_Server','smtp.gmail.com');
setpref('Internet','SMTP_Username','nbushmatlab@gmail.com');
setpref('Internet','SMTP_Password','MATLABEMAIL');
 
props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class', ...
                  'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port','465');