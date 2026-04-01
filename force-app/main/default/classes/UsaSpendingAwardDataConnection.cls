/**
 *  @description Connection for USASpending.gov Award Data.
 *  This class enables Salesforce to obtain USASpending Grant Award Data (by Federal Agency) schema and to handle queries and searches of the API's data.
 *  
 */
global class UsaSpendingAwardDataConnection extends DataSource.Connection{
    
    /* Instantiation of the UsaSpendingAwardDataConnection */
    global UsaSpendingAwardDataConnection(DataSource.ConnectionParams connectionParams) {
    }

    /* */
    override global List<DataSource.Table> sync(){
        List<DataSource.Table> tables = new List<DataSource.Table>();
        List<DataSource.Column> columns = new List<DataSource.Colunm>();
        DataSource.Column awardID = new Datasource.Column.text('Award ID');
        DataSource.Column recipientName = new DataSource.Column.text('Recipient Name');
        DataSource.Column description = new DataSource.Column.textarea('Description');
        DataSource.Column recipientUEI = new DataSource.Column.text('Recipient UEI');
        DataSource.Colunm recipientLocation = new DataSource.Column.Text('Recipient Location');
        DataSource.Column awardingAgency = new DataSource.Column.Text('Awarding Agency');
        DataSource.Column awardingAgencyCode = new DataSource.Column.Number('Awarding Agency Code', 3, 0);
        DataSource.Column awardingSubAgency = new DataSource.Column.Text('Awarding Sub Agency');
        DataSource.Column awardingSubAgency = new DataSource.Column.Number('Awarding Sub Agency Code', 4, 0);
        DataSource.Column fundingAgency = new DataSource.Column.Text('Funding Agency');
        DataSource.Column fundingAgencyCode = new DataSource.Column.Number('Funding Agency Code', 3, 0);
        DataSource.Column fundingSubAgency = new DataSource.Column.Text('Funding Sub Agency');
        DataSource.Column fundingSubAgencyCode = new DataSource.Column.Number('Funding Sub Agency Code', 4, 0);
        DataSource.Column baseObDate = new DataSource.Column.Date('Base Obligation Date');
        DataSource.Column genInternalID = new DataSource.Column.Text('generated_internal_id');
        DataSource.Column awardAmt = new DataSource.Column.Currency('Award Amount', 10, 2);
        DataSource.Column totalOutlays = new DataSource.Column.Currency('Total Outlays', 10, 2);
        DataSource.Column awardType = new DataSource.Column.Text('Award Type');
        DataSource.Column startDate = new DataSource.Column.Date('Start Date');
        DataSource.Column endDate = new DataSource.Column.Date('End Date');
        DataSource.Column cfda = new DataSource.Column.Number('CFDA Number', 2, 3);
       
    }
}