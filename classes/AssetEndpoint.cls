/**
 * Created by b.jarmolinski on 05/04/2018.
 */
@RestResource(urlMapping = '/AssetApiOld')
global with sharing class AssetEndpoint {

    @HttpPost
    global static void createAssets() {

        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        String jsonBody = req.requestBody.toString();
        List<ObjectWrapper> owl = (List<ObjectWrapper>) JSON.deserialize(jsonBody, List<ObjectWrapper>.class);
        System.debug(owl);

        ObjectWrapper owAsset = owl[0];

        List<String> s = owAsset.IN_Date.split('/');
        List<String> h = owAsset.IN_Time.split(':');

        Integer day = Integer.valueOf(s[0]);
        Integer month = Integer.valueOf(s[1]);
        Integer year = Integer.valueOf(s[2]);

        Integer hours = Integer.valueOf(h[0]);
        Integer minutes = Integer.valueOf(h[1]);

        System.debug(hours);
        System.debug(minutes);

        CommissioningAssistant__mdt ca = [SELECT DefaultContactId__c FROM CommissioningAssistant__mdt WHERE Label = 'Settings' LIMIT 1];

        // all ObjectWrapper fields names to string
        String selects;
//        String jsonInst = JSON.serialize(owAsset);
//        Map<String, Object> fieldMap = (Map<String, Object>) JSON.deserializeUntyped(jsonInst);
//        System.debug(fieldMap.keySet());
//        Set<String> sSet = fieldMap.keySet();
//        List<String> sList = new List<String>();
//        sList.addAll(sSet);
//        for (Integer i=0; i < sSet.size(); i++){
//            if (i==0) {
//                selects = sList[i];
//            } else {
//                selects = selects + ', ' + sList[i];
//            }
//        }
        selects = 'INClientSalutation__c, INClientFirstName__c, INClientLastName__c, INClientStreet__c, INClientAdditionToAddress__c, INClientZIPCode__c, INClientPhoneNumber__c';
        System.debug(selects);
        //

        //query existing assets
        //List<Asset> assets = Database.query('SELECT ' + selects + ' ' + 'FROM Asset WHERE SerialNumber = :owAsset.DE_Ticket_Number');
        List<Asset> assets = [SELECT INClientSalutation__c, INClientFirstName__c, INClientLastName__c, INClientStreet__c, INClientAdditionToAddress__c, INClientZIPCode__c, INClientPhoneNumber__c FROM Asset WHERE SerialNumber = :owAsset.DE_Ticket_Number];
        Asset a = new Asset();

        if (assets.isEmpty()) {
            a.Name = '#' +owAsset.DE_Ticket_Number + ' ' + owAsset.IN_FirstName + ' ' + owAsset.IN_LastName;
            a.SerialNumber = owAsset.DE_Ticket_Number;
            a.Status = 'Installed';
            a.INClientSalutation__c = owAsset.IN_Gender;
            a.INClientFirstName__c = owAsset.IN_FirstName;
            a.INClientLastName__c = owAsset.IN_LastName;
            a.INClientStreet__c = owAsset.IN_Address1;
            a.INClientAdditionToAddress__c = owAsset.IN_Address2;
            a.INClientZIPCode__c = owAsset.IN_ZipCode;
            a.INClientPhoneNumber__c = owAsset.IN_Phone;
            a.INClientCity__c = owAsset.IN_City;
            a.INClientState__c = owAsset.IN_State;
            a.INClientCountry__c = owAsset.IN_Country;
            a.INClientEmail__c = owAsset.IN_Email;
            a.InClientEmail2__c = owAsset.IN_Email;
            a.INCommissioningDate__c = Date.newInstance(year, month, day);
            a.AccountId = null;
            a.CommissioningDateTime__c = DateTime.newInstance(year, month, day, hours, minutes, 0);

            List<Asset> assetList = new List<Asset>();
            assetList.add(a);
            DuplicateCheckHandler2 dch = new DuplicateCheckHandler2(assetList);
            a.AccountId = dch.handleObjects().get(a.Id);
        }

        else {
            a = assets[0];

            a.INClientSalutation__c = owAsset.IN_Gender;
            a.INClientFirstName__c = owAsset.IN_FirstName;
            a.INClientLastName__c = owAsset.IN_LastName;
            a.INClientStreet__c = owAsset.IN_Address1;
            a.INClientAdditionToAddress__c = owAsset.IN_Address2;
            a.INClientZIPCode__c = owAsset.IN_ZipCode;
            a.INClientPhoneNumber__c = owAsset.IN_Phone;
            a.INClientCity__c = owAsset.IN_City;
            a.INClientEmail__c = owAsset.IN_Email;
            a.INClientState__c = owAsset.IN_State;
            a.INClientCountry__c = owAsset.IN_Country;
            a.INCommissioningDate__c = Date.newInstance(year, month, day);
            a.CommissioningDateTime__c = DateTime.newInstance(year, month, day, hours, minutes, 0);
            a.InClientEmail2__c = owAsset.IN_Email;
            System.debug(a.CommissioningDateTime__c);

            List<Asset> assetList = new List<Asset>();
            assetList.add(a);
            DuplicateCheckHandler2 dch = new DuplicateCheckHandler2(assetList);
            a.AccountId = dch.handleObjects().get(a.Id);
        }

        upsert a;


    }

    //[SELECT DE_Ticket_Number, IN_Address1, IN_Address1]

    public class ObjectWrapper {
        public String DE_Ticket_Number;
        public String IN_Address1;
        public String IN_Address2;
        public String IN_City;
        public String IN_ContractId;
        public String IN_Country;
        public String IN_CustomerNumber ;
        public String IN_Date;
        public String IN_EarthingSystem;
        public String IN_Email;
        public String IN_EmailConfirm;
        public String IN_FEATURE_CHP;
        public String IN_FEATURE_MICROGRID;
        public String IN_FEATURE_PROTECT;
        public String IN_FEATURE_SCR;
        public String IN_FEATURE_TOU;
        public String IN_FLAT;
        public String IN_FLAT_CONCEPT;
        public String IN_FLAT_CONCEPT_DESCRIPTION;
        public String IN_FLAT_CONTRACT;
        public String IN_FLAT_OFFICIAL;
        public String IN_FLAT_PRODUCTION_METER;
        public String IN_FLAT_STORAGEPASSNR;
        public String IN_FirstName;
        public String IN_Gender;
        public String IN_IN_Certificate;
        public String IN_IN_Company;
        public String IN_IN_Email;
        public String IN_IN_FirstName;
        public String IN_IN_Gender;
        public String IN_IN_LastName;
        public String IN_IN_LegalConfirmation;
        public String IN_Inverter_Country_Code;
        public String IN_LastName;
        public String IN_PROTECT_ACTIVE;
        public String IN_PROTECT_CODE;
        public String IN_PROTECT_SERIAL;
        public String IN_Password;
        public String IN_Phone;
        public String IN_State;
        public String IN_SystemInstalled;
        public String IN_TZUTCOffset;
        public String IN_Time;
        public String IN_TimeZone;
        public String IN_ZipCode;
    }
}