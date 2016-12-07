global class ExceptionHandler implements Messaging.InboundEmailHandler {
      global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
          if (email.plainTextBody <> null && email.subject <> null) {
              Exception__c exp = new Exception__c(Body__c = email.plainTextBody, Subject__c = email.subject);
              assignAccountAndClass(email.subject, exp);
              insert exp;
          }
          Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
          return result;
      }
      
      public void assignAccountAndClass(String subject, Exception__c exp) {
          list<String> splits = subject.split(' : ');
          String accountName = splits[0].replace('Developer script exception from', '').trim();
          String source = splits[1].trim();
          if (accountName <> null && accountName <> '') {
              list<Account> existingAccount = [SELECT Name FROM Account WHERE Name = :accountName LIMIT 1];
              if (existingAccount.size() > 0) {
                  exp.Account__c = existingAccount[0].Id;
              } else {
                  Account newAccount = new Account(Name = accountName);
                  insert newAccount;
                  exp.Account__c = newAccount.Id;
              }
          }
          if (source <> null && source <> '') {
              String sourceName = source;
              if (source.contains(' for job id ')) {
                  sourceName = 'Apex Job';
              }
              list<ErrorSource__c> existingSource = [SELECT Name FROM ErrorSource__c WHERE Name = :sourceName LIMIT 1];
              if (existingSource.size() > 0) {
                  exp.ErrorSource__c = existingSource[0].Id;
              } else {
                  ErrorSource__c newSource = new ErrorSource__c(Name = sourceName);
                  insert newSource;
                  exp.ErrorSource__c = newSource.Id;
              }
              
          }
      }
  }