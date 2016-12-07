@isTest
private class ExceptionHandlerTest {

    static testMethod void testCreateEmail() {
        // Create a new email, envelope object and Attachment
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        email.subject = 'Developer script exception from Coty Inc : StdCategoryTreeController : List index out of bounds: 0';
        email.plainTextBody = 'Apex script unhandled exception by user/organization: 005o0000001lK0x/00Do0000000Ir71' +
                              'Visualforce Page: /apex/bmcservicedesk__CMDBJsonGenerator ' +
                              'caused by: System.ListException: List index out of bounds: 0 ' +
                              'Class.BMCServiceDesk.StdCategoryTreeController.searchCategories: line 233, column 1' + 
                              'Class.BMCServiceDesk.CMDBJsonGeneratorController.generateCategoryTree: line 1097, column 1' + 
                              'Class.BMCServiceDesk.CMDBJsonGeneratorController.generateOutput: line 59, column 1' + 
                              'Class.BMCServiceDesk.CMDBJsonGeneratorController.__sfdc_output: line 10, column 1';
        env.fromAddress = 'info@salesforce.com';
        ExceptionHandler emailServiceObj = new ExceptionHandler();
        Test.startTest();
        emailServiceObj.handleInboundEmail(email, env );
        Test.stopTest();
        system.assertEquals(1, [SELECT ID FROM Exception__c].size());
        system.assertEquals(1, [SELECT ID FROM Account WHERE Name = 'Coty Inc'].size());
        system.assertEquals(1, [SELECT ID FROM ErrorSource__c  WHERE Name = 'StdCategoryTreeController'].size());
    }    
}