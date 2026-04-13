/**
 *  @description Connection for USASpending.gov Award Data.
 *  This class enables Salesforce to obtain USASpending Grant Award Data (by Federal Agency) schema and to handle queries and searches of the API's data.
 *  
 */
global class UsaSpendingAwardDataConnection extends DataSource.Connection{
    
    /* Instantiation of the UsaSpendingAwardDataConnection */
    global UsaSpendingAwardDataConnection(DataSource.ConnectionParams connectionParams) {
    }

    override global List<DataSource.Table> sync(){
        List<DataSource.Table> tables = new List<DataSource.Table>();
        
        //Grant_Award__x External Object Columns
        List<DataSource.Column> awardColumns = new List<DataSource.Colunm>();
        //Grant_Recipient__x External Object Columns
        List<DataSource.Column> recipientColumns = new List<DataSource.Column>();

        /* Create table columns */
        DataSource.Column awardID = new Datasource.Column.text('Award ID');
        DataSource.Column description = new DataSource.Column.textarea('Description');
        DataSource.Column recipientName = new DataSource.Column.text('Recipient Name');
        DataSource.Column recipientLookup = new DataSource.Column.externalLookup('Recipient UEI', 'Grant_Recipient__x');
        DataSource.Column recipientLocation = new DataSource.Column.Text('Recipient Location');
        DataSource.Column awardingAgency = new DataSource.Column.Text('Awarding Agency');
        DataSource.Column awardingAgencyCode = new DataSource.Column.indirectLookup('Awarding Agency Code', 'Account', 'Agency_Code__c');
        DataSource.Column awardingSubAgency = new DataSource.Column.Text('Awarding Sub Agency');
        DataSource.Column awardingSubAgencyCode = new DataSource.Column.indirectLookup('Awarding Sub Agency Code', 'Account', 'Agency_Code__c');
        DataSource.Column fundingAgency = new DataSource.Column.Text('Funding Agency');
        DataSource.Column fundingAgencyCode = new DataSource.Column.indirectLookup('Funding Agency Code', 'Account', 'Agency_Code__c');
        DataSource.Column fundingSubAgency = new DataSource.Column.Text('Funding Sub Agency');
        DataSource.Column fundingSubAgencyCode = new DataSource.Column.indirectLookup('Funding Sub Agency Code', 'Account', 'Agency_Code__c');
        DataSource.Column baseObDate = new DataSource.Column.Date('Base Obligation Date');
        DataSource.Column genInternalID = new DataSource.Column.Text('generated_internal_id');
        DataSource.Column awardAmt = new DataSource.Column.Number('Award Amount', 10, 2);
        DataSource.Column totalOutlays = new DataSource.Column.Number('Total Outlays', 10, 2);
        DataSource.Column awardType = new DataSource.Column.Text('Award Type');
        DataSource.Column startDate = new DataSource.Column.Date('Start Date');
        DataSource.Column endDate = new DataSource.Column.Date('End Date');
        DataSource.Column cfda = new DataSource.Column.Number('CFDA Number', 2, 3);
        DataSource.Column externalID = new DataSource.Column.text('ExternalID', 255);

        /* Assign columns to tables */
        recipientColumns.add(new Set<Database.Column>{recipientName, recipientUEI, recipientLocation, externalID});

        awardColumns.add(new Set<Database.Column>{awardID, recipientName, recipientLookup, recipientLocation, description, awardingAgency, awardingAgencyCode, awardingSubAgency, awardingSubAgencyCode, fundingAgency, fundingAgencyCode, fundingSubAgency, fundingSubAgencyCode, baseObDate, genInternalID, awardAmt, totalOutlays, awardType, startDate, endDate, cfda, externalID});

        tables.add(DataSource.Table.get('Results Table - Spending by award search','Grant Recipient', 'Grant Recipients', 'Recipients associated to Grant Awards', 'Recipient UEI', recipientColumns));
        tables.add(DataSource.Table.get('Results Table - Spending by award search', 'Grant Award', 'Grant Awards', 'Grant Award Documents', 'generated_internal_id', awardColumns));
        return tables;
    }
}